/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Summary.SemesterHeader'
/// on 2012-12-05 at 17:47:28.213 [2012-12-05 22:47:28.213 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Summary.SemesterHeader.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index SemesterIDIdx On SemesterID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property SemesterID As %Integer;

Property Year As %Integer;

Property Name As %String;

Property NumWeeks As %Integer;

Property NumberStudents As %Integer;

Property AverageGPA As %Numeric;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Summary.SemesterHeader.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
}

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SemesterID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>NumWeeks</Value>
</Value>
<Value name="6">
<Value>NumberStudents</Value>
</Value>
<Value name="7">
<Value>AverageGPA</Value>
</Value>
<Value name="8">
<Value>Year</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.Sum5E5C.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.Sum5E5C.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.Sum5E5C.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.Sum5E5C.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
