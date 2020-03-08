Class Demo.HL7.MsgRouter.Production Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.HL7.MsgRouter.Production" TestingEnabled="false" LogGeneralTraceEvents="false">
  <Description>Routes HL7 messages based on message source and contents. To learn more, click on ABC_Router or XYZ_Router. Click View Rules to see message routing rules.

The production uses a routing process Ens.Alert to route alerts. The rule in Ens.Alert consults a lookup table to see where to send the alert.

To demonstrate alerts, give EMailAlertOperation a valid STMP server and Recipient. You may also edit the AlertTable lookup table. Temporarily assign a bad File Path to an enabled file service.</Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="ABC_HL7FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="Test source of HL7 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="AckTargetConfigNames"></Setting>
    <Setting Target="Host" Name="Framing">Flexible</Setting>
    <Setting Target="Host" Name="TargetConfigNames">ABC_Router</Setting>
    <Setting Target="Host" Name="SearchTableClass">Demo.HL7.MsgRouter.SearchTable</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication"></Setting>
    <Setting Target="Host" Name="AckMode">Never</Setting>
    <Setting Target="Host" Name="UseAckCommitCodes">1</Setting>
    <Setting Target="Host" Name="IgnoreInboundAck">1</Setting>
    <Setting Target="Host" Name="BatchHandling">Batch</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">Demo.HL7.MsgRouter.Schema</Setting>
    <Setting Target="Host" Name="DefCharEncoding">Latin1</Setting>
    <Setting Target="Host" Name="AlertGracePeriod">0</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\in</Setting>
    <Setting Target="Adapter" Name="FileSpec">ABC*</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\Practice\inarchive</Setting>
    <Setting Target="Adapter" Name="WorkPath"></Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="FileAccessTimeout">10</Setting>
    <Setting Target="Adapter" Name="AppendTimestamp">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="XYZ_HL7FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="Test source of HL7 messages." LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="AckTargetConfigNames"></Setting>
    <Setting Target="Host" Name="Framing">Flexible</Setting>
    <Setting Target="Host" Name="TargetConfigNames">XYZ_Router</Setting>
    <Setting Target="Host" Name="SearchTableClass">Demo.HL7.MsgRouter.SearchTable</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication"></Setting>
    <Setting Target="Host" Name="AckMode">Never</Setting>
    <Setting Target="Host" Name="UseAckCommitCodes">1</Setting>
    <Setting Target="Host" Name="IgnoreInboundAck">1</Setting>
    <Setting Target="Host" Name="BatchHandling">1Session</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">Demo.HL7.MsgRouter.Schema</Setting>
    <Setting Target="Host" Name="DefCharEncoding">Latin1</Setting>
    <Setting Target="Host" Name="AlertGracePeriod">0</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\in</Setting>
    <Setting Target="Adapter" Name="FileSpec">XYZ*</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\Practice\inarchive</Setting>
    <Setting Target="Adapter" Name="WorkPath"></Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="FileAccessTimeout">10</Setting>
    <Setting Target="Adapter" Name="AppendTimestamp">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="0" Enabled="true" Foreground="false" Comment="This handles Alert routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.HL7.MsgRouter.AlertRule</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
  </Item>
  <Item Name="ABC_Router" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="0" Enabled="true" Foreground="false" Comment="This handles message routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="AlertOnBadMessage">1</Setting>
    <Setting Target="Host" Name="BadMessageHandler">BadMessageHandler</Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.HL7.MsgRouter.ABCRoutingRule</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="XYZ_Router" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="This handles message routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">ISC:EnsembleHL7</Setting>
    <Setting Target="Host" Name="AckType">Application</Setting>
    <Setting Target="Host" Name="NackCode">Error</Setting>
    <Setting Target="Host" Name="Validation">dm-z</Setting>
    <Setting Target="Host" Name="AlertOnBadMessage">1</Setting>
    <Setting Target="Host" Name="BadMessageHandler">BadMessageHandler</Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.HL7.MsgRouter.XYZRoutingRule</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="EMailAlertOperation" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Alerts system administrators via e-mail." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.mycompany.test</Setting>
    <Setting Target="Adapter" Name="SMTPPort">25</Setting>
    <Setting Target="Adapter" Name="Credentials"></Setting>
    <Setting Target="Adapter" Name="Recipient">ensemble@mycompany.test</Setting>
    <Setting Target="Adapter" Name="Cc"></Setting>
    <Setting Target="Adapter" Name="From">ensemble@mycompany.test</Setting>
  </Item>
  <Item Name="ADT_A08_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Destination for ADT_A08 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_ADT_A08_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="ORM_O01_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Destination for ORM_O01 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_ORM_O01_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="ADT_A31_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Destination for ADT_A31 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_ADT_A31_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="Priority_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Priority destination for HL7 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Priority_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="Extra_Observations" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Destination for doctor notes/observations." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Extra_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="Regular_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Default destination for HL7 messages." LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Regular_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="Other_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Special destination for HL7 messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Other_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="BadMessageHandler" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Destination for bad messages." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Bad_%F.txt</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">AsciiLF</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
  <Item Name="Batch_FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="Filename">%H%M_Batch_%F.txt</Setting>
    <Setting Target="Host" Name="AutoBatchParentSegs">1</Setting>
    <Setting Target="Host" Name="Separators"><![CDATA[|^~\&]]></Setting>
    <Setting Target="Host" Name="SearchTableClass"></Setting>
    <Setting Target="Host" Name="DefCharEncoding">Latin1</Setting>
    <Setting Target="Host" Name="AlertRetryGracePeriod">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
    <Setting Target="Host" Name="ArchiveIO">0</Setting>
    <Setting Target="Host" Name="Framing">Ascii115/101</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">0</Setting>
    <Setting Target="Adapter" Name="Charset">Default</Setting>
    <Setting Target="Adapter" Name="OpenTimeout">5</Setting>
  </Item>
</Production>
}

}
