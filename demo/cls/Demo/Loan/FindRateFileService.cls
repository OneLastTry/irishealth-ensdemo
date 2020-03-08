Class Demo.Loan.FindRateFileService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(pFileStream As %FileCharacterStream, pOutput As %RegisteredObject) As %Status
{
	Set tInputFilename=$tr(pFileStream.Filename,"/","\")
	Set tInputFilename=$p(tInputFilename,"\",$l(tInputFilename,"\"))
	Set tRecordFilename=tInputFilename
	Set $p(tRecordFilename,".",$l(tRecordFilename,"."))="record"
	Set tApprovalFilename=tInputFilename
	Set $p(tApprovalFilename,".",$l(tApprovalFilename,"."))="approval"		
	#;
	$$$TRACE("found file "_tInputFilename)
	#;
	#; assuming the first line is 'amount:name:TaxID:nationality'
	Set tSubject=pFileStream.ReadLine()
	#;
	Set tApplication = ##class(Demo.Loan.Msg.Application).%New()
	Set tApplication.Amount=$p(tSubject,":",1)
	Set tApplication.Name=$p(tSubject,":",2)
	Set tApplication.TaxID=$p(tSubject,":",3)
	Set tApplication.Nationality=$p(tSubject,":",4)
	Set tApplication.BusinessOperationType="file"
	Set tApplication.Destination=tApprovalFilename
	Set tSC = ..SendRequestAsync("Demo.Loan.FindRateDecisionProcessCustom",tApplication)  Quit:$$$ISERR(tSC) tSC
	#;
	$$$TRACE("record number is "_tApplication.RecordNumber())
	#;
	Set tSendReply = ##class(Demo.Loan.Msg.SendReply).%New()
	Set tSendReply.Text=tApplication.GetRecordNumberText()
	Set tSendReply.Destination=tRecordFilename
	Set tSC=..SendRequestAsync("Demo.Loan.FindRateFileOperation",tSendReply)
	Quit tSC
}

}
