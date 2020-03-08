Class Demo.Loan.FindRateTerminalOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItem MessageType="Demo.Loan.Msg.SendReply">
<Method>TerminalSendReply</Method>
</MapItem>
}

Method OnInit() As %Status
{
	Set ^Ens.Debug("TraceCat",..%ConfigName,"user")=1 ; force user TRACE messages On for this config item (regardless of general trace debug settings)
	Set ^Ens.Debug("TraceCat",..%ConfigName)=0 ; force all other TRACE messages Off for this config item (regardless of general trace debug settings)
	Kill $$$EnsDebug("TraceCat")  Merge $$$EnsDebug("TraceCat")=^Ens.Debug("TraceCat") ; ensure local copy is in sync. Full sync for all jobs will happen when Ens.MonitorService gets around to it
	
	Quit ##super()
}

/// Send an approval message to the applicant's terminal session
Method TerminalSendReply(pRequest As Demo.Loan.Msg.SendReply, Output pResponse As Ens.Response) As %Status
{
	If $x'=0 Write !
	For i=1:1:79 Write "=" Write:i=79 !
	Write pRequest.Text
	Quit $$$OK
}

}
