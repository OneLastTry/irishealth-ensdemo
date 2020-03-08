/// RECORDMAP: Modified during compilation of RecordMap 'Demo.RecordMapBatch.Map.TrainDataIn'
/// on 2015-12-18 at 17:30:55.661 [2015-12-18 22:30:55.661 UTC]
/// by user UnknownUser
Class Demo.RecordMapBatch.Map.TrainDataIn.BatchIn Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "BatchIn";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader = "Line, Trip, PlatformKey, InformationType, Time, TimeRemaining, Revenue, Route";

Parameter HeaderTerm = "\x0d\x0a";

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As Demo.RecordMapBatch.Map.TrainDataIn.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "Demo_RecordMapBatch_Map_TrainDataIn_BatchIn";

Storage Default
{
<Data name="BatchInDefaultData">
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
<DataLocation>^Demo.RecordMapBatc3B98.BatchInD</DataLocation>
<DefaultData>BatchInDefaultData</DefaultData>
<IdLocation>^Demo.RecordMapBatc3B98.BatchInD</IdLocation>
<IndexLocation>^Demo.RecordMapBatc3B98.BatchInI</IndexLocation>
<StreamLocation>^Demo.RecordMapBatc3B98.BatchInS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
