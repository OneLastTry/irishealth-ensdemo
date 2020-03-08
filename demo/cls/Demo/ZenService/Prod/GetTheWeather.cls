/// Production for getting the weather. Note that the business service in this production is invoked from a Zen page.
/// For details, see Demo.ZenService.Zen.WeatherReportForm, a Zen class that provides the main application page.
Class Demo.ZenService.Prod.GetTheWeather Extends Ens.Production [ ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.ZenService.Prod.GetTheWeather" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Item Name="Get Weather Report" Category="" ClassName="Demo.ZenService.Boper.GetWeatherReport" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Convert Temperature" Category="" ClassName="Demo.ZenService.Boper.ConvertTemp" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Get Translation" Category="" ClassName="Demo.ZenService.Boper.GetTranslation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Zen Service" Category="" ClassName="Demo.ZenService.Bserv.ZenService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Weather Report" Category="" ClassName="Demo.ZenService.Bproc.WeatherReport" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
