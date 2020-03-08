Include EnsEDIX12

Class Demo.X12.BatchSortProduction Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.X12.BatchSortProduction" TestingEnabled="false" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="FileService" Category="" ClassName="EnsLib.EDI.X12.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" DisableErrorTraps="false" InactivityTimeout="20" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ReplyTargetConfigNames"></Setting>
    <Setting Target="Host" Name="TargetConfigNames">SorterProcess</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.EDI.X12.SearchTable</Setting>
    <Setting Target="Host" Name="DocSchemaCategory">837=837_X098, Interchange=ISC_00401, Group=ISC_00401</Setting>
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="ReplyMode">Never</Setting>
    <Setting Target="Host" Name="BatchHandling">1Session</Setting>
    <Setting Target="Host" Name="BatchErrorAction">Indiv</Setting>
    <Setting Target="Host" Name="BatchReplyType">None</Setting>
    <Setting Target="Host" Name="LocalApplicationID">EnsembleX12Service:03</Setting>
    <Setting Target="Host" Name="TolerateNewlines">1</Setting>
    <Setting Target="Host" Name="DefCharEncoding"></Setting>
    <Setting Target="Host" Name="AlertGracePeriod">0</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\In</Setting>
    <Setting Target="Adapter" Name="FileSpec">*</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\Test\X12\In\Old</Setting>
    <Setting Target="Adapter" Name="WorkPath">C:\Test\X12\In\Old</Setting>
    <Setting Target="Adapter" Name="Charset">binary</Setting>
    <Setting Target="Adapter" Name="FileAccessTimeout">10</Setting>
    <Setting Target="Adapter" Name="AppendTimestamp">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">2.5</Setting>
  </Item>
  <Item Name="FileOperation1" Category="" ClassName="EnsLib.EDI.X12.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" DisableErrorTraps="false" InactivityTimeout="0" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="AutoBatchParentSegs">1</Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Test\X12\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="SorterProcess" Category="" ClassName="Demo.X12.SorterProcess" PoolSize="1" Enabled="true" Foreground="false" DisableErrorTraps="false" InactivityTimeout="0" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ReplyCodeActions"></Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
  </Item>
</Production>
}

}
