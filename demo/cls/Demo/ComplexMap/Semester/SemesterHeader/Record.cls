/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Semester.SemesterHeader'
/// on 2012-12-05 at 17:06:05.014 [2012-12-05 22:06:05.014 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Semester.SemesterHeader.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index SemesterIDIdx On SemesterID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property SemesterID As %Integer;

Property Year As %Integer;

Property Name As %String;

Property NumWeeks As %Integer;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Semester.SemesterHeader.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<Value>Year</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.Sem.SH.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.Sem.SH.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.Sem.SH.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.Sem.SH.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
