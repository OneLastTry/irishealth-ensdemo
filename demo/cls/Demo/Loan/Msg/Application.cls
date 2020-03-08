Class Demo.Loan.Msg.Application Extends Ens.Request [ ClassType = persistent, ProcedureBlock ]
{

Property Amount As %Integer;

Property Name As %String;

Property TaxID As %String;

Property Nationality As %String;

Property BusinessOperationType As %String;

Property Destination As %String(MAXLEN = 1000);

Parameter RESPONSECLASSNAME = "Demo.Loan.Msg.Approval";

Parameter DOMAIN = "EnsDemo";

Method RecordNumber() As %String
{
	If ..%Id()="" Do ..%Save()
	Quit ..%Id()
}

Method GetRecordNumberText(pFormatAsHTML As %Boolean = 0) As %String
{
	Set tCRLF=$s(pFormatAsHTML:"<br>",1:$c(13,10))
	Set tText=$$FormatMessage^%occMessages(,"EnsDemo","FindRateReceived","Your loan application has been received, and is being processed.")
	Set tTemp = $$FormatMessage^%occMessages(,"EnsDemo","FindRateRecordNumber","Your record number is %1.",..RecordNumber())
	Set tText=tText_" "_tTemp_tCRLF
	Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateWillReceive","You'll receive a reply from FindRate within 2 business days.")_tCRLF
	Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateThankyou","Thank you for applying with FindRate.")_tCRLF
	Quit tText
}

Storage Default
{
<Data name="ApplicationDefaultData">
<Subscript>"Application"</Subscript>
<Value name="1">
<Value>Amount</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Nationality</Value>
</Value>
<Value name="4">
<Value>TaxID</Value>
</Value>
<Value name="5">
<Value>BusinessOperation</Value>
</Value>
<Value name="6">
<Value>Destination</Value>
</Value>
<Value name="7">
<Value>BusinessOperationType</Value>
</Value>
</Data>
<DefaultData>ApplicationDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
