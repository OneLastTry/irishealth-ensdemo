Class Demo.HL7v3.Service.SOAPIn Extends EnsLib.SOAP.Service [ ClassType = "", ProcedureBlock ]
{

Parameter ADAPTER;

/// Name of the WebService.
Parameter SERVICENAME = "HL7v3SOAPIn";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// SendMessage
Method SendMessage(pInput As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZTrap = "SendMessageET"

	Set tStatus	= ..ProcessInput(pInput, .pOutput)

	Quit pOutput

SendMessageET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError, "An error has occurred in SendMessage():  " _ $ZError)
}

Method OnProcessInput(pInput As %GlobalCharacterStream, ByRef pOutput As %GlobalCharacterStream) As %Status
{
	Set $ZTrap = "OnProcessInputET"
	
	Set tStatus = ##class(%XML.XPATH.Document).CreateFromStream(pInput, .tDocument)
	Set tStatus = tDocument.EvaluateExpression("/*", "name()", .tResults)
	Set tStatus = pInput.Rewind()

	If (tResults.Count() > 0) Set tRoot = tResults.GetAt(1).Value
	Else  Set tRoot = "<errorNoRootElement>"
	
	Set tRequest = ##class(Demo.HL7v3.Message).%New()
	Set tRequest.Name		= tRoot
	Set tRequest.DocType	= ""
	Set tRequest.Source  	= ..#SERVICENAME
	Set tRequest.Content	= pInput
	
	Set tStatus = ..SendRequestSync("Route and Transform Message", tRequest, .tResponse)
	Set pOutput = tResponse.Content

	Quit $$$OK
	
OnProcessInputET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError, "An error has occurred in OnProcessInput():  " _ $ZError)
}

}
