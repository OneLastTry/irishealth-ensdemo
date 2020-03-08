Class Demo.HL7v3.Service.FileIn Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(pInput As %FileCharacterStream, pOutput As Ens.Response) As %Status
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
	Set tRequest.Source     = pInput.Attributes("Filename")
	Do tRequest.Content.CopyFrom(pInput)
	
	Set tStatus = ..SendRequestSync("Route and Transform Message", tRequest, .tResponse)
	
	Quit $$$OK
	
OnProcessInputET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError, "An error has occurred in OnProcessInput():  " _ $ZError)
}

}
