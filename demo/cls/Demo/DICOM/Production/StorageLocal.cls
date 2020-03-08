Include EnsDICOM

/// This production demonstrates how to receive C-STORE requests and store them as
/// DICOM files in the ensemble file structure
Class Demo.DICOM.Production.StorageLocal Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DICOM.Production.StorageLocal" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Item Name="EnsLib.DICOM.Service.TCP" Category="" ClassName="EnsLib.DICOM.Service.TCP" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DuplexTargetConfigName">Demo.DICOM.Process.StorageLocal</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCU</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
  </Item>
  <Item Name="Demo.DICOM.Process.StorageLocal" Category="" ClassName="Demo.DICOM.Process.StorageLocal" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.DICOM.Operation.File" Category="" ClassName="Demo.DICOM.Operation.File" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
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
	
	#; We will be accepting Storage and Query requests from JD-SCU
	Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
		
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
	
	Quit $$$OK
}

}
