/// A business service for FindRate using MSMQ adapters
Class Demo.Loan.FindRateMSMQService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.MSMQ.InboundAdapter";

/// Authors of BusinessService implements this method to receive incoming data
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#; assuming the first line is 'amount:name:TaxID:nationality'
	If pInput.BodyLength<32768 {
		#; Access the property directly
		Set tSubject=pInput.Body
	} Else {
		#; We need to access the message via a stream, since it's too large for a single string
		Set tDispatch=pInput.Become("%Activate.IDispatch")
		Set tStream=tDispatch.GetPropertyAsStream("Body")
		Set tSubject=tStream.ReadLine()
	}
	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount=$p(tSubject,":",1)
	Set tApplication.Name=$p(tSubject,":",2)
	Set tApplication.TaxID=$p(tSubject,":",3)
	Set tApplication.Nationality=$p(tSubject,":",4)
	Set tApplication.BusinessOperationType="msmq"
	Set tApplication.Destination="FindRateResponse"
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateDecisionProcessCustom",tApplication)  Quit:$$$ISERR(tSC) tSC

	$$$TRACE("record number is "_tApplication.RecordNumber())
	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text=tApplication.GetRecordNumberText()
	Set tSendReply.Destination="FindRateResponse"
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateMSMQOperation",tSendReply)
	Quit tSC
}

}
