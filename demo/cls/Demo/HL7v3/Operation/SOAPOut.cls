Class Demo.HL7v3.Operation.SOAPOut Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method SendMessage(pRequest As Demo.HL7v3.Message, Output pResponse As Demo.HL7v3.Message) As %Status
{
	Set $ZTrap = "SendMessageET"

	Set tStatus = ..Adapter.InvokeMethod("GetResponse", .tResponse, pRequest.Content)
	Do tResponse.Rewind()

	Set pResponse = ##class(Demo.HL7v3.Message).%New()
	Set pResponse.Content = tResponse

	Quit $$$OK
	
SendMessageET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError, "An error has occurred in SendMessage():  " _ $ZError)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.HL7v3.Message"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
