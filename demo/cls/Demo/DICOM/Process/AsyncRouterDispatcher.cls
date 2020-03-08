/// <class>Demo.DICOM.Process.AsyncRouterDispatcher</class> acts as the target AET for other AET's
/// sending DICOM images using a DICOM C-STORE-Req. 
/// All images sent within an DICOM association context are stored. Once the association
/// is released by the sending AET, a signal message containing the session id
/// is sent to all configured DICOM Router/filers asynchronously (outside the DICOM
/// protocol). The files will then forward the stored images to the configured targets.
/// This allows for routing of DICOM images to multiple targets where the transfer to 
/// each individual target happens within a single association. This approach avoids 
/// performance issues when studies/series with lots of images are routed to multiple targets.
Class Demo.DICOM.Process.AsyncRouterDispatcher Extends EnsLib.DICOM.Process
{

Parameter SETTINGS = "FilerConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?productionName=@productionId&className=Demo.DICOM.Process.AsyncRouterFiler},RuleClass:Basic:selector?context={Ens.ContextSearch/SubclassOf?class=Demo.DICOM.Util.AbstractRoutingRule&abstract=0},StoreIgnoredEntries:Basic";

Parameter DOMAIN = "ENSDEMO";

/// This is the (comma separated) list of configuration names of the router filer process(es)
Property FilerConfigNames;

/// DICOM Routing Class to be used for evaluation if individual images are to be sent to the specified filer(s).
Property RuleClass As %String(MAXLEN = 2000);

/// If set to TRUE, status entries of DICOM documents not being sent to the target filer will be stored with a Document Status of 'Ignored'
Property StoreIgnoredEntries As %Boolean [ InitialExpression = 1 ];

/// Messages received here are instances of EnsLib.DICOM.Document sent to this process by the service.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tCounter As %Integer
	#dim tMsgType,tFilerName As %String
	#dim tOutput As EnsLib.DICOM.Document
	#dim tDCMBatch As Demo.DICOM.BatchedDocument
	#dim tRouteToFiler As %Boolean=1
	#dim tReason As %String=""
	
	Do {
		
		#; We should only ever see DICOM Documents here
		$$$ASSERT(pInput.%Extends("EnsLib.DICOM.Document"))
		
 		#; If its a document sent from the service
 		If pSourceConfigName=..ServiceDuplexName {
	 		
	 		If pInput.%Extends("EnsLib.DICOM.Document") {
	 		
				#; Get the CommandField, it contains the type of request and should ALWAYS be present
				Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
				If $$$ISERR(tSC) Quit	
				
				#; We should only ever see DICOM store requests here
				$$$ASSERT(tMsgType="C-STORE-RQ")

				#; Here we walk through the filer names and store the document id for each one.
				For tCounter=1:1:$Length(..FilerConfigNames,",") {
					
					#; Get one filer name
					Set tFilerName=$Piece(..FilerConfigNames,",",tCounter)
					
					#; Don't send to an empty filer
					If tFilerName'="" {
						
						#; Call RuleClass if it is specified
						If ..RuleClass'="" {
							If ##class(%Dictionary.CompiledClass).%ExistsId(..RuleClass) && ##class(%Dictionary.CompiledMethod).%ExistsId(..RuleClass_"||SendToTargetFiler") {
								
								Set tSC=$Classmethod(..RuleClass,"SendToTargetFiler",pInput,tFilerName,.tRouteToFiler, .tReason)
								If $$$ISERR(tSC) Quit
							} Else {
								
								Set tSC = $$$ERROR($$$GeneralError,$$$FormatText($$$Text("Invalid Rule Class specified. Routing method '%1' not defined"),..RuleClass_"||SendToTargetFiler"))
								Quit
							}
						}

						If tRouteToFiler || ..StoreIgnoredEntries {
							#; Store the document id as entry in Demo_DICOM.BatchedDocument
							Set tDCMBatch=##class(Demo.DICOM.BatchedDocument).%New()
							Set tDCMBatch.DICOMDocumentId=pInput.%Id()
							Set tDCMBatch.SessionId=..%SessionId
							Set tDCMBatch.FilerConfigName=tFilerName
							Set tDCMBatch.AffectedSOPInstanceUID=pInput.GetValueAt("CommandSet.AffectedSOPInstanceUID",,.tSC)
							Set tDCMBatch.DICOMMessageId=pInput.GetValueAt("CommandSet.MessageID",,.tSC)
							
							If 'tRouteToFiler {
								Set tDCMBatch.DocumentStatus="Ignored"
							
							}
							Set tDCMBatch.Remark=tReason
							
							Set tSC=tDCMBatch.%Save()
							
							#; Need to check status from loop above
							If $$$ISERR(tSC) Quit
						}
						
					}
				}
				If $$$ISERR(tSC) Quit
				
				#; We need to create a C-STORE-RSP and send to the modality
				Set tSC=..CreateStorageResponse(pInput,.tOutput)
				If $$$ISERR(tSC) Quit
				
				#; We HAVE created an output object
				$$$ASSERT($IsObject(tOutput))
				
				#; Send the reply back to the service ( don't want a response )
				Set tSC=..SendRequestAsync(..ServiceDuplexName,tOutput,0)
				If $$$ISERR(tSC) Quit

			}
		} 
	 		
	} while (0)
	
	Quit tSC
}

/// Create a storage response DICOM message
Method CreateStorageResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tTemp As %String
	
	Try {
		
		#; Create an instance of a DICOM Document to form the response
		Kill %objlasterror Set pDocOut=##class(EnsLib.DICOM.Document).%New()
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
		
		#; Finally set a success status
		Set tSC=pDocOut.SetValueAt(0,"CommandSet.Status") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// This callback is called by the framework when an assocation encounters an error
Method OnAssociationErrored(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Errored) As %Status
{
	#; Don't ignore the error, this will cause the BP to terminate
	Quit pInput.Status
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
	#; Don't ignore the error, this will cause the BP to terminate
	Quit $$$ERROR($$$EnsDICOMPeerRequestedAbort)
}

/// This method is called when any error occurs. Returning the same error will cause the BusinessProcess to set its
/// status to error and close down
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	#dim tCommandAbort As EnsLib.DICOM.Command.Abort
        
    #; Form an abort message
    Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
    
    #; Send it to the operation
    Do ..AbortAssociation(..ServiceDuplexName,tCommandAbort)
    
    #; Still send any DICOM documents which have been received along to the filers 
	Do ..SendToFilers()
	
	#; Don't ignore the error, this will cause the BP to terminate
	Quit pErrorStatus
}

/// This callback is called by the framework when an Association is released
Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
	#; Association release is the trigger for sending the signal message to the filers
	Quit ..SendToFilers()
}

/// Send a signal message containing the session id to all configured DICOM filers asynchronously
Method SendToFilers() As %Status
{
	#dim tSC As %Status=$$$OK
	#dim ex As %Exception.AbstractException
	#dim tRequest As Ens.StringRequest
	#dim tSessionId As %String
	#dim tCounter As %Integer
	#dim tCount As %Integer=0
	
	Try {
				
		Set tSessionId=..%SessionId
		
		#; Here we walk through the filer names and send the sessionId to each one that has DICOM documents to be sent.
		For tCounter=1:1:$Length(..FilerConfigNames,",") {
			
			#; Get one filer name
			Set tFilerName=$Piece(..FilerConfigNames,",",tCounter)
			
			#; Don't send to an empty filer
			If tFilerName'="" {

				#; Are there DICOM documents to be sent?
				&sql(SELECT count(*) into :tCount from Demo_DICOM.BatchedDocument where SessionId=:tSessionId and DocumentStatus='Queued' and FilerConfigName=:tFilerName)
				If tCount > 0 {
					
					Set tRequest=##class(Ens.StringRequest).%New()
					Set tRequest.StringValue=..%SessionId
			
					#; Send the request to the named filer ( don't want a reply )
					Set tSC=..SendRequestAsync(tFilerName,tRequest,0)
					If $$$ISERR(tSC) Quit
				}
			}
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()	
	}
	
	Quit tSC
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("FilerConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") {
			Set tOne=$ZStrip($P(tValue,",",i),"<>W")
			Continue:""=tOne
			Set pArray(tOne)=""
		}
	}
}

Storage Default
{
<Data name="AsyncRouterDispatcherDefaultData">
<Subscript>"AsyncRouterDispatcher"</Subscript>
<Value name="1">
<Value>FilerConfigNames</Value>
</Value>
<Value name="2">
<Value>RuleClass</Value>
</Value>
<Value name="3">
<Value>StoreIgnoredEntries</Value>
</Value>
</Data>
<DefaultData>AsyncRouterDispatcherDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
