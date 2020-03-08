Class Demo.Loan.FindRateCSPService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

Method OnProcessInput(pCSPRequest As %CSP.Request, pOutput As Ens.StringContainer) As %Status
{
	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount = pCSPRequest.Get("Amount")
	Set tApplication.Name = pCSPRequest.Get("Name")
	Set tApplication.TaxID = pCSPRequest.Get("TaxID")
	Set tApplication.Nationality = pCSPRequest.Get("Nationality")
	Set tApplication.BusinessOperationType = "mail"
	Set tApplication.Destination = pCSPRequest.Get("EMail")
	Set tSC = ..SendRequestAsync("Demo.Loan.FindRateDecisionProcessBPL",tApplication)  Quit:$$$ISERR(tSC) tSC

	Set pOutput = ##class(Ens.StringContainer).%New(tApplication.GetRecordNumberText(1))
	Quit tSC
}

}
