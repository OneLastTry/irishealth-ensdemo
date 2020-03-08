/// RECORDMAP: Generated from RecordMap 'Demo.RecordMapBatch.Map.TrainDataOut'
/// on 2015-12-18 at 17:32:14.985 [2015-12-18 22:32:14.985 UTC]
/// by user UnknownUser
Class Demo.RecordMapBatch.Map.TrainDataOut.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property Date As %Date;

Property TrainID As %Integer;

Property Direction As %String;

Property Station As %String;

Property Time As %Time(XMLTIMEZONE = "IGNORE");

Relationship %ParentBatch As Demo.RecordMapBatch.Map.TrainDataOut.BatchOut [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Direction</Value>
</Value>
<Value name="5">
<Value>Station</Value>
</Value>
<Value name="6">
<Value>Time</Value>
</Value>
<Value name="7">
<Value>%ParentBatch</Value>
</Value>
<Value name="8">
<Value>TrainID</Value>
</Value>
</Data>
<DataLocation>^Demo.RecordMapBatch7CD0.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.RecordMapBatch7CD0.RecordD</IdLocation>
<IndexLocation>^Demo.RecordMapBatch7CD0.RecordI</IndexLocation>
<StreamLocation>^Demo.RecordMapBatch7CD0.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
