Class Demo.Loan.FindRateEMailService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.EMail.InboundAdapter";

Method OnProcessInput(pMailMessage As %Net.MailMessage, pOutput As %RegisteredObject) As %Status
{
	$$$TRACE("received email from "_pMailMessage.From)

	#; assuming the subject format is LoanApplication:amount:name:TaxID:nationality
	Set tSubject=pMailMessage.Subject

	#; unrecognized mail subject
	If $p(tSubject,":")'="LoanApplication" Quit

	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount=$p(tSubject,":",2)
	Set tApplication.Name=$p(tSubject,":",3)
	Set tApplication.TaxID=$p(tSubject,":",4)
	Set tApplication.Nationality=$p(tSubject,":",5)
	Set tApplication.BusinessOperationType="mail"
	Set tApplication.Destination=pMailMessage.From
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateDecisionProcessCustom",tApplication)  Quit:$$$ISERR(tSC) tSC

	$$$TRACE("record number is "_tApplication.RecordNumber())

	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text=tApplication.GetRecordNumberText()
	Set tSendReply.Destination=tApplication.Destination
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateEMailOperation",tSendReply)
	Quit tSC
}

}
