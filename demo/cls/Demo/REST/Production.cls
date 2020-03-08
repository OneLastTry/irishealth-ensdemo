Class Demo.REST.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.REST.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Demo.REST.DirectoryService" Category="" ClassName="Demo.REST.DirectoryService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Port">9988</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="SSLConfig"></Setting>
  </Item>
  <Item Name="Demo.REST.DirectoryOperation" Category="" ClassName="Demo.REST.DirectoryOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">9988</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="URL">/directory</Setting>
    <Setting Target="Adapter" Name="SSLConfig"></Setting>
  </Item>
</Production>
}

}
