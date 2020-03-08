Class Demo.FloodMonitor.BusinessOperation Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItem MessageType="Demo.FloodMonitor.WaterLevelRequest">
<Method>TestWaterLevel</Method>
</MapItem>
}

/// An operation that tests the current water level.
Method TestWaterLevel(pRequest As Demo.FloodMonitor.WaterLevelRequest, Output pResponse As Demo.FloodMonitor.WaterLevelResponse) As %Status
{
	$$$TRACE("Registered water level of '"_pRequest.WaterLevel_"' at location '"_pRequest.Location_"'")
	Set tFlag=$e(pRequest.Location,4)
	If tFlag="R" {
		If pRequest.Location["Error" Quit $$$ERROR($$$GeneralError,"User triggered error")
		Set pResponse=##class(Demo.FloodMonitor.WaterLevelResponse).%New()
		Set pResponse.IsTooHigh=pRequest.WaterLevel>500
		$$$TRACE("Registration of water level finished.")
		Quit $$$OK
	} Else {
		Quit $$$EnsError($$$GeneralError,"User triggered error")
	}
}

}
