/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.SemesterFixed.StudentMap'
/// on 2012-12-06 at 18:01:20.705 [2012-12-06 23:01:20.705 UTC]
/// by user DemoUser
Class Demo.ComplexMap.SemesterFixed.StudentBatch Extends (EnsLib.RecordMap.ComplexBatch, Ens.Request) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Semester As Demo.ComplexMap.SemesterFixed.Semester.Record [ Required ];

Property Students As array Of Demo.ComplexMap.SemesterFixed.Student.Record(MINREPEATS = 1);

Storage Default
{
<Data name="StudentBatchDefaultData">
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
<DataLocation>^Demo.ComplexSFix.StudentBatchD</DataLocation>
<DefaultData>StudentBatchDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexSFix.StudentBatchD</IdLocation>
<IndexLocation>^Demo.ComplexSFix.StudentBatchI</IndexLocation>
<StreamLocation>^Demo.ComplexSFix.StudentBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
