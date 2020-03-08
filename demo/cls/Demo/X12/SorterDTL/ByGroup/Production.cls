Class Demo.X12.SorterDTL.ByGroup.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.X12.SorterDTL.ByGroup.Production" LogGeneralTraceEvents="false">
  <Description>This production sorts the Transaction Sets within an X12 Interchange into Groups.    While doing so it performs transforms on the Interchange, Groups, and Transaction Sets.</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SimpleRouter" Category="" ClassName="EnsLib.MsgRouter.VDocRoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.X12.SorterDTL.ByGroup.SimpleRule</Setting>
  </Item>
  <Item Name="ByGroupFileService" Category="" ClassName="EnsLib.EDI.X12.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">SimpleRouter</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\In</Setting>
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="FileSpec">*</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
    <Setting Target="Host" Name="DocSchemaCategory">HIPAA_5010</Setting>
    <Setting Target="Host" Name="BatchReplyType">None</Setting>
    <Setting Target="Host" Name="ReplyMode">Never</Setting>
  </Item>
  <Item Name="ByGroupFileOperation" Category="" ClassName="EnsLib.EDI.X12.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\Out</Setting>
    <Setting Target="Host" Name="Filename">GroupSort_%Q</Setting>
    <Setting Target="Host" Name="Separators">*!:~\r\n</Setting>
  </Item>
</Production>
}

}
