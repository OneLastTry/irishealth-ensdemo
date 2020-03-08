/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.Summary.SemesterSummary'
/// on 2012-12-05 at 17:47:28.204 [2012-12-05 22:47:28.204 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Summary.SummaryBatch Extends (EnsLib.RecordMap.ComplexBatch, Ens.Request) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Semester As Demo.ComplexMap.Summary.SemesterHeader.Record [ Required ];

Property Students As array Of Demo.ComplexMap.Summary.Students [ Required ];

Storage Default
{
<Data name="Students">
<Attribute>Students</Attribute>
<Structure>subnode</Structure>
<Subscript>"Students"</Subscript>
</Data>
<Data name="SummaryBatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Semester</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMpSum.SummaryBatchD</DataLocation>
<DefaultData>SummaryBatchDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMpSum.SummaryBatchD</IdLocation>
<IndexLocation>^Demo.ComplexMpSum.SummaryBatchI</IndexLocation>
<StreamLocation>^Demo.ComplexMpSum.SummaryBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
