/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Summary.Student'
/// on 2012-12-05 at 17:47:28.581 [2012-12-05 22:47:28.581 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Summary.Student.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Index StudentIDIdx On StudentID;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property StudentID As %Integer;

Property Name As Demo.ComplexMap.Summary.Student.Record.Name;

Property Grade As %Integer;

Property Email As %String;

Property Phone As %String;

Property NumberClasses As %Integer;

Property GPA As %Numeric;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Summary.Student.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<Value>Grade</Value>
</Value>
<Value name="5">
<Value>Email</Value>
</Value>
<Value name="6">
<Value>Phone</Value>
</Value>
<Value name="7">
<Value>NumberClasses</Value>
</Value>
<Value name="8">
<Value>GPA</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.Sum86EC.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.Sum86EC.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.Sum86EC.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.Sum86EC.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
