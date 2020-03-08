/// This production demonstrates the Ensemble Workflow Engine.
Class Demo.Workflow.Production Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.Workflow.Production" TestingEnabled="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HelpDesk" ClassName="Demo.Workflow.HelpDesk" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
  <Item Name="Demo-Development" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
  </Item>
  <Item Name="Demo-Testing" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
  </Item>
  <Item Name="Demo.Workflow.WFMetric" ClassName="Demo.Workflow.WFMetric" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
  </Item>
</Production>
}

}
