Class Demo.DICOM.Process.Storage Extends EnsLib.DICOM.Process
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

/// Messages received here are instances of EnsLib.DICOM.Document sent to this
/// process by the service or operation config items. In this demo, the process is ever
/// in one of two states, the Operation is connected or not.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim tMsgType As %String
    do {
       
        #; We should only ever see DICOM Documents here
        $$$ASSERT(pInput.%Extends("EnsLib.DICOM.Document"))
        
        #; If its a document sent from the service
        If pSourceConfigName=..ServiceDuplexName {
            
            #; If the operation has not been connected yet
            If ..CurrentState="OperationNotConnected" {
                
                #; We are in the process of establishing the connection to the operation,
                #; Keep hold of the incoming document
                Set ..DocumentFromService=pInput
                
            } elseif ..CurrentState="OperationConnected" {
                
                #; The Operation is connected
                
                #; Get the CommandField, it contains the type of request, it should ALWAYS be present
                Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
                If $$$ISERR(tSC) Quit
        
                #; We are only handling storage requests at present
                $$$ASSERT(tMsgType="C-STORE-RQ")
        
                #; Record the originating message id because this will be updated when we
                #; send the message out to the operation
                Set ..OriginatingMessageID=pInput.GetValueAt("CommandSet.MessageID",,.tSC)
                If $$$ISERR(tSC) $$$LOGSTATUS(tSC) Quit
                
                #; We can forward the document to the operation
                Set tSC=..SendRequestAsync(..OperationDuplexName,pInput,0)
            }
            
        } elseif pSourceConfigName=..OperationDuplexName {
            
            #; We have received a document from the operation
            Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
            If $$$ISERR(tSC) Quit
            
            #; Should only EVER get a C-STORE-RSP
            $$$ASSERT(tMsgType="C-STORE-RSP")
        
            #; Update the message id being responded to
            Set tSC=pInput.SetValueAt(..OriginatingMessageID,"CommandSet.MessageIDBeingRespondedTo") 
            $$$ASSERT('$$$ISERR(tSC))
            
            #; Need to copy over the transfer syntax
            If ..DocumentFromService.DataSet.TransferSyntax'="" {
                Set pInput.DataSet.TransferSyntax=..DocumentFromService.DataSet.TransferSyntax
            }

            #; Send the reply back to the service
            Set tSC=..SendRequestAsync(..ServiceDuplexName,pInput,0) 
            If $$$ISERR(tSC) Quit
            
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
        
    } else {
        
        #; Need to establish an associaton with the operation (we will be called back here at 
        #; OnAssociationEstablished()
        Set tSC=..EstablishAssociation(..OperationDuplexName)
    }
    
    Quit tSC
}

Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
    #dim tSC As %Status = $$$OK
    
    If pSourceConfigName=..ServiceDuplexName {
        
        #; The association between the modality and service has been released
        If ..CurrentState="OperationConnected" {
            
            #; The operation is connected we want to releaste the association
            Set tSC=..ReleaseAssociation(..OperationDuplexName)
        }
    } else {
        
        #; The association between this process and the operation has been released, so we are now
        #; not connected to the operation
        Set ..CurrentState="OperationNotConnected"
    }
    
    Quit tSC
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status [ Final ]
{
    #dim tSC,tStatus As %Status = $$$OK
    #dim tCommandAbort As EnsLib.DICOM.Command.Abort
    
    try {
        
        #; Only interested in Association being rejected by the operation
        If pSourceConfigName=..OperationDuplexName {
        
            #; Form an error message to get it logged
            Set tStatus=$$$EnsError($$$EnsDICOMPeerRejectedAssociation)
            
            #; Form an Abort message with reason
            Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONNOTSPECIFIED)
    
            #; Send it the the Service
            Set tSC=..AbortAssociation(..ServiceDuplexName,tCommandAbort)
        }
    
    } catch {
        Set tSC=$$$EnsSystemError
    }
    
    Quit tSC
}

/// This callback is called by the framework when an association encounters an error
Method OnAssociationErrored(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Errored) As %Status [ Final ]
{
    #dim tSC As %Status = $$$OK
    #dim tCommandAbort As EnsLib.DICOM.Command.Abort
    
    #; Log the Error Status So we can see what happened
    $$$LOGSTATUS(pInput.Status)
    
    #; Need to send an Abort command to the counterpart
    If pSourceConfigName = ..ServiceDuplexName {
        
        #; Form a command
        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
        
        #; Send it to the operation
        Set tSC=..AbortAssociation(..OperationDuplexName,tCommandAbort)
    } else {
        
        #; Form a command
        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONNOTSPECIFIED)
        
        #; Send it to the service
        Set tSC=..AbortAssociation(..ServiceDuplexName,tCommandAbort)
    }
    Quit tSC
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status [ Final ]
{
    #dim tSC As %Status = $$$OK
    #dim tCommand As EnsLib.DICOM.Command.Abort
    
    #; Need to send an Abort command to the counterpart
    Set tCommand=##class(EnsLib.DICOM.Command.Abort).%New(pInput.Source,pInput.Reason)
    
    If pSourceConfigName=..ServiceDuplexName {
        
        #; Send an abort to the operation
        Set tSC=..AbortAssociation(..OperationDuplexName,tCommand)
    } else {
        #; Send an abort to the service
        Set tSC=..AbortAssociation(..ServiceDuplexName,tCommand)
    }
    Quit tSC
}

/// This method is called when any error occurs. Returning the same error will cause the BusinessProcess to set its
/// status to error and close down
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
    #; Form an abort message
    Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEPROVIDER,$$$ABORTREASONNOTSPECIFIED)
    
    #; Send it to the service
    Do ..AbortAssociation(..ServiceDuplexName,tCommandAbort)
    
    #; If we are in conversation with the operation, we neet to tell the operation to ABORT its association
    If ..CurrentState="OperationConnected" {
        
        #; Form an abort message
        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
        
        #; Send it to the operation
        Do ..AbortAssociation(..OperationDuplexName,tCommandAbort)
    }
    Quit pErrorStatus
}

Storage Default
{
<Data name="StorageDefaultData">
<Subscript>"Storage"</Subscript>
<Value name="1">
<Value>OriginatingMessageID</Value>
</Value>
<Value name="2">
<Value>DocumentFromService</Value>
</Value>
<Value name="3">
<Value>DocumentFromOperation</Value>
</Value>
<Value name="4">
<Value>CurrentState</Value>
</Value>
<Value name="5">
<Value>OperationDuplexName</Value>
</Value>
</Data>
<DefaultData>StorageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
