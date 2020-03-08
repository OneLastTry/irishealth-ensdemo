/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.Summary.Student'
/// on 2012-12-05 at 17:47:28.562 [2012-12-05 22:47:28.562 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Summary.Student.Record.Name Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Family As %String;

Property Given As %String;

Property Middle As %String;

Storage Default
{
<Data name="NameState">
<Value name="1">
<Value>Family</Value>
</Value>
<Value name="2">
<Value>Given</Value>
</Value>
<Value name="3">
<Value>Middle</Value>
</Value>
</Data>
<State>NameState</State>
<StreamLocation>^Demo.ComplexMap.SummaC2B6.NameS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
