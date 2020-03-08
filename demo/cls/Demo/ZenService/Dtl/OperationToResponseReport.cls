Class Demo.ZenService.Dtl.OperationToResponseReport Extends Ens.DataTransformDTL [ DependsOn = (Demo.ZenService.Msg.WeatherReportResponse, Demo.ZenService.Msg.WeatherOperationResponse) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<?xml version="1.0" ?>
<transform targetClass='Demo.ZenService.Msg.WeatherReportResponse' sourceClass='Demo.ZenService.Msg.WeatherOperationResponse' create='new' language='objectscript'>
<assign property='target.Report' value='source.Forecast' action='set'/>
<assign property='target.MinTemp' value='source.MinTemperature' action='set'/>
<assign property='target.MaxTemp' value='source.MaxTemperature' action='set'/>
</transform>
}

}
