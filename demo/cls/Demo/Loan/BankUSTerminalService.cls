Class Demo.Loan.BankUSTerminalService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

Method OnProcessInput(pInput As Ens.StringContainer, pOutput As %RegisteredObject) As %Status
{
	#; assuming the first line is 'amount:name:TaxID:nationality'
	Set tSubject=pInput.StringValue

	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount=$p(tSubject,":",1)
	Set tApplication.Name=$p(tSubject,":",2)
	Set tApplication.TaxID=$p(tSubject,":",3)
	Set tApplication.Nationality=$p(tSubject,":",4)
	Set tSC=..SendRequestSync("Demo.Loan.BankUS",tApplication,.tApproval)  Quit:$$$ISERR(tSC) tSC

	Set pOutput=##class(Ens.StringContainer).%New(tApproval.GetText())
	Quit tSC
}

}
