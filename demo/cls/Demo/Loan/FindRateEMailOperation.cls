/// Sends emails based on EMail Adapter config settings and the property values of a Demo.Loan.Msg.SendReply request object
Class Demo.Loan.FindRateEMailOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

XData MessageMap
{
<MapItem MessageType="Demo.Loan.Msg.SendReply">
<Method>EMailSendReply</Method>
</MapItem>
}

/// Send an approval email to the applicant
Method EMailSendReply(pRequest As Demo.Loan.Msg.SendReply, Output pResponse As Ens.Response) As %Status
{
	If pRequest.Destination="" $$$TRACE("no email address.") Quit $$$OK
	$$$TRACE("send email to "_pRequest.Destination)
	Set tMailMessage=##class(%Net.MailMessage).%New()
	Do tMailMessage.To.Insert(pRequest.Destination)
	Set tMailMessage.Subject="RE: Loan Application Approval"
	set tMailMessage.Charset="UTF-8"
	Set tSC=tMailMessage.TextData.Write(pRequest.Text)  Quit:$$$ISERR(tSC) tSC
	Set tSC=..Adapter.SendMail(tMailMessage)
	Quit tSC
}

}
