Class Demo.DICOM.Process.RouterFiler Extends EnsLib.DICOM.Process
{

/// This parameter names the operation used to provide storage
Parameter SETTINGS = "OperationDuplexName";

/// This is the name of the operation providing storage
Property OperationDuplexName;

Property CurrentState As %String [ InitialExpression = "NotConnected" ];

Property CurrentDocument As EnsLib.DICOM.Document;

/// Messages received here are primarily instances of EnsLib.DICOM.Document sent to this
/// process by the RouterDispatcher Process or RouterFiler config items.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tMsgType As %String
	#dim tStoreStatus As %Integer
	do {
		
		#; Handle DICOM Documents here
		If (pInput.%Extends("EnsLib.DICOM.Document")) {
			
			if (pSourceConfigName'=..OperationDuplexName) {
				
				If ..CurrentState="NotConnected" {
				
					#; Store the current document
					Set ..CurrentDocument=pInput
					
					Set tSC=..EstablishAssociation(..OperationDuplexName)
				
				}  elseif ..CurrentState="OperationConnected" {
	 			
		 			#; The Operation is connected
	 			
			 		#; Get the CommandField, it contains the type of request, it should ALWAYS be present
					Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
					If $$$ISERR(tSC) Quit
		
					#; We are only handling storage requests at present
					$$$ASSERT(tMsgType="C-STORE-RQ")
		
		 			#; We can forward the document to the operation
					Set tSC=..SendRequestAsync(..OperationDuplexName,pInput,0) 
	 			}
	 			
			} else {
				
				#; We have received a document from the operation
				Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
				If $$$ISERR(tSC) Quit
			
				#; Should only EVER get a C-STORE-RSP
				$$$ASSERT(tMsgType="C-STORE-RSP")
				
				#; Send the reply back to the dispatcher ( don't want a response )
				Set tSC = ..Reply(pInput)
				If $$$ISERR(tSC) Quit

				#; Now close the Association with the operation, we will be called back at
				#; OnAssociationReleased()
				Set tSC=..ReleaseAssociation(..OperationDuplexName)
				
				Set tStoreStatus=pInput.GetValueAt("CommandSet.Status",,.tSC)
				If $$$ISERR(tSC) Quit
				
				If tStoreStatus'=0 {
					
					#; May want to log an error status here, as a non zero status means
					#; something went wrong with the store
				}
			}
			
		} else {
			$$$ASSERT(0)
		}
		
	} while (0)
	
	Quit tSC
}

/// This method is called when any error occurs. Returning the same error will cause the BusinessProcess to set its
/// status to error and close down
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
    #; If we are in conversation with the operation, we neet to tell the operation to ABORT its association
    If ..CurrentState="OperationConnected" {
        
        #; Form an abort message
        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
        
        #; Send it to the operation
        Do ..AbortAssociation(..OperationDuplexName,tCommandAbort)
    }
    Quit pErrorStatus
}

/// This callback is called by the framework when an assocation encounters an error
Method OnAssociationErrored(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Errored) As %Status
{
	#; Don't ignore the error, this will cause the BP to terminate
	Quit pInput.Status
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status
{
	Set ..CurrentState="NotConnected"
	
	Quit $$$ERROR($$$EnsDICOMPeerRejectedAssociation)
}

/// This call back is called by the framework when an Association is established
Method OnAssociationEstablished(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Established) As %Status
{
	#dim tSC As %Status = $$$OK
	If pSourceConfigName=..OperationDuplexName {
		
		#; The association with the operation has been completed, operation is now connected
		Set ..CurrentState="OperationConnected"
	
		#; Call the OnMessage() with the saved document ( if we have it )
		if ($IsObject(..CurrentDocument)) {
			Set tSC=..OnMessage(..ServiceDuplexName,..CurrentDocument)
		}	
	} 
	Quit tSC
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
	Set ..CurrentState="NotConnected"
	
	Quit $$$ERROR($$$EnsDICOMPeerRequestedAbort)
}

/// This callback permits the transfer syntax to be overriden
Method OnDetermineTransferSyntax(Output pTransferSyntax) As %Status
{
	$$$ASSERT($IsObject(..CurrentDocument))

	Set pTransferSyntax=..CurrentDocument.DataSet.TransferSyntax
	
	Quit $$$OK
}

Storage Default
{
<Data name="RouterFilerDefaultData">
<Subscript>"RouterFiler"</Subscript>
<Value name="1">
<Value>OriginatingMessageID</Value>
</Value>
<Value name="2">
<Value>DocumentFromService</Value>
</Value>
<Value name="3">
<Value>CurrentState</Value>
</Value>
<Value name="4">
<Value>OperationDuplexName</Value>
</Value>
<Value name="5">
<Value>MessageID</Value>
</Value>
<Value name="6">
<Value>CurrentDocument</Value>
</Value>
</Data>
<DefaultData>RouterFilerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
