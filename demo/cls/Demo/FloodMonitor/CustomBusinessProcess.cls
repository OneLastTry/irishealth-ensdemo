Include Ensemble

Class Demo.FloodMonitor.CustomBusinessProcess Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Method OnRequest(request As Ens.Request, Output response As Ens.Response) As %Status
{
	Set tFlag=$e(request.Location,3)
	If tFlag="R" {
		$$$TRACE("Registered water level of '"_request.WaterLevel_"' at location '"_request.Location_"'")
		$$$TRACE("Request handled locally")
		Set response=##class(Demo.FloodMonitor.WaterLevelResponse).%New()
		Set response.IsTooHigh=request.WaterLevel>500
		Quit $$$OK
	} Elseif tFlag="S" {
		;break
		$$$TRACE("Registered water level of '"_request.WaterLevel_"' at location '"_request.Location_"'")
		$$$TRACE("Request forwarded synchronously")
		Set tSC=..SendRequestSync("Demo.FloodMonitor.BusinessOperation",request,.response) If $$$ISERR(tSC) Quit tSC
		Quit $$$OK
	} Elseif tFlag="A" {
		$$$TRACE("Registered water level of '"_request.WaterLevel_"' at location '"_request.Location_"'")
		$$$TRACE("Request forwarded asynchronously")
		#; how can we do fire-and-forget call?
		Set tSC=..SendRequestAsync("Demo.FloodMonitor.BusinessOperation",request,1,"ABC") If $$$ISERR(tSC) Quit tSC
		Quit $$$OK
	} Else {
		Quit $$$EnsError($$$GeneralError,"User triggered error")
	}
}

Method OnResponse(request As Ens.Request, ByRef response As Ens.Response, callrequest As Ens.Request, callresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	$$$TRACE("Asynchronous request returned")
	Set response=callresponse
	Quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
