/// This production defines the components needed to run the 
/// Dashboard demo
Class Demo.Dashboard.Production Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.Dashboard.Production">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SalesMetrics" ClassName="Demo.Dashboard.SalesMetrics" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0">
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Adapter" Name="CallInterval">2</Setting>
  </Item>
</Production>
}

}
