Class Demo.Loan.Msg.PrimeRateResponse Extends Ens.Response [ ClassType = persistent, ProcedureBlock ]
{

Property PrimeRate As %Numeric;

Storage Default
{
<Data name="PrimeRateResponseDefaultData">
<Subscript>"PrimeRateResponse"</Subscript>
<Value name="1">
<Value>PrimeRate</Value>
</Value>
</Data>
<DefaultData>PrimeRateResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
