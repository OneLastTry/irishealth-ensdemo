Class Demo.HL7v3.TestHarness.RequestMap Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Relationship Request As Demo.HL7v3.TestHarness.MessageTemplate [ Cardinality = one, Inverse = RequestMaps ];

Property ClassName As %String(MAXLEN = 128);

Property MethodName As %String(MAXLEN = 128);

Index RequestIndex On Request [ Unique ];

Storage Default
{
<Data name="RequestMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>MethodName</Value>
</Value>
<Value name="4">
<Value>Request</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v3.TestH7C9.RequestMapD</DataLocation>
<DefaultData>RequestMapDefaultData</DefaultData>
<IdLocation>^Demo.HL7v3.TestH7C9.RequestMapD</IdLocation>
<IndexLocation>^Demo.HL7v3.TestH7C9.RequestMapI</IndexLocation>
<StreamLocation>^Demo.HL7v3.TestH7C9.RequestMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
