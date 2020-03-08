Include EnsDICOM

Class Demo.DICOM.Production.WorkList Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DICOM.Production.WorkList" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Item Name="EnsLib.DICOM.Service.TCP" Category="" ClassName="EnsLib.DICOM.Service.TCP" PoolSize="1" Enabled="true" Foreground="true" InactivityTimeout="0" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="DuplexTargetConfigName">Demo.DICOM.Process.WorkList</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="RemoteAET">JD-SCU</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
  </Item>
  <Item Name="Demo.DICOM.Process.WorkList" Category="" ClassName="Demo.DICOM.Process.WorkList" PoolSize="1" Enabled="true" Foreground="true" InactivityTimeout="0" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="NumberOfWorkListEntries">10</Setting>
  </Item>
</Production>
}

Parameter SETTINGS = "ShutdownTimeout,UpdateTimeout,StorageLocation";

/// This is the storage location for the DICOM streams to be stored
Property StorageLocation As %String;

/// This is a setup method which configures DICOM for the demo.
ClassMethod Setup()
{
	Write !,"Please configure JDICOM ModalitySCU with AET:JD-SCU, host: localhost, port:1112"
	
	#; We will be accepting Storage and Query requests from JD-SCU
	Do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
		
	Quit
}

/// Override this in your Production class to do setup before the Production starts
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	#; Make sure that the association exists
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("JD-SCU","ENS-SCP")
	{
		Quit ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("JD-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
	Quit $$$OK
}

}
