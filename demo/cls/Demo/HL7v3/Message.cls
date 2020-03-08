Class Demo.HL7v3.Message Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Content As %GlobalCharacterStream;

Property Name As %String;

Property DocType As %String;

Property Source As %String(MAXLEN = 250, TRUNCATE = 1);

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>DocType</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Source</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v3.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<IdLocation>^Demo.HL7v3.MessageD</IdLocation>
<IndexLocation>^Demo.HL7v3.MessageI</IndexLocation>
<StreamLocation>^Demo.HL7v3.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
