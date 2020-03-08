Class Demo.ZenService.Msg.WeatherOperationResponse Extends Ens.Response
{

Property Forecast As %String(MAXLEN = 32000);

Property MinTemperature As %Integer;

Property MaxTemperature As %Integer;

Storage Default
{
<Data name="WeatherOperationResponseDefaultData">
<Subscript>"WeatherOperationResponse"</Subscript>
<Value name="1">
<Value>Forecast</Value>
</Value>
<Value name="2">
<Value>MinTemperature</Value>
</Value>
<Value name="3">
<Value>MaxTemperature</Value>
</Value>
</Data>
<DefaultData>WeatherOperationResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
