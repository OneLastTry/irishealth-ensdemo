/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.SemesterFixed.Student'
/// on 2012-12-06 at 17:46:52.455 [2012-12-06 22:46:52.455 UTC]
/// by user DemoUser
Class Demo.ComplexMap.SemesterFixed.Student.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index StudentIDIdx On StudentID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property StudentID As %String(MAXLEN = 9);

Property LastName As %String(MAXLEN = 25);

Property FirstName As %String(MAXLEN = 20);

Property MiddleName As %String(MAXLEN = 20);

Property Grade As %Integer(MAXVAL = 99);

Property Email As %String(MAXLEN = 40);

Property Phone As %String(MAXLEN = 20);

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<DataLocation>^Demo.ComplexSFix.StuRecD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexSFix.StuRecD</IdLocation>
<IndexLocation>^Demo.ComplexSFix.StuRecI</IndexLocation>
<StreamLocation>^Demo.ComplexSFix.StuRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
