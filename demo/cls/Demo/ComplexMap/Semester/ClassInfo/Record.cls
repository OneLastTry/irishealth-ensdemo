/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Semester.ClassInfo'
/// on 2012-12-05 at 17:47:29.005 [2012-12-05 22:47:29.005 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Semester.ClassInfo.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index ClassIDIdx On ClassID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property ClassID As %String;

Property SectionID As %String;

Property Title As %String;

Property Grade As %Integer;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Semester.ClassInfo.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<Value>SectionID</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.SemClsI.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.SemClsI.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.SemClsI.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.SemClsI.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
