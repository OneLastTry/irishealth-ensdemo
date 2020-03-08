Class Demo.Loan.Msg.SendReply Extends Ens.Request [ ClassType = persistent, ProcedureBlock ]
{

Property Text As %String(MAXLEN = "");

Property Destination As %String(MAXLEN = 1000);

Storage Default
{
<Data name="ApprovalDefaultData">
<Subscript>"Approval"</Subscript>
<Value name="1">
<Value>BankName</Value>
</Value>
<Value name="2">
<Value>InterestRate</Value>
</Value>
<Value name="3">
<Value>IsApproved</Value>
</Value>
<Value name="4">
<Value>Destination</Value>
</Value>
<Value name="5">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>ApprovalDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
