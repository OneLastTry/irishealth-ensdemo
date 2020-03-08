/// Stores Session id's and DICOM document id's for batch transfer
/// of DICOM images from AsyncRouterDispatcher to AsyncRouterFiler
/// so the filer can send all messages from a given session within
/// the same association context.
/// Entries of images sent to the target system successfully will
/// be updated with a DocumentStatus of 'Delivered'
Class Demo.DICOM.BatchedDocument Extends %Persistent
{

Property SessionId As %String [ SqlColumnNumber = 2 ];

Property FilerConfigName As %String [ SqlColumnNumber = 3 ];

Property DICOMDocumentId As %String [ SqlColumnNumber = 4 ];

Property DICOMMessageId As %String(MAXLEN = 2000) [ SqlColumnNumber = 5 ];

Property AffectedSOPInstanceUID As %String(MAXLEN = 2000) [ SqlColumnNumber = 6 ];

Property DocumentStatus As %String(VALUELIST = ",Queued,Ignored,Sent,Delivered,Errored") [ InitialExpression = "Queued", SqlColumnNumber = 7 ];

Property Remark As %String(MAXLEN = 2000) [ SqlColumnNumber = 8 ];

Property Created As Ens.DataType.UTC [ SqlColumnNumber = 9 ];

Property LastUpdated As Ens.DataType.UTC [ SqlColumnNumber = 10 ];

Index idxFilerConfigName On FilerConfigName [ Type = bitmap ];

Index idxAffectedSOPInstanceUID On AffectedSOPInstanceUID;

Index idxSessionId On SessionId;

Index idxDocumentStatus On DocumentStatus [ Type = bitmap ];

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	If insert {
		Set ..Created=$$$timeUTC
	} Else {
		
		Set ..LastUpdated=$$$timeUTC
	}
   Quit $$$OK
}

Storage Default
{
<Data name="BatchedDocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SessionId</Value>
</Value>
<Value name="3">
<Value>FilerConfigName</Value>
</Value>
<Value name="4">
<Value>DICOMDocumentId</Value>
</Value>
<Value name="5">
<Value>DICOMMessageId</Value>
</Value>
<Value name="6">
<Value>AffectedSOPInstanceUID</Value>
</Value>
<Value name="7">
<Value>DocumentStatus</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>Created</Value>
</Value>
<Value name="10">
<Value>LastUpdated</Value>
</Value>
</Data>
<DataLocation>^Demo.DICOM.BatchedDocumentD</DataLocation>
<DefaultData>BatchedDocumentDefaultData</DefaultData>
<IdLocation>^Demo.DICOM.BatchedDocumentD</IdLocation>
<IndexLocation>^Demo.DICOM.BatchedDocumentI</IndexLocation>
<StreamLocation>^Demo.DICOM.BatchedDocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
