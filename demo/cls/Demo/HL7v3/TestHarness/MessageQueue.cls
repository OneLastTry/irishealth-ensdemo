Class Demo.HL7v3.TestHarness.MessageQueue Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Request As %GlobalCharacterStream;

Property Response As %GlobalCharacterStream;

Property RequestName As %String;

Property DateTimeReceived As %TimeStamp [ InitialExpression = {$ZDateTime($Horolog, 3)} ];

Property Status As %String [ InitialExpression = "queued" ];

Storage Default
{
<Data name="MessageQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTimeReceived</Value>
</Value>
<Value name="3">
<Value>Request</Value>
</Value>
<Value name="4">
<Value>RequestName</Value>
</Value>
<Value name="5">
<Value>Response</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v3.Tes7C9.MessageQueueD</DataLocation>
<DefaultData>MessageQueueDefaultData</DefaultData>
<IdLocation>^Demo.HL7v3.Tes7C9.MessageQueueD</IdLocation>
<IndexLocation>^Demo.HL7v3.Tes7C9.MessageQueueI</IndexLocation>
<StreamLocation>^Demo.HL7v3.Tes7C9.MessageQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
