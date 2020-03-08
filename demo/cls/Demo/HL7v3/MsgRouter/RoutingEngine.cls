Class Demo.HL7v3.MsgRouter.RoutingEngine Extends EnsLib.MsgRouter.VDocRoutingEngine [ ClassType = persistent, ProcedureBlock ]
{

/// we need this property For EvaluateRules to get access to the HL7 message
Property HL7 As Demo.HL7v3.Message [ Calculated, ReadOnly, Transient ];

Method HL7Get() As Demo.HL7v3.Message [ CodeMode = expression ]
{
..Document
}

/// Override this method to implement your own method for validating a Document
Method OnValidate(pMsg As Demo.HL7v3.Message, pValSpec As %String, Output pStatus As %Status = {$$$OK}) As %Boolean
{
	Quit 0
}

Method OnRequest(request As Demo.HL7v3.Message, Output response As %Persistent) As %Status
{
	Set ..DocType = request.DocType
	Set ..DocName = request.Name
	Set tSC = ##super(request,.response)
	Quit tSC
}

Storage Default
{
<Data name="RoutingEngineDefaultData1">
<Subscript>"RoutingEngine1"</Subscript>
<Value name="1">
<Value>AlertOnBadMessage</Value>
</Value>
<Value name="2">
<Value>BadMessageHandler</Value>
</Value>
<Value name="3">
<Value>Validation</Value>
</Value>
</Data>
<DefaultData>RoutingEngineDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
