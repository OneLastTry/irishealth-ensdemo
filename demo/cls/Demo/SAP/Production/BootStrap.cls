/// This production enables the customer to bootstrap the SAPJCO facility by providing a JavaGateway
/// which enables importation and proxy generation for the Java Classes which enable the connectivity.
/// 
/// These production settings must be configured before starting the production:-
/// 
/// 'JavaHome' is the path to the local java installation
/// 'ClassPath' is the java class path which must include the path to the sapjco3.jar file.
/// 
/// (Note: sapjco3.jar is provided by SAP, ISC does not re-distribute this file and supporting libraries so 
/// must be sourced independently)
/// 
/// Once the production is started, the class method ##class(EnsLib.SAP.BootStrap).ImportSAP() must be called
/// at a terminal prompt in the namespace where the production is running. The method will utilize the JavaGateway
/// to import the Java Classes and generate the JavaGateway proxies which  provide the SAP connectivity.
/// 
/// TODO: Remove the JavaHome and ClassPath settings from the production before release
Class Demo.SAP.Production.BootStrap Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.SAP.Production.BootStrap" TestingEnabled="false" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="JG" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="JavaHome">C:\Program Files\Java\jdk1.6.0_24</Setting>
    <Setting Target="Host" Name="Port">55554</Setting>
    <Setting Target="Host" Name="ClassPath">C:\perforce\dev\latest\thirdparty\sap\sapjco3-NTintel-3.0.7\sapjco3.jar</Setting>
    <Setting Target="Host" Name="Address">127.0.0.1</Setting>
  </Item>
</Production>
}

Storage Default
{
<Data name="BootStrapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Demo.SAP.Prod5BDB.BootStrapD</DataLocation>
<DefaultData>BootStrapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.SAP.Prod5BDB.BootStrapD</IdLocation>
<IndexLocation>^Demo.SAP.Prod5BDB.BootStrapI</IndexLocation>
<StreamLocation>^Demo.SAP.Prod5BDB.BootStrapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
