Class Demo.DICOM.Process.Modality Extends EnsLib.DICOM.Process
{

/// This parameter names the operation used to provide storage
Parameter SETTINGS = "OperationDuplexName";

/// This keeps track of the current state of the process
Property CurrentState As %String [ InitialExpression = "OperationNotConnected" ];

/// This is the name of the operation providing connectivity
Property OperationDuplexName;

/// This is the count of incoming responses
Property ResponseCount As %Integer [ InitialExpression = 0 ];

/// Request
Property Request As EnsLib.DICOM.Document;

/// Request Type (this can be "FIND" or "ECHO")
Property RequestType As %String [ InitialExpression = "FIND" ];

/// This specifies the number of C-FIND-RSP records to be recieved before sending a CANCEL
Property CancelThreshold As %Integer [ InitialExpression = 5 ];

/// Messages received here are instances of EnsLib.DICOM.Document sent to this
/// process by the service or operation config items. In this demo, the process is ever
/// in one of two states, the Operation is connected or not.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim tMsgType As %String
    #dim tOutput As EnsLib.DICOM.Document
    do {
        
        #; If its a document sent from the service
        If pSourceConfigName'=..OperationDuplexName {
            
            if (..CurrentState="OperationNotConnected") {
                
                Do ..TraceMessage("connecting")
                
                #; We will be called back at OnAssociationEstablished()
                Set tSC=..EstablishAssociation(..OperationDuplexName)
                
            } else {
               
                Do ..TraceMessage("in progress - ignored")
            }
               
        } elseif pSourceConfigName=..OperationDuplexName {
            
            #; We have received a document from the operation
            Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
            If $$$ISERR(tSC) Quit
            
            #; Should only EVER get an C-FIND-RSP
            $$$ASSERT((tMsgType="C-FIND-RSP")||(tMsgType="C-ECHO-RSP"))
            
            Do ..TraceMessage("received response")
            
            Set tLast=pInput.GetValueAt("CommandSet.Status",,.tSC)
            If $$$ISERR(tSC) Quit
            
            If tMsgType="C-ECHO-RSP" Set tLast=0
            
            If tLast'=0 {
                
                Set ..ResponseCount=..ResponseCount+1
                
                If ..ResponseCount=..CancelThreshold {
                    
                    Set tSC=..CreateCancelRequest(.tCancelRequest)
                    If $$$ISERR(tSC) Quit
                    
                     #; No response required    
                    Set tSC=..SendRequestAsync(..OperationDuplexName,tCancelRequest,0)
                }
     
                Do ..TraceMessage("more find responses to come")  
                 
            } else {
                
                Do ..TraceMessage("received last response")
                
                Set tSC=..ReleaseAssociation(..OperationDuplexName)
            }
        }
    } while (0)
    
    Quit tSC
}

/// This method is called by the framework on successful establishment of an association
Method OnAssociationEstablished(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Established) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
    
        $$$ASSERT(pSourceConfigName=..OperationDuplexName)
        
        Do ..TraceMessage("connected")
        
        Set ..ResponseCount = 0
        
        #; The association with the operation has been completed, operation is now connected
        Set ..CurrentState="OperationConnected"
        
        #; Send the find request
        Do ..TraceMessage("sending request")
                
        If ..RequestType="FIND" {
            
            #; Create a Generic Find Request
            Set tSC=..CreateFindRequest(.tRequest)
        } else {
            
            #; Create an Echo Request
            Set tSC=..CreateEchoRequest(.tRequest)
        }
        If $$$ISERR(tSC) Quit
        
        #; Stash the find request. When sent, the adapter will update the message id
        #; which is needed if we want to send a cancel
        Set ..Request=tRequest
            
        #; No response required    
        Set tSC=..SendRequestAsync(..OperationDuplexName,tRequest,0) 
    
    } catch(e) {
        Set tSC=e.AsStatus()
    }

    Quit tSC
}

Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
    #dim tSC As %Status = $$$OK
    
    $$$ASSERT(pSourceConfigName=..OperationDuplexName)
    
    Do ..TraceMessage("disconnected")
        
    #; The association between this process and the operation has been released, so we are now
    #; not connected to the operation
    Set ..CurrentState="OperationNotConnected"
    
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

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
    Do ..TraceMessage("peer aborted association")
    
    Set ..CurrentState="OperationNotConnected"
    Quit $$$OK
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status
{
    Do ..TraceMessage("peer rejected association")
    
    Set ..CurrentState="OperationNotConnected"
    Quit $$$OK
}

/// Write a message to the console
Method TraceMessage(pMessage As %String)
{
    #dim tIO
    Set tIO=$IO Use $Principal $$$TRACE(pMessage) Use tIO
}

/// Create a Cancel Request
Method CreateCancelRequest(Output pDocOut As EnsLib.DICOM.Document) As %Status
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
        
        #; Set the CommandField, this is a C-CANCEL Request
        Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-CANCEL-RQ"),"CommandSet.CommandField")
        If $$$ISERR(tSC) Quit
        
        #; Pick out the message Id of the request that we want to cancel
        Set tMsgId=..Request.GetValueAt("CommandSet.MessageID",,.tSC)
        If $$$ISERR(tSC) Quit
        
        #; And plug it into the cancel request
        Set tSC=pDocOut.SetValueAt(tMsgId,"CommandSet.MessageIDBeingRespondedTo") If $$$ISERR(tSC) Quit
        If $$$ISERR(tSC) Quit
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// Create an Echo Request
Method CreateEchoRequest(Output pDocOut As EnsLib.DICOM.Document) As %Status
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
        
        Set tSC=pDocOut.SetValueAt("1.2.840.10008.1.1","CommandSet.AffectedSOPClassUID")
        If $$$ISERR(tSC) Quit
        
        #; Set the CommandField, this is a C-ECHO Request
        Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-ECHO-RQ"),"CommandSet.CommandField")
        If $$$ISERR(tSC) Quit
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

/// Create a Find Request
Method CreateFindRequest(Output pDocOut As EnsLib.DICOM.Document) As %Status
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
        
        #; We will be performing a find at patient level
        Set tSC=pDocOut.SetValueAt("1.2.840.10008.5.1.4.1.2.1.1","CommandSet.AffectedSOPClassUID")
        If $$$ISERR(tSC) Quit
        
        #; Set the CommandField, this is a C-FIND Request
        Set tSC=pDocOut.SetValueAt($$$Str2MsgTyp("C-FIND-RQ"),"CommandSet.CommandField")
        If $$$ISERR(tSC) Quit
        
        #; Set the priority
        Set tSC = pDocOut.SetValueAt(0,"CommandSet.Priority")
        If $$$ISERR(tSC) Quit
    
        Set tSC = pDocOut.SetValueAt("PATIENT","DataSet.QueryRetrieveLevel")
        If $$$ISERR(tSC) Quit
    
        Set tSC = pDocOut.SetValueAt("","DataSet.PatientID")
        If $$$ISERR(tSC) Quit
            
        Set tSC = pDocOut.SetValueAt("","DataSet.SOPInstanceUID")
        If $$$ISERR(tSC) Quit
        
        Set tSC = pDocOut.SetValueAt("","DataSet.StudyInstanceUID")
        If $$$ISERR(tSC) Quit
        
        Set tSC = pDocOut.SetValueAt("","DataSet.SeriesInstanceUID")
        If $$$ISERR(tSC) Quit
        
    } catch {
        Set tSC=$$$EnsSystemError
    }
    Quit tSC
}

Storage Default
{
<Data name="ModalityDefaultData">
<Subscript>"Modality"</Subscript>
<Value name="1">
<Value>CurrentState</Value>
</Value>
<Value name="2">
<Value>OperationDuplexName</Value>
</Value>
<Value name="3">
<Value>ResponseCount</Value>
</Value>
<Value name="4">
<Value>Request</Value>
</Value>
<Value name="5">
<Value>RequestType</Value>
</Value>
<Value name="6">
<Value>CancelCount</Value>
</Value>
<Value name="7">
<Value>CancelThreshold</Value>
</Value>
</Data>
<DefaultData>ModalityDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
