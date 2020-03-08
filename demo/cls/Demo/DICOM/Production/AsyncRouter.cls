Include EnsDICOM

Class Demo.DICOM.Production.AsyncRouter Extends Ens.Production
{

/// This is the storage location for the DICOM streams to be stored
Property StorageLocation As %String;

Parameter SETTINGS = "StorageLocation";

/// This is a setup method which configures DICOM for the demo.
ClassMethod Setup()
{
	Write !,"Configure JDICOM Storage      AET JD-SCU, localhost, 1112"
	Write !,"Configure JDICOM ImageServer  AET JD-SCP, localhost, 4096"
	
	#; We will be accepting Storage requests from JD-SCU
	Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	
	#; We will be sending storage requests to the JD-SCP
	Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("ENS-SCU","JD-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
		
	Quit
}

/// Override this in your Production class to do setup before the Production starts
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	#; Make sure that the associations exist
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("JD-SCU","ENS-SCP") {
		Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
	
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("ENS-SCU","JD-SCP") {
		Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("ENS-SCU","JD-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
	
	Quit $$$OK
}

XData ProductionDefinition
{
<Production Name="Demo.DICOM.Production.AsyncRouter" TestingEnabled="false" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Item Name="AsyncDispatcher" Category="" ClassName="Demo.DICOM.Process.AsyncRouterDispatcher" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FilerConfigNames">AsyncFiler1,AsyncFiler2</Setting>
    <Setting Target="Host" Name="RuleClass">Demo.DICOM.Util.TestRoutingRule</Setting>
    <Setting Target="Host" Name="StoreIgnoredEntries">1</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="AsyncFiler1" Category="" ClassName="Demo.DICOM.Process.AsyncRouterFiler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OperationDuplexName">PACS1Operation</Setting>
    <Setting Target="Host" Name="RemoveCompletedEntries">0</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="RetryCount">3</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
  </Item>
  <Item Name="AsyncFiler2" Category="" ClassName="Demo.DICOM.Process.AsyncRouterFiler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OperationDuplexName">PACS2Operation</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
    <Setting Target="Host" Name="RemoveCompletedEntries">0</Setting>
    <Setting Target="Host" Name="RetryCount">3</Setting>
  </Item>
  <Item Name="Listener" Category="" ClassName="EnsLib.DICOM.Service.TCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">AsyncDispatcher</Setting>
    <Setting Target="Adapter" Name="IPAddress"></Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCU</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
  </Item>
  <Item Name="PACS1Operation" Category="" ClassName="EnsLib.DICOM.Operation.TCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="IPPort">4096</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCP</Setting>
    <Setting Target="Host" Name="DuplexTargetConfigName">AsyncFiler1</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="ReplyCodeActions"></Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
  </Item>
  <Item Name="PACS2Operation" Category="" ClassName="EnsLib.DICOM.Operation.TCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">AsyncFiler2</Setting>
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="IPPort">4098</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCP</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="ReplyCodeActions"></Setting>
    <Setting Target="Host" Name="AlertOnError">0</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="From">ensemble@mycompany.test</Setting>
    <Setting Target="Adapter" Name="Recipient">ensemble@mycompany.test</Setting>
    <Setting Target="Adapter" Name="SMTPPort">25</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.mycompany.test</Setting>
    <Setting Target="Adapter" Name="Credentials"></Setting>
  </Item>
</Production>
}

}
