Class Demo.DICOM.Process.RouterDispatcher Extends EnsLib.DICOM.Process
{

/// This parameter lists the (comma seperated ) names of the RouterFiler business processes
Parameter SETTINGS = "FilerConfigNames";

/// This is the list of configuration names of the router filer process(es)
Property FilerConfigNames;

/// This is a list of router filer processes which we have sent documents to and have not yet received a response from
Property ActiveFilers As list Of %String;

/// This property stores the Status returned in C-STORE-RSP from the filers so that we can send the same Status to the modality
Property ResponseStatus As %String [ InitialExpression = 0 ];

/// This property stores ErrorComment returned in the C-STORE-RSP from the filers so that we can send the same ErrorComment to the modality 
Property ErrorComment As %String(MAXLEN = 64, TRUNCATE = 1);

/// This property records whether the filers returned an errored message, in which case we should send an Abort back to the modality
Property Abort As %Boolean [ InitialExpression = 0 ];

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("FilerConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

/// Messages received here are instances of EnsLib.DICOM.Document sent to this
/// process by the service or operation config items. In this demo, the process is ever
/// in one of two states, the Operation is connected or not.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tCounter As %Integer
	#dim tMsgType,tFilerName As %String
	
	do {
		
		#; We should only ever see DICOM Documents here
		$$$ASSERT(pInput.%Extends("EnsLib.DICOM.Document"))
		
 		#; If it's a document sent from the service
 		If pSourceConfigName=..ServiceDuplexName {
	 		
	 		If pInput.%Extends("EnsLib.DICOM.Document") {
	 		
				#; Get the CommandField, it contains the type of request and should ALWAYS be present
				Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
				If $$$ISERR(tSC) Quit	
				
				#; We should only ever see DICOM store requests here
				$$$ASSERT(tMsgType="C-STORE-RQ")
												
				#; Here we walk through the filer names and send the document to each.
				For tCounter=1:1:$Length(..FilerConfigNames,",") {
					
					#; Get one filer name
					Set tFilerName=$Piece(..FilerConfigNames,",",tCounter)
					
					#; Don't send to an empty filer
					If tFilerName'="" {
						
						#; Note: If the input document requires changes then you should Clone() the document before modifying and sending
						#; the clone to the filer

						#; Forward the C-STORE-RQ to the named filer ( don't wait for the reply before sending to other filers )
						Set tSC=..SendRequestAsync(tFilerName,pInput,1)
						If $$$ISERR(tSC) Quit
						
						#; Add the named filer to the list of filers from which we are awaiting a response
						Set tSC = ..ActiveFilers.Insert(tFilerName)
						If $$$ISERR(tSC) Quit
					}
				}

				#; Need to check status from loop above
				If $$$ISERR(tSC) Quit
			}
		} 
	 		
	} while (0)
	
	Quit tSC
}

/// Handle a 'Response'
Method OnResponse(request As Ens.Request, ByRef response As Ens.Response, callrequest As Ens.Request, callresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tKey,tMsgType,tStatus As %String
	#dim tOutput As EnsLib.DICOM.Document
	#dim ex As %Exception.SystemException

	Try {
		
		#; Check to see if this is one of the responses we are waiting for
		Set tKey = ..ActiveFilers.Find(..%CurrentResponseHeader.SourceConfigName)
		If ((""'=tKey) && callrequest.%Extends("EnsLib.DICOM.Document")) {
			
			#; Remove this filer from the list of filers we're waiting on
			Do ..ActiveFilers.RemoveAt(tKey)

			#; process the response
			If $IsObject(callresponse) && callresponse.%Extends("EnsLib.DICOM.Document") {
				
				#; Get the CommandField, it contains the type of request and should ALWAYS be present
				Set tMsgType=$$$MsgTyp2Str(callresponse.GetValueAt("CommandSet.CommandField",,.tSC))
				If $$$ISERR(tSC) Quit	
					
				#; We should only ever see DICOM store responses here
				$$$ASSERT(tMsgType="C-STORE-RSP")
				If (tMsgType '= "C-STORE-RSP") {
					Set ..Abort = 1
					Quit
				}
				
				#; Get the Status	
				Set tStatus=callresponse.GetValueAt("CommandSet.Status",,.tSC)
				If $$$ISERR(tSC) Quit
				
				#; If the response status is an error, store it now so we can send it back to the modality once we have received all the responses	
				If 0'=tStatus {
					Set ..ResponseStatus = tStatus
					
					#; Get the ErrorComment
					Set ..ErrorComment=callresponse.GetValueAt("CommandSet.ErrorComment",,.tSC)
					If $$$ISERR(tSC) Quit

				}
			} Else {
				#; We should only ever see C-STORE-RSP messages from the filers.  Anything else means  
				#; there was an error somewhere upstream, so we should send an ABORT back to the modality 
				Set ..Abort = 1
				
				If $$$ISERR(..%CurrentResponseHeader.ErrorStatus) {
				    #; Log the Error Status so we can see what happened
	    			$$$LOGSTATUS(..%CurrentResponseHeader.ErrorStatus)
				}

			}
									
			#; If this was the final response from the filers, send response to the modality
			If (0 = ..ActiveFilers.Size) {
								
				If ..Abort {
			        #; Form an abort message
			        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
			        
			        #; Send it to the service
			        Set tSC = ..AbortAssociation(..ServiceDuplexName,tCommandAbort)
			        
				} Else {
								
					#; We need to create a C-STORE-RSP and send to the modality
					Set tSC = ..CreateStorageResponse(callrequest,.tOutput,..ResponseStatus,..ErrorComment)
					If $$$ISERR(tSC) Quit
					
					#; We HAVE created an output object
					$$$ASSERT($IsObject(tOutput))
					
					#; Send the reply back to the service ( don't want a response )
					Set tSC=..SendRequestAsync(..ServiceDuplexName,tOutput,0)
				}
								
				#; Clear out status values
				Set ..ResponseStatus = 0
				Set ..ErrorComment = ""
				Set ..Abort = 0
			}
			
		} Else {
			Set tSC = ##super(request,response,callrequest,callresponse,pCompletionKey)
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Create a storage response DICOM message
Method CreateStorageResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document, pStatus As %String = 0, pComment As %String = "") As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tTemp As %String
	try {
		
		#; Get the current storage location
		Set tStorageLocation=..GetProductionSettingValue("StorageLocation",.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Create an instance of a DICOM Document to form the response
		Kill %objlasterror Set pDocOut=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
		If '$IsObject(pDocOut) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Need to copy over the AffectedSOPClassUID (mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPClassUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID")
		If $$$ISERR(tSC) Quit
		
		#; Set the CommandField, this is a Storage Response
		Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-STORE-RSP"),"CommandSet.CommandField")
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to by copying over the originating message id
		Set tTemp=pDocIn.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo")
		If $$$ISERR(tSC) Quit
		 
		#; Need to copy over the affected SOP instance id
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPInstanceUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPInstanceUID")
		If $$$ISERR(tSC) Quit
		
		#; Need to copy over the transfer syntax
		Set pDocOut.DataSet.TransferSyntax=pDocIn.DataSet.TransferSyntax
		
		#; Set the status to the value returned from the filers
		Set tSC=pDocOut.SetValueAt(pStatus,"CommandSet.Status")
		If $$$ISERR(tSC) Quit
		
		#; Set the ErrorComment if one was returned from the filers
		If ""'=pComment {
			Set tSC=pDocOut.SetValueAt(pComment,"CommandSet.ErrorComment")
			If $$$ISERR(tSC) Quit
		}
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

Storage Default
{
<Data name="RouterDispatcherDefaultData">
<Subscript>"RouterDispatcher"</Subscript>
<Value name="1">
<Value>FilerConfigNames</Value>
</Value>
<Value name="2">
<Value>ActiveFilers</Value>
</Value>
<Value name="3">
<Value>ResponseStatus</Value>
</Value>
<Value name="4">
<Value>ErrorComment</Value>
</Value>
<Value name="5">
<Value>Abort</Value>
</Value>
</Data>
<DefaultData>RouterDispatcherDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
