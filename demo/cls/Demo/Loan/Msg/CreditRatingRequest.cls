Class Demo.Loan.Msg.CreditRatingRequest Extends Ens.Request [ ClassType = persistent, ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "Demo.Loan.Msg.CreditRatingResponse";

Property TaxID As %String;

Storage Default
{
<Data name="CreditRatingRequestDefaultData">
<Subscript>"CreditRatingRequest"</Subscript>
<Value name="1">
<Value>TaxID</Value>
</Value>
</Data>
<DefaultData>CreditRatingRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
