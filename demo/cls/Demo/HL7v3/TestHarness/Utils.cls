Class Demo.HL7v3.TestHarness.Utils Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SendMessagesBatch(pMessageName As %String = "", pInterfaceCount As %String = 0, pMessageCount As %String = 0, pHang As %String = ".1", pForeground As %Boolean = 0) As %Status [ ProcedureBlock = 0 ]
{
	If (pForeground = 1) {
		Set tInterfaceID = 1

		Set tStatus = $$Start()
	}
	Else {
			If ($ZConvert($Extract(pInterfaceCount, 1, 2), "U") = "$R") { Set @("tNumInterfaces=" _ pInterfaceCount), tNumInterfaces = +tNumInterfaces } Else { Set tNumInterfaces = +pInterfaceCount }

			For tInterfaceID = 1:1:tNumInterfaces { Job Start:(:1) }
	}
	
	Quit $$$OK
	
Start()
	Set $ZTrap		= "SendMessagesBatchET"
	Set tStatus		= ##class(Demo.HL7v3.TestHarness.Utils).SetInterfaceInfo(pMessageName, tInterfaceID, pMessageCount, pHang)

	If ($ZConvert($Extract(pMessageCount, 1, 2), "U") = "$R") { Set @("tNumMessages=" _ pMessageCount), tNumMessages = +tNumMessages } Else { Set tNumMessages = +pMessageCount }

	&sql(
		Select		mt.ID, rm.ClassName, rm.MethodName
		Into		:tMessageTemplateID, :tClassName, :tMethodName
		From		Demo_HL7v3_TestHarness.RequestMap as rm
		Inner Join	Demo_HL7v3_TestHarness.MessageTemplate as mt on mt.ID = rm.Request
		Where		mt.Name = :pMessageName
	)

	For tCount = 1:1:tNumMessages {
		If '$Data(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID)) Quit

		If 'SQLCODE {
			Set tRequest = ##class(Demo.HL7v3.TestHarness.MessageTemplate).%OpenId(tMessageTemplateID).Message
		
			If $IsObject(tRequest) && $Data(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID)) {
				Set tStatus			= ##class(Demo.HL7v3.TestHarness.MessageGenerator).ProcessStream(.tRequest)
				Set tRequestCount	= $Increment(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID, "Requests"))
				Set tRequestBytes	= $Increment(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID, "Requests", "Total Bytes"), tRequest.Size)

				Set tService = $zobjclassmethod(tClassName, "%New")
				Set @("tResponse = tService." _ tMethodName _ "(tRequest)")

				If $IsObject(tResponse) && $Data(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID)) {
					Set tResponseCount	= $Increment(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID, "Responses"))
					Set tResponseBytes	= $Increment(^Demo.HL7v3.TestHarness.Status("Client", pMessageName, tInterfaceID, "Responses", "Total Bytes"), tResponse.Size)
				}
			}
		}
		
		If ($ZConvert($Extract(pHang, 1, 2), "U") = "$R") { Set @("tHangTime=" _ pHang), tHangTime = +tHangTime } Else { Set tHangTime = +pHang }

		If +tHangTime Hang tHangTime
	}	

	Set tStatus = ##class(Demo.HL7v3.TestHarness.Utils).ClearInterfaceInfo(pMessageName, tInterfaceID)

	Quit $$$OK

SendMessagesBatchET
	Set $ZTrap = ""
	
	Set tStatus = ##class(Demo.HL7v3.TestHarness.Utils).ClearInterfaceInfo(pMessageName, tInterfaceID)

	Set tID = $Increment(^Demo.HL7v3.TestHarness.Errors("SendMessagesBatch", pMessageName, tInterfaceID))
	Set ^Demo.HL7v3.TestHarness.Errors("SendMessagesBatch", pMessageName, tInterfaceID, tID) = $ZDateTime($Horolog, 3) _ "|" _ $ZError

	Quit $$$ERROR($$$GeneralError, "An error has occurred in SendMessagesBatch():  " _ $ZError)
}

ClassMethod SetInterfaceInfo(pMessageName As %String = "", pInterfaceID As %String = "", pMessageCount As %Integer = "", pHang As %String = "") As %Status
{
	Set $ZTrap = "SetInterfaceInfoET"
	
	If (pMessageName = "") || (pInterfaceID = "") || (pMessageCount = "") Quit $$$ERROR($$$GeneralError,"Null message name, interface id, or message count encountered...")

	Set ^Demo.HL7v3.TestHarness.Status("Client", pMessageName, pInterfaceID, "Info") = $ZDateTime($Horolog, 3) _ "^" _ pMessageCount _ "^" _ pHang
	
	Quit $$$OK

SetInterfaceInfoET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError,"An error has occurred in SetInterfaceInfo():  " _ $ZError)
}

ClassMethod ClearInterfaceInfo(pMessageName As %String = "", pInterfaceID As %String = "") As %Status
{
	Set $ZTrap = "ClearInterfaceInfoET"
	
	If (pMessageName = "") || (pInterfaceID = "") Quit $$$ERROR($$$GeneralError,"Null message name or interface id encountered...")

	Kill ^Demo.HL7v3.TestHarness.Status("Client", pMessageName, pInterfaceID)
	
	Quit $$$OK

ClearInterfaceInfoET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError,"An error has occurred in ClearInterfaceInfo():  " _ $ZError)
}

ClassMethod ClearAllInterfaceInfo() As %Status
{
	Set $ZTrap = "ClearAllInterfaceInfoET"
	
	Kill ^Demo.HL7v3.TestHarness.Status
	
	Quit $$$OK

ClearAllInterfaceInfoET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError,"An error has occurred in ClearAllInterfaceInfo():  " _ $ZError)
}

}
