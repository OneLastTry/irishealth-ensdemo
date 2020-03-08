Class Demo.HL7v3.TestHarness.ResponseMode Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Mode As %String(VALUELIST = ",automated,interactive");

Property Active As %Boolean;

Index ResponseModeIDKey On Mode [ IdKey, PrimaryKey, Unique ];

Storage Default
{
<Data name="ResponseModeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v3.Tes7C9.ResponseModeD</DataLocation>
<DefaultData>ResponseModeDefaultData</DefaultData>
<IdLocation>^Demo.HL7v3.Tes7C9.ResponseModeD</IdLocation>
<IndexLocation>^Demo.HL7v3.Tes7C9.ResponseModeI</IndexLocation>
<StreamLocation>^Demo.HL7v3.Tes7C9.ResponseModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
