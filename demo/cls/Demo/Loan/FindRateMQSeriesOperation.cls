Class Demo.Loan.FindRateMQSeriesOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

/// Name of the adapter class
Parameter ADAPTER = "EnsLib.MQSeries.OutboundAdapter";

XData MessageMap
{
<MapItem MessageType="Demo.Loan.Msg.SendReply">
<Method>MQSeriesSendReply</Method>
</MapItem>
}

/// Send an approval to the output message
Method MQSeriesSendReply(pRequest As Demo.Loan.Msg.SendReply, Output pResponse As Ens.Response) As %Status
{
	$$$TRACE("write to mqseries")
	Set tSC=..Adapter.SendMessage(pRequest.Text)
	Quit tSC
}

}
