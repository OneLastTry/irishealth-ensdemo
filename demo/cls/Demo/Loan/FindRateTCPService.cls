/// To use this service, telnet to the configured port (default=1234) and enter the application date on a single line, separated by colons.
/// Example: 10000:Mo:111-22-3333:US
/// The demo application will copy your receipt notice to the output terminal, and will send the final Approval response there as well.
Class Demo.Loan.FindRateTCPService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.TCP.TextLineInboundAdapter";

Method OnProcessInput(pInput As Ens.StringContainer, pOutput As Ens.StringContainer) As %Status
{
	#; assuming the first line is 'amount:name:TaxID:nationality'
	
	#; Just print a prompt if empty input
	If pInput.StringValue="" {
		Set pOutput=##class(Ens.StringContainer).%New("Please apply for a loan as follows - ""Amount:Name:TaxID:Nationality"" (or ""quit"" to quit)")
		Quit $$$OK
	} ElseIf $ZCVT(pInput.StringValue,"L")="quit" {
		$$$sysTRACE("Disconnecting because of client request '"_$E(pInput.StringValue,1,32767-50)_"'")
		Do ..Adapter.Disconnect()
		Quit $$$OK
	}
	$$$TRACE("received line "_pInput.StringValue)

	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tSubject=pInput.StringValue
	Set tApplication.Amount=$p(tSubject,":",1)
	Set tApplication.Name=$p(tSubject,":",2)
	Set tApplication.TaxID=$p(tSubject,":",3)
	Set tApplication.Nationality=$p(tSubject,":",4)
	Set tApplication.BusinessOperationType="tcp"
	Set tApplication.Destination=""
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateDecisionProcessBPL",tApplication)  Quit:$$$ISERR(tSC) tSC

	$$$TRACE("record number is "_tApplication.RecordNumber())
	Set pOutput=##class(Ens.StringContainer).%New(tApplication.GetRecordNumberText())

	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text=tApplication.GetRecordNumberText()
	Set tSendReply.Destination=""
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateTCPOperation",tSendReply)
	Quit tSC
}

}
