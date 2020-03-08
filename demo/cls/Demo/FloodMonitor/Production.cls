Class Demo.FloodMonitor.Production Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.FloodMonitor.Production">
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="Demo.FloodMonitor.BusinessService" ClassName="Demo.FloodMonitor.BusinessService" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo.FloodMonitor.CustomBusinessProcess" ClassName="Demo.FloodMonitor.CustomBusinessProcess" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo.FloodMonitor.GeneratedBusinessProcess" ClassName="Demo.FloodMonitor.GeneratedBusinessProcess" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo.FloodMonitor.BusinessOperation" ClassName="Demo.FloodMonitor.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
</Production>
}

ClassMethod Test()
{
	Do ..Start()
	;
	Set tSC=##class(Ens.Director).CreateBusinessService("Demo.FloodMonitor.BusinessService",.tBusinessService)
	If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC) Quit
	For {
		Read !,"location:waterlevel>",tInput,! Quit:tInput=""
		If tInput="?" Do ##class(Demo.FloodMonitor.BusinessService).Help() Continue
		Set tSC=tBusinessService.ProcessInput(##class(Ens.StringContainer).%New(tInput),.tOutput)
		If 'tSC Do $system.Status.DisplayError(tSC) Continue
		Write !,tOutput.StringValue
	}
	Set tBusinessService = $$$NULLOREF
	;
	Do ..Stop()
	;
	Quit
}

ClassMethod TestAll(bsmode = "Queue", bomode = "Queue")
{
	DO ..TestOneInvocation("InProc","InProc")
	DO ..TestOneInvocation("InProc","Queue" )
	DO ..TestOneInvocation("Queue", "InProc")
	DO ..TestOneInvocation("Queue", "Queue" )
	Quit
}

ClassMethod TestOneInvocation(bsmode, bomode)
{
	Do ..ChangeInvocation("Demo.FloodMonitor.CustomBusinessProcess",bsmode)
	Do ..ChangeInvocation("Demo.FloodMonitor.GeneratedBusinessProcess",bsmode)
	Do ..ChangeInvocation("Demo.FloodMonitor.BusinessOperation",bomode)
	;
	Do ..Start()
	;
	Set tSC=##class(Ens.Director).CreateBusinessService("Demo.FloodMonitor.BusinessService",.tBusinessService)
	If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC) Quit
	For A="C","G" {
		For B="A","S","E" {
			For C="R","A","S","E" {
				For D="R","E" {
					Set tInput=A_B_C_D_":999"
					Write !,"INPUT=",tInput
					Set tSC=tBusinessService.ProcessInput(##class(Ens.StringContainer).%New(tInput),.tOutput)
					Write ",ISERR=",$$$ISERR(tSC)
					If $$$ISOK(tSC) Write ",OUTPUT=",tOutput.StringValue
				}
			}
		}
	}
	Set tBusinessService = $$$NULLOREF
	;
	Do ..Stop()
	;
	Quit
}

ClassMethod ChangeInvocation(classname, invocation)
{
	If ^oddDEF(classname,$$$cCLASSparameter,"INVOCATION",$$$cPARAMdefault)'=invocation {
		Set ^oddDEF(classname,$$$cCLASSparameter,"INVOCATION",$$$cPARAMdefault)=invocation
		Do $system.OBJ.Compile(classname,"k-u")
	}
	Quit
}

}
