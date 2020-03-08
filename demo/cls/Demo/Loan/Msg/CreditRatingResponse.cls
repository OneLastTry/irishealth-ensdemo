Class Demo.Loan.Msg.CreditRatingResponse Extends Ens.Response [ ClassType = persistent, ProcedureBlock ]
{

Property TaxID As %String;

Property CreditRating As %Integer;

Storage Default
{
<Data name="CreditRatingResponseDefaultData">
<Subscript>"CreditRatingResponse"</Subscript>
<Value name="1">
<Value>CreditRating</Value>
</Value>
<Value name="2">
<Value>TaxID</Value>
</Value>
</Data>
<DefaultData>CreditRatingResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
