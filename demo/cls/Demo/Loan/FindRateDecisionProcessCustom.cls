Include EnsUI

Class Demo.Loan.FindRateDecisionProcessCustom Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Property BankName As %String;

Property IsApproved As %Boolean [ InitialExpression = 0 ];

Property InterestRate As %Numeric;

Method OnRequest(request As Demo.Loan.Msg.Application, Output response As Ens.Response) As %Status
{
	$$$TRACE("received application for "_request.Name)
	#;
	Set tSC = ..SendRequestAsync("Demo.Loan.BankUS",request)  Quit:$$$ISERR(tSC) tSC
	Set tSC = ..SendRequestAsync("Demo.Loan.BankSoprano",request)  Quit:$$$ISERR(tSC) tSC
	Set tSC = ..SendRequestAsync("Demo.Loan.BankManana",request)  Quit:$$$ISERR(tSC) tSC
	#;
	Quit ..SetTimer("PT5S")
}

Method OnResponse(request As Demo.Loan.Msg.Application, ByRef response As Ens.Response, callrequest As Demo.Loan.Msg.Application, callresponse As Demo.Loan.Msg.Approval, pCompletionKey As %String) As %Status
{
	Quit:'callresponse.%Extends("Demo.Loan.Msg.Approval")||'callresponse.IsApproved $$$OK
	Quit:..IsApproved&&(..InterestRate<=callresponse.InterestRate) $$$OK
	Set ..BankName = callresponse.BankName
	Set ..IsApproved = callresponse.IsApproved
	Set ..InterestRate = callresponse.InterestRate
	Quit $$$OK
}

Method OnComplete(request As Demo.Loan.Msg.Application, ByRef response As Ens.Response) As %Status
{
	$$$TRACE("sync complete")
	#;
	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text = ..GetText()
	Set tSendReply.Destination = request.Destination
	If request.BusinessOperationType="mail" {
		Set tSC=..SendRequestAsync("Demo.Loan.FindRateEMailOperation",tSendReply,0)
	} Elseif request.BusinessOperationType="file" {
		Set tSC=..SendRequestAsync("Demo.Loan.FindRateFileOperation",tSendReply,0)
	} Elseif request.BusinessOperationType="term" {
		Set tSC=..SendRequestAsync("My Terminal Output",tSendReply,0)
	} Elseif request.BusinessOperationType="msmq" {
		Set tSC=..SendRequestAsync("Demo.Loan.FindRateMSMQOperation",tSendReply,0)
	} Elseif request.BusinessOperationType="mqseries" {
		Set tSC=..SendRequestAsync("Demo.Loan.FindRateMQSeriesOperation",tSendReply,0)
	}
	Quit $$$OK
}

Method OnError(request As Ens.Request, ByRef response As Ens.Response, callrequest As Ens.Request, pErrorStatus As %Status, pCompletionKey As %String) As %Status
{
	$$$TRACE("received error "_$$$StatusDisplayString(pErrorStatus))
	Quit $$$OK
}

Method GetText() As %String
{
	Set tText=""
	Set tThank = $$FormatMessage^%occMessages(,"EnsDemo","FindRateThankyou","Thank you for applying with FindRate.")
	If ..IsApproved {
		Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateIsApproved1","Your loan application was approved.")_$c(13,10)
		Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateIsApproved2","The lowest interest rate available is at ")_..InterestRate_$$FormatMessage^%occMessages(,"EnsDemo","FindRateOfferedby","% offered by ")_..BankName_"."_$c(13,10)
		Set tText=tText_tThank_$c(13,10)
	} Else {
		Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateIsDenied","Your loan application was denied.")_$c(13,10)
		Set tText=tText_tThank_$c(13,10)
	}
	Quit tText
}

Storage Default
{
<Data name="FindRateDecisionProcessDefaultData">
<Subscript>"FindRateDecisionProcess"</Subscript>
<Value name="1">
<Value>BankName</Value>
</Value>
<Value name="2">
<Value>InterestRate</Value>
</Value>
<Value name="3">
<Value>IsApproved</Value>
</Value>
</Data>
<DefaultData>FindRateDecisionProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
