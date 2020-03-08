Class Demo.DICOM.Process.StorageLocal Extends EnsLib.DICOM.Process
{

/// Messages received here are instances of EnsLib.DICOM.Document sent to this
/// process by the service. The received DICOM file will be sent to the operation for persisting
/// in the file system. If all is well a C-STORE-RSP is sent to the service to indicate to the DICOM
/// peer that the storage was successful. If an error occurs the Association with the DICOM peer will
/// be aborted, indicating that the storage was not successful.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim tMsgType,tMsgId As %String
	#dim tOutput As EnsLib.DICOM.Document
	
	Try {
		
		#; We should only ever see DICOM Documents here
		$$$ASSERT(pInput.%Extends("EnsLib.DICOM.Document"))
		
		#; We only ever get DICOM Documents from the Service
		$$$ASSERT(pSourceConfigName=..ServiceDuplexName)
		 	
 		#; Get the CommandField, it contains the type of request, it should ALWAYS be present
		Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
		If $$$ISERR(tSC) Quit

		#; We are only handling Storage Requests
		$$$ASSERT(tMsgType="C-STORE-RQ")

		#; Record the originating message id
		Set tMsgId=pInput.GetValueAt("CommandSet.MessageID",,.tSC)
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
		
		#; We can forward the document to the operation
		Set tSC=..SendRequestSync("Demo.DICOM.Operation.File",pInput)
		If $$$ISERR(tSC) Quit
			
		#; We need to send a reply to the service in all cases, so create an appropriate response
		Set tSC=..CreateStorageResponse(pInput,.tOutput)
		If $$$ISERR(tSC) Quit
		
		#; Send the reply back to the service ( don't want a response )
		Set tSC=..SendRequestAsync(..ServiceDuplexName,tOutput,0)
		If $$$ISERR(tSC) Quit
		
		#; Stop the private session to ensure each message gets its own session				
		Set tSC=..StopPrivateSession(..ServiceDuplexName)
		If $$$ISERR(tSC) Quit
		
	} catch (e) {
		Set tSC=e.AsStatus()
	}
	
	Quit tSC
}

/// Create a storage response DICOM message
Method CreateStorageResponse(pDocIn As EnsLib.DICOM.Document, Output pDocOut As EnsLib.DICOM.Document) As %Status
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
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPClassUID") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		
		#; Set the CommandField, this is a Storage Response
		Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-STORE-RSP"),"CommandSet.CommandField")
		If $$$ISERR(tSC) Quit
		
		#; And indicate the message id being responded to by copying over the originating message id
		Set tTemp=pDocIn.GetValueAt("CommandSet.MessageID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.MessageIDBeingRespondedTo") If $$$ISERR(tSC) Quit
		If $$$ISERR(tSC) Quit
		 
		#; Need to copy over the affected SOP instance id
		Set tTemp=pDocIn.GetValueAt("CommandSet.AffectedSOPInstanceUID",,.tSC)
		$$$ASSERT('$$$ISERR(tSC))
		
		Set tSC=pDocOut.SetValueAt(tTemp,"CommandSet.AffectedSOPInstanceUID") If $$$ISERR(tSC) Quit
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

/// This method is called when an error response is received
/// Returning the same error will cause the BusinessProcess to set its status to error and close down
/// Returning $$$OK from this method causes the BusinessProcess to recover from this error
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	#; Form an abort command
	Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONNOTSPECIFIED)
		
	#; Send it to the service, this tells the peer that the storage was not successful
	Do ..AbortAssociation(..ServiceDuplexName,tCommandAbort)
	
	#; Want to continue offering the service, even if this instance failed
	Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
