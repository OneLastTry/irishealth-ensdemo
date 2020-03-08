Class Demo.HL7v3.Production.InterfaceEngine Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.HL7v3.Production.InterfaceEngine" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Demo.HL7v3.Service.SOAPIn" Category="" ClassName="Demo.HL7v3.Service.SOAPIn" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertGracePeriod">0</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
  </Item>
  <Item Name="HL7v3 SOAP Out" Category="" ClassName="Demo.HL7v3.Operation.SOAPOut" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="WebServiceURL"><![CDATA[<default>]]></Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">Demo.HL7v3.SOAP.Outbound</Setting>
    <Setting Target="Adapter" Name="Credentials">None</Setting>
    <Setting Target="Adapter" Name="ProxyServer"></Setting>
    <Setting Target="Adapter" Name="ProxyPort">80</Setting>
    <Setting Target="Adapter" Name="ProxyHTTPS">0</Setting>
  </Item>
  <Item Name="Route and Transform Message" Category="" ClassName="Demo.HL7v3.MsgRouter.RoutingEngine" PoolSize="0" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnBadMessage">0</Setting>
    <Setting Target="Host" Name="BadMessageHandler"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.HL7v3.Rule.RouteAndTransform</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7v3 File Out MFMT" Category="" ClassName="Demo.HL7v3.Operation.FileOut" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">HL7v3_Output_MFMT_%Q.xml</Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\EnsembleSys\dev\hl7v3\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="HL7v3 File In" Category="" ClassName="Demo.HL7v3.Service.FileIn" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertGracePeriod">0</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\EnsembleSys\dev\hl7v3\in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
    <Setting Target="Adapter" Name="ArchivePath"></Setting>
    <Setting Target="Adapter" Name="WorkPath"></Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="FileAccessTimeout">10</Setting>
    <Setting Target="Adapter" Name="AppendTimestamp">0</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="HL7v3 File Out QUPA" Category="" ClassName="Demo.HL7v3.Operation.FileOut" PoolSize="1" Enabled="true" Foreground="false" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">HL7v3_Output_QUPA_%Q.xml</Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\EnsembleSys\dev\hl7v3\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
</Production>
}

}
