/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Semester.Student'
/// on 2012-12-05 at 17:06:05.349 [2012-12-05 22:06:05.349 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Semester.Student.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index StudentIDIdx On StudentID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property StudentID As %Integer;

Property LastName As %String;

Property FirstName As %String;

Property MiddleName As %String;

Property Grade As %Integer;

Property Email As %String;

Property Phone As %String;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Semester.Student.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
}

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StudentID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>MiddleName</Value>
</Value>
<Value name="6">
<Value>Grade</Value>
</Value>
<Value name="7">
<Value>Email</Value>
</Value>
<Value name="8">
<Value>Phone</Value>
</Value>
<Value name="9">
<Value>LastName</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.SemStud.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.SemStud.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.SemStud.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.SemStud.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
