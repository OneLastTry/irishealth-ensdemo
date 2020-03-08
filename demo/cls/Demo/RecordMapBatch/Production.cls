Class Demo.RecordMapBatch.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.RecordMapBatch.Production" LogGeneralTraceEvents="false">
  <Description>Sample Production to illustrate an input/output transformation using Record Map batches.  The input batch contains data about arrival times and expected arrival times for trains.  The output batch filters to include only actual arrival times and reformats the data. This data is provided by MassDOT at http://developer.mbta.com/Data/Red.txt.  NOTE: The source file, TrainDataIn_Sample.txt and a sample output file, TrainDataOut_Sample.txt, are located in [install_dir]/dev/RecordMapBatch/.</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="BatchFileService" Category="" ClassName="EnsLib.RecordMap.Service.BatchFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BatchClass">Demo.RecordMapBatch.Map.TrainDataIn.BatchIn</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
    <Setting Target="Host" Name="RecordMap">Demo.RecordMapBatch.Map.TrainDataIn</Setting>
    <Setting Target="Adapter" Name="FileAccessTimeout">10</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\in</Setting>
    <Setting Target="Adapter" Name="FileSpec">TrainDataIn_*</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Router</Setting>
  </Item>
  <Item Name="BatchFileOperation" Category="" ClassName="EnsLib.RecordMap.Operation.BatchFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">TrainDataOut_%Q.txt</Setting>
    <Setting Target="Host" Name="RecordMap">Demo.RecordMapBatch.Map.TrainDataOut</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
  </Item>
  <Item Name="Router" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="test" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.RecordMapBatch.Rule.BatchRoutingRule</Setting>
  </Item>
</Production>
}

}
