Class Demo.HL7v3.Operation.FileOut Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "Filename";

Property Filename As %String;

Method WriteToFile(pRequest As Demo.HL7v3.Message, Output pResponse As Ens.Response) As %Status
{
	Do pRequest.Content.Rewind()
	Set tFilename=..Adapter.CreateFilename(##class(%File).GetFilename($Piece(pRequest.Source, $Char(13))), ..Filename)

	Set $ZTrap = "WriteToFileET"
	Set tStatus = ..Adapter.PutStream(tFilename, pRequest.Content)

	Quit $$$OK

WriteToFileET
	Set $ZTrap = ""

	Quit $$$ERROR($$$GeneralError, "An error has occurred in WriteToFile(" _ tFilename _ "):  " _ $ZError)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.HL7v3.Message"> 
		<Method>WriteToFile</Method>
	</MapItem>
</MapItems>
}

}
