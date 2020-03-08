/// This production demonstrates a minimal configuration of JavaGateway and the SAPJCO operation
/// These production settings must be configured before starting the production:-
/// 
/// 'JavaHome' is the path to the local java installation
/// 
/// 'ClassPath' is the java class path which must include the path to the sapjco3.jar file.
/// 
/// 'JavaGatewayConfigItemName' is the name of the configuration item within THIS production
/// which defines the JavaGateway instance to be used to communicate with SAP. The operation
/// will access this configured item to determine the JavaGateWay Host Address and Port.
/// 
/// 'SAPHost' is the TCP address of the host system which houses the SAP implementation
/// 'SAPClient' is the SAP assigned client identifier (See SAP JCO documentation)
/// 'SAPLanguage' is the 2 character language identifer used by SAP (See SAP JCO documentation)
/// 'SAPSystemNumber' is the SAP assigned system identifier (See SAP JCO documentation)
/// 
/// 'SAPCredentials' is the name of credentials (configured in the EMP, Ensemble->Configure->Credentials). These include
/// the user name and password which will provided to the SAP instance. For our demo instance these are:
/// SAPUser -> MMSAP,MINISAP
/// 
/// TODO: Remove the settings from the production before release
Class Demo.SAP.Production.Minimal Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.SAP.Production.Minimal" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="JG" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="JavaHome">C:\Program Files\Java\jdk1.6.0_24</Setting>
    <Setting Target="Host" Name="Port">55554</Setting>
    <Setting Target="Host" Name="ClassPath">C:\perforce\dev\latest\thirdparty\sap\sapjco3-NTintel-3.0.7\sapjco3.jar</Setting>
    <Setting Target="Host" Name="Address">127.0.0.1</Setting>
  </Item>
  <Item Name="SAP" Category="" ClassName="EnsLib.SAP.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="SAPHost">192.168.68.138</Setting>
    <Setting Target="Host" Name="JavaGatewayConfigItemName">JG</Setting>
    <Setting Target="Host" Name="SAPClient">000</Setting>
    <Setting Target="Host" Name="SAPCredentials">SAPUser</Setting>
    <Setting Target="Host" Name="SAPLanguage">EN</Setting>
    <Setting Target="Host" Name="SAPSystemNumber">00</Setting>
  </Item>
</Production>
}

}
