Class Demo.HL7v3.TestHarness.ResponseMap Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Relationship Response As Demo.HL7v3.TestHarness.MessageTemplate [ Cardinality = one, Inverse = ResponseMaps ];

Property XPathContext As %String(MAXLEN = 512);

Property XPathExpression As %String(MAXLEN = 512);

Property XPathValue As %String(MAXLEN = 512);

Index ResponseIndex On Response;

Index ResponseMapUniqueKey On (XPathContext, XPathExpression, XPathValue) [ Unique ];

Storage Default
{
<Data name="ResponseMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Response</Value>
</Value>
<Value name="3">
<Value>XPathContext</Value>
</Value>
<Value name="4">
<Value>XPathExpression</Value>
</Value>
<Value name="5">
<Value>XPathValue</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v3.Test7C9.ResponseMapD</DataLocation>
<DefaultData>ResponseMapDefaultData</DefaultData>
<IdLocation>^Demo.HL7v3.Test7C9.ResponseMapD</IdLocation>
<IndexLocation>^Demo.HL7v3.Test7C9.ResponseMapI</IndexLocation>
<StreamLocation>^Demo.HL7v3.Test7C9.ResponseMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
