/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.Semester.SemesterData'
/// on 2013-01-14 at 13:28:31.377 [2013-01-14 18:28:31.378 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Semester.Batch Extends (EnsLib.RecordMap.ComplexBatch, Ens.Request) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Semester As Demo.ComplexMap.Semester.SemesterHeader.Record [ Required ];

Property Students As array Of Demo.ComplexMap.Semester.Students [ Required ];

Storage Default
{
<Data name="BatchDefaultData">
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
<Data name="Students">
<Attribute>Students</Attribute>
<Structure>subnode</Structure>
<Subscript>"Students"</Subscript>
</Data>
<DataLocation>^Demo.ComplexMap.SemeD05B.BatchD</DataLocation>
<DefaultData>BatchDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.SemeD05B.BatchD</IdLocation>
<IndexLocation>^Demo.ComplexMap.SemeD05B.BatchI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.SemeD05B.BatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
