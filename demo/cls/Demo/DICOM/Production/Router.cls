Include EnsDICOM

Class Demo.DICOM.Production.Router Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DICOM.Production.Router" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Item Name="LISTENER" Category="" ClassName="EnsLib.DICOM.Service.TCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">DISPATCHER</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCU</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
  </Item>
  <Item Name="DISPATCHER" Category="" ClassName="Demo.DICOM.Process.RouterDispatcher" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FilerConfigNames">PACS1FILER,PACS2FILER</Setting>
  </Item>
  <Item Name="PACS1FILER" Category="" ClassName="Demo.DICOM.Process.RouterFiler" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OperationDuplexName">PACS1OPERATION</Setting>
    <Setting Target="Host" Name="ReplyCodeActions"></Setting>
    <Setting Target="Host" Name="RetryInterval">10</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
  </Item>
  <Item Name="PACS2FILER" Category="" ClassName="Demo.DICOM.Process.RouterFiler" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OperationDuplexName">PACS2OPERATION</Setting>
    <Setting Target="Host" Name="ReplyCodeActions"></Setting>
    <Setting Target="Host" Name="RetryInterval">10</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
  </Item>
  <Item Name="PACS1OPERATION" Category="" ClassName="EnsLib.DICOM.Operation.TCP" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">PACS1FILER</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E*Unable to open Device=R</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCP</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">4096</Setting>
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
  </Item>
  <Item Name="PACS2OPERATION" Category="" ClassName="EnsLib.DICOM.Operation.TCP" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">PACS2FILER</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E*Unable to open Device=R</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCP</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">4098</Setting>
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
  </Item>
</Production>
}

Parameter SETTINGS = "ShutdownTimeout,UpdateTimeout,StorageLocation";

/// This is the storage location for the DICOM streams to be stored
Property StorageLocation As %String;

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
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("JD-SCU","ENS-SCP")
	{
		Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
	
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("ENS-SCU","JD-SCP")
	{
		Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("ENS-SCU","JD-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
	
	Quit $$$OK
}

}
