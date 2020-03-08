Class Demo.Loan.BankUSProduction Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.Loan.BankUSProduction" TestingEnabled="true">
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Demo.Loan.BankUSTerminalService" ClassName="Demo.Loan.BankUSTerminalService" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo.Loan.WebOperations" ClassName="Demo.Loan.WebOperations" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo.Loan.BankUS" ClassName="Demo.Loan.BankUS" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
</Production>
}

ClassMethod Test()
{
	Do ..Start()
	;
	Set tSC=##class(Ens.Director).CreateBusinessService("Demo.Loan.BankUSTerminalService",.tBusinessService)
	If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC) Quit
	For {
		Read !,"amount:name:taxid:nationality>",tInput,! Quit:tInput=""
		Set tSC=tBusinessService.ProcessInput(##class(Ens.StringContainer).%New(tInput),.tOutput)
		If 'tSC Do $system.Status.DisplayError(tSC) Continue
		Write !,tOutput.StringValue
	}
	Set tBusinessService = $$$NULLOREF
	;
	Do ..Stop()
	Quit
}

}
