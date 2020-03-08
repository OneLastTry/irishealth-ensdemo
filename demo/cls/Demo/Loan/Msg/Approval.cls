Class Demo.Loan.Msg.Approval Extends Ens.Response [ ClassType = persistent, ProcedureBlock ]
{

Property BankName As %String;

Property IsApproved As %Boolean [ InitialExpression = 0 ];

Property InterestRate As %Numeric;

Parameter DOMAIN = "EnsDemo";

Method GetText() As %String
{
	Set tSessionId=$$$JobSessionId
	&sql(Select MessageBodyId into :tRecordNum from Ens.MessageHeader where ID=:tSessionId)
	If $Get(tRecordNum)="" set tRecordNum ="??"
	If ..IsApproved {
		Set tText=$$FormatMessage^%occMessages(,"EnsDemo","FindRateIsApproved3","Your loan application with record number %1 was approved at the interest rate of %2 percent.",tRecordNum,..InterestRate)_$c(13,10)
	} Else {
		Set tText=$$FormatMessage^%occMessages(,"EnsDemo","FindRateIsDenied1","Your loan application with record number %1 was denied.",tRecordNum)_$c(13,10)
	}
	Set tThank=$$FormatMessage^%occMessages(,"EnsDemo","FindRateThankyou1","Thank you for applying with %1.",..BankName)
	Quit tText_tThank_$c(13,10)
}

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
</Data>
<DefaultData>ApprovalDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
