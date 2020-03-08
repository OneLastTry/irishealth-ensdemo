Include EnsDICOM

/// This production simulates a Modality performing a C-FIND Request Demonstrates how to perform a C-FIND Request
/// and also how to perform a C-CANCEL-RQ. You'll need a good emulator to connect to (Note that DVTK QR SCP program won't
/// work for this as it's implementation of Cancel is buggy)
/// 
/// Exercise this Demo by sending a test message (doesn't matter what) to the Demo.DICOM.Process.Modality process.
/// View the message trace to see issued find and cancel requests and how to handle them
Class Demo.DICOM.Production.Modality Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DICOM.Production.Modality" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Item Name="EnsLib.DICOM.Operation.TCP" Category="" ClassName="EnsLib.DICOM.Operation.TCP" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DuplexTargetConfigName">Demo.DICOM.Process.Modality</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">DVTKSCP_PATIENT</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">107</Setting>
    <Setting Target="Adapter" Name="IPAddress">10.30.4.112</Setting>
  </Item>
  <Item Name="Demo.DICOM.Process.Modality" Category="" ClassName="Demo.DICOM.Process.Modality" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="OperationDuplexName">EnsLib.DICOM.Operation.TCP</Setting>
  </Item>
</Production>
}

Parameter SETTINGS = "ShutdownTimeout,UpdateTimeout,StorageLocation";

/// This is the storage location for the DICOM streams to be stored
Property StorageLocation As %String;

/// This is a setup method which configures DICOM for the demo.
ClassMethod Setup() As %Status
{
    
    #; We will be sending storage requests to the JD-SCP
    Quit ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("DVTK_QR_SCU","DVTK_QR_SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
}

/// Override this in your Production class to do setup before the Production starts
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
    Set tSC=$$$OK
    
    #; Make sure that the associations exist
    If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("ENS-SCU","JD-SCP")
    {
        Set tSC=..Setup()
    }
    
    Quit tSC
}

}
