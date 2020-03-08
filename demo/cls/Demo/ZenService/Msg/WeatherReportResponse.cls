/// This is the message used to respond to the caller of the Zen Service business service
/// which in this case is the Zen page Demo.ZenService.Zen.WeatherReportForm.
Class Demo.ZenService.Msg.WeatherReportResponse Extends Ens.Response
{

/// Some arbitrary string of words
Property Report As %String(MAXLEN = 32000);

/// Minimum temperature for the day
Property MinTemp As %Integer;

/// Maximum temperature for the day
Property MaxTemp As %Integer;

/// Fahrenheit or Celsius
Property TempScale As %String;

Storage Default
{
<Data name="WeatherReportResponseDefaultData">
<Subscript>"WeatherReportResponse"</Subscript>
<Value name="1">
<Value>Report</Value>
</Value>
<Value name="2">
<Value>MinTempF</Value>
</Value>
<Value name="3">
<Value>MaxTempF</Value>
</Value>
<Value name="4">
<Value>MinTemp</Value>
</Value>
<Value name="5">
<Value>MaxTemp</Value>
</Value>
<Value name="6">
<Value>TempScale</Value>
</Value>
</Data>
<DefaultData>WeatherReportResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
