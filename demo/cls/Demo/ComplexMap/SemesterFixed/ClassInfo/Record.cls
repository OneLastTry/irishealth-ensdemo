/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.SemesterFixed.ClassInfo'
/// on 2012-12-06 at 17:59:13.223 [2012-12-06 22:59:13.223 UTC]
/// by user DemoUser
Class Demo.ComplexMap.SemesterFixed.ClassInfo.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index ClassIDIdx On ClassID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property ClassID As %String(MAXLEN = 15);

Property SectionID As %String(MAXLEN = 10);

Property Title As %String(MAXLEN = 40);

Property Grade As %String(MAXLEN = 3);

Property StudentCount As %Integer(MAXVAL = 999);

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
}

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
<Value name="5">
<Value>Grade</Value>
</Value>
<Value name="6">
<Value>StudentCount</Value>
</Value>
<Value name="7">
<Value>SectionID</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.SemFix.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.SemFix.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.SemFix.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.SemFix.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
