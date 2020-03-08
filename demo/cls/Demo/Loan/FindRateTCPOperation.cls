Include (%occInclude, Ensemble)

Class Demo.Loan.FindRateTCPOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.TCP.TextLineOutboundAdapter";

XData MessageMap
{
<MapItem MessageType="Demo.Loan.Msg.SendReply">
<Method>TCPSendReply</Method>
</MapItem>
}

/// Send an approval to the output TCP listener
Method TCPSendReply(pRequest As Demo.Loan.Msg.SendReply, Output pResponse As Ens.Response) As %Status
{
	Set tSC=..Adapter.SendMessageString(pRequest.Text)
	Quit tSC
}

}
