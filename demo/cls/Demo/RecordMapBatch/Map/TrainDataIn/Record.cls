/// RECORDMAP: Generated from RecordMap 'Demo.RecordMapBatch.Map.TrainDataIn'
/// on 2015-12-18 at 17:30:55.638 [2015-12-18 22:30:55.638 UTC]
/// by user UnknownUser
Class Demo.RecordMapBatch.Map.TrainDataIn.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property Line As %String;

Property Trip As %Integer;

Property PlatformKey As %String;

Property InformationType As %String;

Property Time As %String;

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As Demo.RecordMapBatch.Map.TrainDataIn.BatchIn [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Line</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>PlatformKey</Value>
</Value>
<Value name="5">
<Value>InformationType</Value>
</Value>
<Value name="6">
<Value>Time</Value>
</Value>
<Value name="7">
<Value>%ParentBatch</Value>
</Value>
<Value name="8">
<Value>Trip</Value>
</Value>
</Data>
<DataLocation>^Demo.RecordMapBatch3B98.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.RecordMapBatch3B98.RecordD</IdLocation>
<IndexLocation>^Demo.RecordMapBatch3B98.RecordI</IndexLocation>
<StreamLocation>^Demo.RecordMapBatch3B98.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
