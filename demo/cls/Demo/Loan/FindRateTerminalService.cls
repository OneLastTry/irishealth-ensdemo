/// A Business Service called via CreateBusinessService() from the command line prompt offered by the Test() method in class Demo.Loan.FindRateProduction
Class Demo.Loan.FindRateTerminalService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

Method OnProcessInput(pInput As Ens.StringContainer, pOutput As Ens.StringContainer) As %Status
{
	#; assuming the first line is 'amount:name:TaxID:nationality'
	Set tSubject=pInput.StringValue

	$$$TRACE("received line "_tSubject)

	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount=$p(tSubject,":",1)
	Set tApplication.Name=$p(tSubject,":",2)
	Set tApplication.TaxID=$p(tSubject,":",3)
	Set tApplication.Nationality=$p(tSubject,":",4)
	Set tApplication.BusinessOperationType="term"
	Set tApplication.Destination=""
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateDecisionProcessBPL",tApplication)  Quit:$$$ISERR(tSC) tSC

	$$$TRACE("record number is "_tApplication.RecordNumber())

	Set pOutput=##class(Ens.StringContainer).%New(tApplication.GetRecordNumberText())

	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text=tApplication.GetRecordNumberText()
	Set tSendReply.Destination=""
	Set tSC=..SendRequestAsync("My Terminal Output",tSendReply)
	Quit tSC
}

}
