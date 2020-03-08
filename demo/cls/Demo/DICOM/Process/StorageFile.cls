Class Demo.DICOM.Process.StorageFile Extends EnsLib.DICOM.Process
{

/// This parameter names the operation used to provide storage
Parameter SETTINGS = "OperationDuplexName";

/// This keeps track of the OriginatingMessageID
Property OriginatingMessageID As %Integer;

/// This is the incoming document from the business Sservice
Property DocumentFromService As EnsLib.DICOM.Document;

/// This keeps track of the current state of the process
Property CurrentState As %String [ InitialExpression = "OperationNotConnected" ];

/// This is the name of the operation providing storage
Property OperationDuplexName;

/// This is defines the number of times a storage operation should be retried
Property RetryCount As %Integer [ InitialExpression = 3 ];

/// Messages received here are instances of EnsLib.DICOM.Document sent to this
/// process by the service or operation config items. In this demo, the process is ever
/// in one of two states, the Operation is connected or not.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim tMsgType As %String
    do {
        
        If pInput.%Extends("Ens.AlarmResponse") {
            
            #; We are retrying, simulate 1st call
            
            #; Make sure we have a document
            Set pInput=..DocumentFromService
            
            $$$ASSERT(..CurrentState="OperationNotConnected")
        }
            
        #; If its a document sent from the service
        If pSourceConfigName'=..OperationDuplexName {
            
            #; If the operation has not been connected yet
            If ..CurrentState="OperationNotConnected" {
                
                #; We need to establish a connection to the operation,
                #; Keep hold of the incoming document
                Set ..DocumentFromService=pInput
                
                #; We will be called back at OnAssociationEstablished()
                Set tSC=..EstablishAssociation(..OperationDuplexName)
                
            } elseif ..CurrentState="OperationConnected" {
                
                #; The Operation is connected
                
                #; Get the CommandField, it contains the type of request, it should ALWAYS be present
                Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
                If $$$ISERR(tSC) Quit
        
                #; We are only handling storage requests at present
                $$$ASSERT(tMsgType="C-STORE-RQ")
        
                #; We can forward the document to the operation
                Set tSC=..SendRequestAsync(..OperationDuplexName,pInput,0) 
            }
            
        } elseif pSourceConfigName=..OperationDuplexName {
            
            #; We have received a document from the operation
            Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
            If $$$ISERR(tSC) Quit
            
            #; Should only EVER get a C-STORE-RSP
            $$$ASSERT(tMsgType="C-STORE-RSP")

            #; Now close the Association with the operation, we will be called back at
            #; OnAssociationReleased()
            Set tSC=..ReleaseAssociation(..OperationDuplexName)
            
            #; Finished with this document
            Set ..DocumentFromService="",..OriginatingMessageID=""
        }
    } while (0)
    
    Quit tSC
}

/// This method is called by the framework on successful establishment of an association
Method OnAssociationEstablished(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Established) As %Status
{
    #dim tSC As %Status = $$$OK
    
    If pSourceConfigName=..OperationDuplexName {
        
        #; The association with the operation has been completed, operation is now connected
        Set ..CurrentState="OperationConnected"
    
        #; Call the OnMessage() with he saved document ( if we have it )
        if ($IsObject(..DocumentFromService)) {
            Set tSC=..OnMessage(..ServiceDuplexName,..DocumentFromService)
        }   
    }
    
    Quit tSC
}

Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
    #dim tSC As %Status = $$$OK
    
    $$$ASSERT(pSourceConfigName=..OperationDuplexName)
        
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
    #dim tSC As %Status = $$$OK
    
    #; Demonstrate Retry Logic, we will trigger a wakeup call and check for that in OnMessage()
    Set ..RetryCount=..RetryCount-1
    
    If ..RetryCount'=0 {
        Set tSC=..ScheduleWakeupCall(2)
    } else {
        #; Failed after all retries
        Set tSC=pInput.Status
    }
    
    Quit tSC
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
    Set ..CurrentState="OperationNotConnected"
    Quit $$$OK
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status
{
    Set ..CurrentState="OperationNotConnected"
    Quit $$$OK
}

Storage Default
{
<Data name="StorageFileDefaultData">
<Subscript>"StorageFile"</Subscript>
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
<Value>RetryCount</Value>
</Value>
</Data>
<DefaultData>StorageFileDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
