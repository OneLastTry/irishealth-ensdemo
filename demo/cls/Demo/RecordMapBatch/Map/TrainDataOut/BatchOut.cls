/// RECORDMAP: Modified during compilation of RecordMap 'Demo.RecordMapBatch.Map.TrainDataOut'
/// on 2015-12-18 at 17:32:14.992 [2015-12-18 22:32:14.992 UTC]
/// by user UnknownUser
Class Demo.RecordMapBatch.Map.TrainDataOut.BatchOut Extends (%Library.Persistent, EnsLib.RecordMap.SimpleBatch)
{

Parameter XMLNAME = "BatchOut";

Parameter RECORDMAPGENERATED = 1;

Parameter BatchHeader = "Date,TrainID,Direction,Station,Time";

Parameter HeaderTerm = "\x0d\x0a";

Parameter BatchTrailer;

Parameter TrailerTerm;

Parameter IgnoreLeadingData = 0;

Relationship Records As Demo.RecordMapBatch.Map.TrainDataOut.Record [ Cardinality = many, Inverse = %ParentBatch ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ..deleteRecords({ID})
}

Parameter XMLTYPE = "Demo_RecordMapBatch_Map_TrainDataOut_BatchOut";

Storage Default
{
<Data name="BatchOutDefaultData">
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
<DataLocation>^Demo.RecordMapBat7CD0.BatchOutD</DataLocation>
<DefaultData>BatchOutDefaultData</DefaultData>
<IdLocation>^Demo.RecordMapBat7CD0.BatchOutD</IdLocation>
<IndexLocation>^Demo.RecordMapBat7CD0.BatchOutI</IndexLocation>
<StreamLocation>^Demo.RecordMapBat7CD0.BatchOutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
