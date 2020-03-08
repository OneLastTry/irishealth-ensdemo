Class Demo.Loan.FindRateMSMQOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.MSMQ.OutboundAdapter";

XData MessageMap
{
<MapItem MessageType="Demo.Loan.Msg.SendReply">
<Method>MSMQSendReply</Method>
</MapItem>
}

/// Send an approval to the output message
Method MSMQSendReply(pRequest As Demo.Loan.Msg.SendReply, Output pResponse As Ens.Response) As %Status
{
	$$$TRACE("write to msmq "_pRequest.Destination)
	Set tSC=..Adapter.SendMessage(pRequest.Destination, pRequest.Text)
	Quit tSC
}

}
