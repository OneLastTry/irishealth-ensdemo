/// RECORDMAP: Modified during compilation of RecordMap 'Demo.RecordMap.Map.Delimited'
/// on 2010-09-30 at 16:20:02.221 [2010-09-30 21:20:02.221 UTC]
/// by user DemoUser
Class Demo.RecordMap.Map.Delimited.Batch Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch) [ Inheritance = right, ProcedureBlock ]
{

Parameter XMLTYPE = "Demo_RecordMap_Map_Delimited_Batch";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader = "DELIMITED_BATCH_HEADER";

Parameter HeaderTerm = "\x0d\x0a";

Parameter BatchTrailer;

Parameter TrailerTerm = "\x0d\x0a\x00";

Relationship Records As Demo.RecordMap.Map.Delimited.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set id = {ID}
	Set %ok = ..deleteRecords(id)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	Set tID = $$$oidPrimary(oid)
	Quit ..deleteRecords(tID)
}

ClassMethod deleteRecords(batchid As %String) As %Status [ Internal, Private, ServerOnly = 1 ]
{
	Set tStmt = ##class(%SQL.Statement).%New()
	Set tStatus = tStmt.%Prepare("DELETE FROM Demo_RecordMap_Map_Delimited.Record WHERE %ParentBatch = ?")
	If $$$ISERR(tStatus) Quit tStatus
	Set tRS = tStmt.%Execute(batchid)
	If tRS.%SQLCODE && (tRS.%SQLCODE '= 100) Quit $$$ERROR($$$SQLCode, tRS.%SQLCODE, tRS.%Message)
	Quit $$$OK
}

Storage Default
{
<Data name="BatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%Source</Value>
</Value>
<Value name="3">
<Value>BatchHeader</Value>
</Value>
<Value name="4">
<Value>BatchTrailer</Value>
</Value>
</Data>
<DataLocation>^Demo.RecordMap.Map.DC0CE.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.RecordMap.Map.DC0CE.BatchD</IdLocation>
<IndexLocation>^Demo.RecordMap.Map.DC0CE.BatchI</IndexLocation>
<StreamLocation>^Demo.RecordMap.Map.DC0CE.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
