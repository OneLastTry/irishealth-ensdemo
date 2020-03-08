/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.SemesterFixed.ClassMap'
/// on 2012-12-06 at 17:59:50.300 [2012-12-06 22:59:50.300 UTC]
/// by user DemoUser
Class Demo.ComplexMap.SemesterFixed.ClassBatch Extends (EnsLib.RecordMap.ComplexBatch, Ens.Request) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Semester As Demo.ComplexMap.SemesterFixed.Semester.Record [ Required ];

Property Classes As array Of Demo.ComplexMap.SemesterFixed.ClassInfo.Record(MINREPEATS = 1);

Storage Default
{
<Data name="ClassBatchDefaultData">
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
<Data name="Classes">
<Attribute>Classes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Classes"</Subscript>
</Data>
<DataLocation>^Demo.ComplexMapSFix.ClassBatchD</DataLocation>
<DefaultData>ClassBatchDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMapSFix.ClassBatchD</IdLocation>
<IndexLocation>^Demo.ComplexMapSFix.ClassBatchI</IndexLocation>
<StreamLocation>^Demo.ComplexMapSFix.ClassBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
