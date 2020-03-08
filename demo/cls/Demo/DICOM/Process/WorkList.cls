/// This class demonstrates how to handle DICOM C-FIND-RQ and respond with worklist entries
Class Demo.DICOM.Process.WorkList Extends EnsLib.DICOM.Process
{

/// This parameter influences the number of worklist entries returned by a C-FIND-RQ
Parameter SETTINGS = "NumberOfWorkListEntries";

Property NumberOfWorkListEntries As %Integer [ InitialExpression = 1 ];

/// This keeps track of the OriginatingMessageID
Property OriginatingMessageID As %Integer;

/// This is the incoming document from the business Sservice
Property DocumentFromService As EnsLib.DICOM.Document;

/// This keeps track of the number of replies sent to the worklist request
Property ReplyCounter As %Integer;

/// This provides a unique counter to disambiguate StudyInstances
Property StudyInstanceCounter As %Integer [ InitialExpression = 0 ];

// --------------------------------------------------------------------------------------------------

/// This method handles the C-FIND-RQ and C-CANCEL-RQ messages. The find request asks for a query to be performed using the criteria
/// specified in the request's data-set. The query *may* take significant time and produce many results so individual matches are reported
/// in one or more messages. The protocol requires that all messages bar the last one have their status set to 'Pending'. This
/// indicates to the client that there is more data coming. The last message has a status of 'Success' which means that the query
/// has finished. In this example, the selection criteria are ignored and 'dummy' patient records are returned. A production 
/// implementation would necessarily be more complex.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tMsgType As %String
	#dim tReply As EnsLib.DICOM.Document
	do {
		
		If pInput.%Extends("EnsLib.DICOM.Document") {
	 		
			#; Get the CommandField, it contains the type of request and should ALWAYS be present
			Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
			If $$$ISERR(tSC) Quit

			If tMsgType="C-FIND-RQ" {
			
				#; The incoming document is the source document
				Set ..DocumentFromService=pInput
		
				#; Send the required number of responses
				Set ..ReplyCounter=..NumberOfWorkListEntries
				
				#; Initialize the Study Instance Counter
				Set ..StudyInstanceCounter=0
		
				#; Set a timer, will get called back immediately
				Set tSC=..ScheduleWakeupCall(0)
			
			} elseif tMsgType="C-CANCEL-RQ" {
				
				#; We received a cancel, record that fact
				Set ..ReplyCounter=0
				
			} elseif tMsgType="N-CREATE-RQ" {
				
				Set tSC=..CreateNCreateResponse(pInput,.tReply)
				If $$$ISERR(tSC) Quit
				
				#; Send the reply back to the service ( don't want a response )
				Set tSC=..SendRequestAsync(..ServiceDuplexName,tReply,0)
				
			} else {
				Set tSC=$$$ERROR($$$EnsDICOMUnexpectedMessage,tMsgType)
			}
			
		} elseif pInput.%Extends("Ens.AlarmResponse") {
		
			If ..ReplyCounter=0 
			{
				#; No more to send, create and send a final respnse
				Set tSC=..CreateFinalFindResponse(..DocumentFromService,.tReply)
				If $$$ISERR(tSC) Quit
			
				#; Send the reply back to the service ( don't want a response )
				Set tSC=..SendRequestAsync(..ServiceDuplexName,tReply,0)
			
			} else {
			
				#; More to send, create and send an intermediate response
				Set tSC=..CreateIntermediateFindResponse(..DocumentFromService,.tReply)
				If $$$ISERR(tSC) Quit
			
				#; Send the reply back to the service ( don't want a response )
				Set tSC=..SendRequestAsync(..ServiceDuplexName,tReply,0)
			
				#; Decrement the reply counter
				Set ..ReplyCounter=..ReplyCounter-1
				
				#; Set the timer so we are called back again, we use 1 second here
				#; so that the user of the demo has a chance send a cancel request. In
				#; a production implementation this should be set to 0 seconds
				Set tSC=..ScheduleWakeupCall(1)
			}
			
		} else {
			
			#; We are not expecting any other messages here
			$$$ASSERT(0)
		}
 		
	} while (0)
	
	Quit tSC
}

/// This method is called when any error occurs. Returning the same error will cause the BusinessProcess to set its
/// status to error and close down
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONNOTSPECIFIED)
	Do ..AbortAssociation(..ServiceDuplexName,tCommandAbort)
	Quit pErrorStatus
}

// -----------------------------------------------------------------------------------------------------------------------

/// Create an Intermediate find response
Method CreateIntermediateFindResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tTemp As %String
	try {
		
		#; Increment the study instance counter
		Set ..StudyInstanceCounter=..StudyInstanceCounter+1
		
		#; Get the current storage location
		Set tStorageLocation=..GetProductionSettingValue("StorageLocation",.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Now create an instance of a message to form the response
		Kill %objlasterror Set pDocOut=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
		If '$IsObject(pDocOut) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Need to copy over the AffectedSOPClassUID (mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPClassUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to
		Set tTemp=pDocIn.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		 
		#; Set the CommandField, this is a Find Response
		Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-FIND-RSP"),"CommandSet.CommandField")
		If $$$ISERR(tSC) Quit
		
		#; Set the Status to 'Pending'. A Find response consists of multiple messages, each message that has worklist
		#; data should be sent with a status set to pending. The final message should contain no dataset and should have its
		#; status set to 'Success'
		/* 65281 = "Pending: Optional Keys Supported" */
		Set tSC=pDocOut.SetValueAt(65281,"CommandSet.Status") If $$$ISERR(tSC) Quit
					
		#; Need to copy over the transfer syntax
		Set pDocOut.DataSet.TransferSyntax=pDocIn.DataSet.TransferSyntax
		
		#; Now build the dataset. A real implementation would examine the request's dataset to determine and
		#; act upon the request matching criteria. Here we will just build a dummy worklist entry by way of an example
		
		Set tSC=pDocOut.SetValueAt("80372376","DataSet.AccessionNumber") 
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("Patient"_$Random(100)_"^Name","DataSet.PatientName")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("43171525","DataSet.PatientID")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("1.2.40.0.13.0.192.168.1.3.13594894.1206712911593."_..StudyInstanceCounter,"DataSet.StudyInstanceUID")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("RequestedProcedureDescription","DataSet.RequestedProcedureDescription")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("OT","DataSet.ScheduledProcedureStepSequence[1].Modality")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("StationAET","DataSet.ScheduledProcedureStepSequence[1].ScheduledStationAETitle")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("20080328","DataSet.ScheduledProcedureStepSequence[1].ScheduledProcedureStepStartDate")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("100151.000","DataSet.ScheduledProcedureStepSequence[1].ScheduledProcedureStepStartTime")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("ScheduledProcedureStepDescription","DataSet.ScheduledProcedureStepSequence[1].ScheduledProcedureStepDescription")
		If $$$ISERR(tSC)
		Set tSC=pDocOut.SetValueAt("80871868","DataSet.ScheduledProcedureStepSequence[1].ScheduledProcedureStepID")
		If $$$ISERR(tSC) Quit
		Set tSC=pDocOut.SetValueAt("91249028","DataSet.RequestedProcedureID")
		If $$$ISERR(tSC) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Create a Final Find Response
Method CreateFinalFindResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document) As %Status
{
	#dim tSC As %Status =$$$OK
	#dim tTemp As %String
	
	try {
	
		#; Get the current storage location
		Set tStorageLocation=..GetProductionSettingValue("StorageLocation",.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Now create an instance of a message to indicate that the find process is complete
		Kill %objlasterror Set pDocOut=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
		If '$IsObject(pDocOut) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Need to copy over the AffectedSOPClassUID (mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPClassUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to ( mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; Set the CommandField, this is a Find Response
		Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-FIND-RSP"),"CommandSet.CommandField")
		If $$$ISERR(tSC) Quit
		
		#; Need to copy over the transfer syntax
		Set pDocOut.DataSet.TransferSyntax=pDocIn.DataSet.TransferSyntax
		
		#; Set the Status to Success, this means the find process is complete
		/* 0 = SUCCESS */
		Set tSC=pDocOut.SetValueAt(0,"CommandSet.Status") If $$$ISERR(tSC) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

/// Create a response to N-CREATE-RQ
Method CreateNCreateResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document) As %Status
{
	#dim tSC As %Status =$$$OK
	#dim tTemp As %String
	
	try {
	
		#; Get the current storage location
		Set tStorageLocation=..GetProductionSettingValue("StorageLocation",.tSC)
		If $$$ISERR(tSC) Quit
		
		#; Now create an instance of a message to indicate that the find process is complete
		Kill %objlasterror Set pDocOut=##class(EnsLib.DICOM.Document).%New(tStorageLocation)
		If '$IsObject(pDocOut) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"EnsLib.DICOM.Document")) Quit
		
		#; Need to copy over the AffectedSOPClassUID (mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPClassUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to ( mandatory field)
		Set tTemp=pDocIn.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; Set the CommandField, this is a N-CREATE-RSP
		Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("N-CREATE-RSP"),"CommandSet.CommandField")
		If $$$ISERR(tSC) Quit
		
		#; Need to copy over the transfer syntax
		Set pDocOut.DataSet.TransferSyntax=pDocIn.DataSet.TransferSyntax
		
		#; Set the Status to Success, this means the process is complete
		/* 0 = SUCCESS */
		Set tSC=pDocOut.SetValueAt(0,"CommandSet.Status") If $$$ISERR(tSC) Quit
		
	} catch {
		Set tSC=$$$EnsSystemError
	}
	Quit tSC
}

Storage Default
{
<Data name="WorkListDefaultData">
<Subscript>"WorkList"</Subscript>
<Value name="1">
<Value>NumberOfWorkListEntries</Value>
</Value>
<Value name="2">
<Value>OriginatingMessageID</Value>
</Value>
<Value name="3">
<Value>DocumentFromService</Value>
</Value>
<Value name="4">
<Value>ReplyCounter</Value>
</Value>
<Value name="5">
<Value>StudyInstanceCounter</Value>
</Value>
</Data>
<DefaultData>WorkListDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
