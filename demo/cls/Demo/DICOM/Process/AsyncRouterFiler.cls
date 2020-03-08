/// Acts as the StorageSCU for a target image server (e.g. a PACS)
/// Invoked by sending a signal message, then
/// sends all DICOM message with status 'Queued' it finds in Demo.DICOM.BatchedDocument for 
/// the current session within a single DICOM association.
Class Demo.DICOM.Process.AsyncRouterFiler Extends EnsLib.DICOM.Process
{

Parameter SETTINGS = "OperationDuplexName,RemoveCompletedEntries,RetryCount,-FailureTimeout";

Parameter DOMAIN = "ENSDEMO";

/// If set to TRUE, status entries of DICOM documents sent to the 
/// target system successfully will be deleted from 
/// Demo.DICOM.BatchedDocument upon successful completion instead of being stored 
/// with a DocumentStatus of 'Delivered'
Property RemoveCompletedEntries As %Boolean [ InitialExpression = 0 ];

/// This is the name of the operation providing storage
Property OperationDuplexName;

/// In this demo, the process is ever in one of two states, the Operation is connected or not.
Property CurrentState As %String [ InitialExpression = "NotConnected" ];

/// This is the Session Id of the DICOM messages being sent
Property CurrentSessionId As %String;

/// This is the number of times to retry after the association with the PACS system encounters an error. </br>
/// -1 means never give up.
Property RetryCount As %Integer [ InitialExpression = 3 ];

/// Messages received here are primarily instances of EnsLib.DICOM.Document sent to this
/// process by the RouterDispatcher Process or RouterFiler config items.
Method OnMessage(pSourceConfigName As %String, pInput As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tSQL,tMsgType, tSOPInstanceUID, tErrorComment As %String
	#dim tStoreStatus, tBatchEntryId As %Integer
	#dim tRS As %SQL.StatementResult
	#dim tBatchEntry As Demo.DICOM.BatchedDocument
	#dim ex As %Exception.AbstractException
	
	Try {
		Do {
			If (pInput.%Extends("Ens.StringRequest")) {
				
				#; This the initial request of a new session
				Set ..CurrentSessionId = pInput.StringValue
				
				If ..CurrentState="NotConnected" {
					
	 				$$$TRACE($$$Text("Establishing association"))			
					Set tSC=..EstablishAssociation(..OperationDuplexName)				
				
				}  ElseIf ..CurrentState="OperationConnected" {
								
		 			#; The Operation is connected
	 				$$$TRACE($$$Text("Operation is connected"))
	 				
	 				#; Process first unsent DICOM document, we will be called back with the C-Store-Response
	 				Set tSC=..ProcessNextDicomDocument(..CurrentSessionId)
	 				If $$$ISERR(tSC) Quit
	 				
	 			}
			} ElseIf(pInput.%Extends("Ens.AlarmResponse")) {
				
				#; We are retrying
	 			$$$TRACE($$$Text("Re-establishing association"))			
				Set tSC=..EstablishAssociation(..OperationDuplexName)				
				
			} ElseIf (pInput.%Extends("EnsLib.DICOM.Document")) {
				
				#; Handle DICOM Documents here
				If (pSourceConfigName=..OperationDuplexName) {
					
					#; We have received a document from the operation
					Set tMsgType=$$$MsgTyp2Str(pInput.GetValueAt("CommandSet.CommandField",,.tSC))
					If $$$ISERR(tSC) Quit
				
					#; Should only EVER get a C-STORE-RSP
					$$$ASSERT(tMsgType="C-STORE-RSP")
					
					Set tStoreStatus=pInput.GetValueAt("CommandSet.Status",,.tSC)
					If $$$ISERR(tSC) Quit
					
					#; Try to get entry for the AffectedSOPInstanceUID
					Set tSOPInstanceUID=pInput.GetValueAt("CommandSet.AffectedSOPInstanceUID",,.tSC)
					If $$$ISERR(tSC) Quit
					
					#; Retrieve first DICOM document to which this document is a response
					Set tSQL="SELECT TOP 1 ID, SessionId, DICOMDocumentId,DocumentStatus from Demo_DICOM.BatchedDocument where SessionId=? and DocumentStatus='Sent' and FilerConfigName=? and AffectedSOPInstanceUID=?"
					Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL, ..CurrentSessionId, ..%ConfigName, tSOPInstanceUID)
					If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
						Set tSC = $$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message)
						Quit
					}
					
					If tRS.%Next() {
						Set tBatchEntryId=tRS.%Get("ID")
						Set tBatchEntry=##class(Demo.DICOM.BatchedDocument).%OpenId(tBatchEntryId)	
					
						#; A non zero status means something went wrong with the store
						If tStoreStatus'=0 {
							
							#; Get the ErrorComment
							Set tErrorComment = $$$FormatText($$$Text("Error: '%1'"),pInput.GetValueAt("CommandSet.ErrorComment",,.tSC))
							If $$$ISERR(tSC) Quit

							If $IsObject(tBatchEntry) {
								Set tBatchEntry.Remark=tErrorComment
								Set tBatchEntry.DocumentStatus="Errored"
								Set tSC=tBatchEntry.%Save()
								If $$$ISERR(tSC) Quit
							}
							
							#; Log the error information
							$$$LOGWARNING($$$FormatText($$$Text("Error in storing DICOM document with ID %1 (TableID=%2) : %3"),tBatchEntry.DICOMDocumentId,tBatchEntryId,tErrorComment))
							
						} Else {

							If $IsObject(tBatchEntry) {
								#; Mark entry as 'Delivered' for now, may remove later upon completion of the batch if RemoveCompletedEntries is set to true
								Set tBatchEntry.DocumentStatus="Delivered"
								#; Clear any previous remarks
								Set tBatchEntry.Remark=""
								Set tSC=tBatchEntry.%Save()
								If $$$ISERR(tSC) Quit
								
							} Else {
								// TODO: entry not found - should never happen

							}
						}
					}
					
					#; Process next unsent DICOM document, we will be called back again with the C-Store-Response
	 				Set tSC=..ProcessNextDicomDocument(..CurrentSessionId)
	 				If $$$ISERR(tSC) Quit
					
				}
				
			} Else {
				$$$ASSERT(0)
			}
			
		} while (0)
	} Catch ex {		
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method ProcessNextDicomDocument(pSessionId) As %Status
{
	#dim ex As %Exception.AbstractException
	#dim tSC As %Status=$$$OK
	#dim tRS As %SQL.StatementResult
	#dim tSQL,tMsgType As %String
	#dim tBatchEntry As Demo.DICOM.BatchedDocument
	#dim tDoc As EnsLib.DICOM.Document
	
	Try {
		#; Retrieve first DICOM documents from the current session with Status='Queued' or Status='Sent' (meaning encountered an error last time and we are in a retry loop)
		Set tSQL="SELECT TOP 1 ID, SessionId, DICOMDocumentId,DocumentStatus from Demo_DICOM.BatchedDocument where SessionId=? and (DocumentStatus='Queued' or DocumentStatus='Sent') and FilerConfigName=? order by ID"
		Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL, pSessionId, ..%ConfigName)
		If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
			Set tSC = $$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message)
			Quit
		}

		#; Release association if there are no more DICOM documents to process
		If 'tRS.%Next() {
			#; Now close the association with the operation, we will be called back at OnAssociationReleased()
			$$$TRACE($$$Text("Releasing association"))
			Set tSC=..ReleaseAssociation(..OperationDuplexName)
			If $$$ISERR(tSC) Quit
			
			If ..RemoveCompletedEntries {
				#; Remove entries from table now that all documents in the session have been successfully delivered
				Set tSQL="DELETE from Demo_DICOM.BatchedDocument where SessionId=? and DocumentStatus='Delivered' and FilerConfigName=?"
				Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL, pSessionId, ..%ConfigName)
				If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
					$$$LOGWARNING($$$FormatText($$$Text("Error in removing Demo.DICOM.BatchedDocument entries for successfully sent documents : %1"),$System.Status.GetErrorText($$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message))))
				}
			}

		} Else {
			
			#; Process message
			$$$TRACE($$$FormatText($$$Text("Processing DICOM document with ID: %1 (TableID=%2)"),tRS.%Get("DICOMDocumentId"),tRS.%Get("ID")))

			Set tBatchEntry=##class(Demo.DICOM.BatchedDocument).%OpenId(tRS.%Get("ID"))			
			$$$ASSERT($IsObject(tBatchEntry))
			
			Set tDoc=##class(EnsLib.DICOM.Document).%OpenId(tBatchEntry.DICOMDocumentId)
				
			#; Get the CommandField, it contains the type of request, it should ALWAYS be present
			Set tMsgType=$$$MsgTyp2Str(tDoc.GetValueAt("CommandSet.CommandField",,.tSC))
			If $$$ISERR(tSC) Quit

			#; We are only handling storage requests at present
			$$$ASSERT(tMsgType="C-STORE-RQ")

			#; We can forward the document to the operation
			Set tSC=..SendRequestAsync(..OperationDuplexName,tDoc,0)
			If $$$ISERR(tSC) Quit
			Set tBatchEntry.DocumentStatus="Sent"
			Set tSC=tBatchEntry.%Save()
			
		}		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// This call back is called by the framework when an Association is established
Method OnAssociationEstablished(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Established) As %Status
{
	#dim tSC As %Status = $$$OK
	
	If pSourceConfigName=..OperationDuplexName {
		
		#; The association with the operation has been completed, operation is now connected
		Set ..CurrentState="OperationConnected"
				
	 	#; The Operation is connected
		$$$TRACE($$$Text("Operation is connected"))
		
		#; Process first unsent DICOM document, we will be called back with the C-Store-Response
		Set tSC=..ProcessNextDicomDocument(..CurrentSessionId)
	} 
	Quit tSC
}

Method OnAssociationReleased(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Released) As %Status
{
    $$$ASSERT(pSourceConfigName=..OperationDuplexName)
        
    #; The association between this process and the operation has been released, so we are now not connected to the operation
    Set ..CurrentState="OperationNotConnected"
    
    Quit $$$OK
}

/// This method is called when any error occurs. Returning the same error will cause the BusinessProcess to set its
/// status to error and close down
Method OnError(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	#dim tCommandAbort As EnsLib.DICOM.Command.Abort
	#dim tSQL,tErrorMsg As %String
	#dim tAlert As Ens.AlertRequest
	#dim tSessionId As %String = ..CurrentSessionId
	#dim tFilerName As %String = ..%ConfigName
	#dim tRS As %SQL.StatementResult
	#dim tCount,SQLCODE,tSqlCode As %Integer
	
    #; If we are in conversation with the operation, we need to tell the operation to ABORT its association
    If ..CurrentState="OperationConnected" {
        
        #; Form an abort message
        Set tCommandAbort=##class(EnsLib.DICOM.Command.Abort).%New($$$ABORTSOURCESERVICEUSER,$$$ABORTREASONNOTSPECIFIED)
        
        #; Send it to the operation
        Do ..AbortAssociation(..OperationDuplexName,tCommandAbort)
        
        #; The operation is disconnected after the abort
        Set ..CurrentState="NotConnected"
    }
    
	#; Are there DICOM documents that haven't been delivered?
	&sql(SELECT count(*) into :tCount from Demo_DICOM.BatchedDocument where SessionId=:tSessionId and (DocumentStatus='Queued' or DocumentStatus='Sent') and FilerConfigName=:tFilerName)
    Set tSqlCode = SQLCODE	
    	
    #; If there are/might be any undelivered documents, re-queue all documents from this session so that the entire batch can be resent
    If (tSqlCode && (tSqlCode'=100)) || (tCount'=0) {
		Set tSQL="UPDATE Demo_DICOM.BatchedDocument (DocumentStatus,Remark) VALUES ('Queued',?) where SessionId=? and (DocumentStatus='Delivered' or DocumentStatus='Errored' or DocumentStatus='Sent') and FilerConfigName=?"
		Set tRS=##class(%SQL.Statement).%ExecDirect(,tSQL, $$$Text("Re-queued after error encountered in filer"),tSessionId, ..%ConfigName)
		If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) {
			Set pErrorStatus = $$$ADDSC(pErrorStatus,$$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message))
		}
    }
    
    #; Form the alert message
    Set tAlert = ##class(Ens.AlertRequest).%New()
    If tSqlCode && (tSqlCode'=100) {
    	Set tErrorMsg = $$$FormatText($$$Text("Filer '%1' errored in Session %2 with an unknown number of undelivered DICOM document(s)."),tFilerName,tSessionId) 
    } ElseIf tCount'=0 {
    	Set tErrorMsg = $$$FormatText($$$Text("Filer '%1' errored in Session %2 with %3 undelivered DICOM document(s)."),tFilerName,tSessionId,tCount) 
    } Else {
    	Set tErrorMsg = $$$FormatText($$$Text("Filer '%1' errored in Session %2."),tFilerName,tSessionId) 
    }
    Set tErrorMsg = tErrorMsg_$C(13,10,13,10)_$$$FormatText($$$Text("Error status: %1"),##class(%SYSTEM.Status).GetErrorText(pErrorStatus))
    Set tAlert.AlertText = tErrorMsg
    
    #; Send it to the alert processor
    Do ..SendAlert(tAlert)
    
	#; Don't ignore the error, this will cause the BP to terminate
	Quit pErrorStatus
}

/// This callback is called by the framework when an assocation encounters an error
Method OnAssociationErrored(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Errored) As %Status
{
	Quit ..RetryOrTerminate(pInput.Status)
}

/// This callback is called by the framework when an Association is rejected
Method OnAssociationRejected(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Rejected) As %Status
{
	#dim tRejectReason As %String
	
	#; The Operation is disconnected
	Set ..CurrentState="NotConnected"
	
	#; Identify the reject reason and return the appropriate error 
	Set tRejectReason = ##class(EnsLib.DICOM.Util.Encoding).REJECTREASON2EYE(pInput.Source,pInput.Reason)
	Quit $$$ERROR($$$EnsDICOMPeerRejectedAssociation,pSourceConfigName,tRejectReason)
}

/// This callback is called by the framework when an association is aborted
Method OnAssociationAborted(pSourceConfigName As %String, pInput As EnsLib.DICOM.Notify.Aborted) As %Status
{
	Quit ..RetryOrTerminate($$$ERROR($$$EnsDICOMPeerRequestedAbort))
}

/// This method is called by OnAssociationErrored and OnAssociationAborted to determine what should be done after an error is encountered. 
/// Returns status $$$OK if retrying, otherwise it returns the error status
Method RetryOrTerminate(pError) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tTimeout As %Integer
	
	#; If there are retries remaining, decrease RetryCount and trigger wakeup call
    If ..RetryCount'=0 {
	    Set ..RetryCount=..RetryCount-1
	    
        #; The operation has become disconnected
        Set ..CurrentState="NotConnected"

	    #; Demonstrate Retry Logic, we will trigger a wakeup call and check for that in OnMessage()
	    Set tTimeout = +..RetryInterval
	    If tTimeout <= 0 Set tTimeout = 2
        Set tSC=..ScheduleWakeupCall(tTimeout)
        
        $$$LOGWARNING($$$FormatText($$$Text("Entering retry loop after association errored with status '%1'"),##class(%SYSTEM.Status).GetErrorText(pError))) 
    } Else {
        #; Failed after all retries
        Set tSC=pError
    }

	#; Don't ignore the error, this will cause the BP to terminate
	Quit tSC
}

/// This callback permits the transfer syntax to be overriden
Method OnDetermineTransferSyntax(Output pTransferSyntax) As %Status
{
	Set pTransferSyntax=""
	Quit $$$OK
}

Storage Default
{
<Data name="AsyncRouterFilerDefaultData">
<Subscript>"AsyncRouterFiler"</Subscript>
<Value name="1">
<Value>RemoveCompletedEntries</Value>
</Value>
<Value name="2">
<Value>OperationDuplexName</Value>
</Value>
<Value name="3">
<Value>CurrentState</Value>
</Value>
<Value name="4">
<Value>CurrentSessionId</Value>
</Value>
<Value name="5">
<Value>RetryCount</Value>
</Value>
</Data>
<DefaultData>AsyncRouterFilerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
