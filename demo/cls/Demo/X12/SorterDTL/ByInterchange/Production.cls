Class Demo.X12.SorterDTL.ByInterchange.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.X12.SorterDTL.ByInterchange.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SortProcess" Category="" ClassName="Demo.X12.SorterDTL.ByInterchange.SimpleProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="ByInterchangeFileService" Category="" ClassName="EnsLib.EDI.X12.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">SortProcess</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\In</Setting>
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FileSpec">*</Setting>
    <Setting Target="Host" Name="DocSchemaCategory">HIPAA_5010</Setting>
    <Setting Target="Host" Name="ReplyTargetConfigNames"></Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
    <Setting Target="Host" Name="ReplyMode">Never</Setting>
    <Setting Target="Host" Name="BatchReplyType">None</Setting>
  </Item>
  <Item Name="ByInterchangeFileOperation" Category="" ClassName="EnsLib.EDI.X12.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\Out</Setting>
    <Setting Target="Host" Name="Filename">InterchangeSort_%Q</Setting>
    <Setting Target="Host" Name="Separators">*!:~\r\n</Setting>
  </Item>
</Production>
}

}
