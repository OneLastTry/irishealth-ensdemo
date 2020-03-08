Class Demo.FloodMonitor.BusinessService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock ]
{

Method OnProcessInput(pInput As Ens.StringContainer, Output pOutput As Ens.StringContainer) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	do {
		Set tInput=pInput.StringValue
		If tInput="?" Do ..Help() Quit
		Set tRequest=##class(Demo.FloodMonitor.WaterLevelRequest).%New()
		Set tRequest.Location=$p(tInput,":",1)
		Set tRequest.WaterLevel=$p(tInput,":",2)
		Set pResult=""
		Set tFlag=$e(tRequest.Location,1,2)
		If tFlag="CA" Set tSC=..SendRequestAsync("Demo.FloodMonitor.CustomBusinessProcess",tRequest) Quit
		If tFlag="GA" Set tSC=..SendRequestAsync("Demo.FloodMonitor.GeneratedBusinessProcess",tRequest) Quit
		If tFlag="CS" Set tSC=..SendRequestSync("Demo.FloodMonitor.CustomBusinessProcess",tRequest,.tResponse) Quit
		If tFlag="GS" Set tSC=..SendRequestSync("Demo.FloodMonitor.GeneratedBusinessProcess",tRequest,.tResponse) Quit
		Set tSC=$$$ERROR($$$GeneralError,"User triggered error")
	} while (0)
	If $$$ISOK(tSC) {
		If $IsObject($g(tResponse)) {
			Set pOutput=##class(Ens.StringContainer).%New("Return result is: "_tResponse.IsTooHigh)
		} Else {
			Set pOutput=##class(Ens.StringContainer).%New("")
		}
	}
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

ClassMethod Help()
{
	Write !
	Write "Please enter the water level request at the prompt.",!
	Write "Enter the request in the format of location:waterlevel.",!
	Write !
	Write "The first 4 letters in the location name determine the path of execution",!
	Write "The possible values are: (GCE)(ASE)(RASE)(RE)",!
	Write "1st letter: G=GeneratedBusinessProcess, C=CustomBusinessProcess, E=Error",!
	Write "2nd letter: A=SendRequestAsync, S=SendRequestSync, E=Error",!
	Write "3rd letter: R=Reply, A=forwardAsynchronously, S=forwardSynchronously, E=Error",!
	Write "4th letter: R=reply, E=Error",!
	Write !
	Write "One example of ExecutionDirection is ""CSAR""",!
	Write !
	Quit
}

}
