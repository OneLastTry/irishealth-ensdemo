/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.SemesterFixed.Semester'
/// on 2012-12-06 at 17:55:25.784 [2012-12-06 22:55:25.784 UTC]
/// by user DemoUser
Class Demo.ComplexMap.SemesterFixed.Semester.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index SemesterIDIdx On SemesterID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property SemesterID As %Integer(MAXVAL = 9999);

Property Year As %Integer(MAXVAL = 9999);

Property Name As %String(MAXLEN = 10);

Property NumWeeks As %Integer(MAXVAL = 99);

Property RecordCount As %Integer(MAXVAL = 99999);

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<Value>RecordCount</Value>
</Value>
<Value name="7">
<Value>Year</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexSFix.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexSFix.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexSFix.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexSFix.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
