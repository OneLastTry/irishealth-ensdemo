/// Business operation responsible for obtaining a string that tells the weather, based on an input string that gives a location.
Class Demo.ZenService.Boper.GetWeatherReport Extends Ens.BusinessOperation [ ProcedureBlock ]
{

/// Use our own simple adapter since this business operation does not call outside Ensemble
Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method GetWeatherReport(pRequest As Ens.StringRequest, Output pResponse As Demo.ZenService.Msg.WeatherOperationResponse) As %Status
{
	// Call a method on this business operation (just an example; usually you would call outside Ensemble)
	Set response = ..GetTheWeather(pRequest.StringValue)
	
	// Instantiate the response message object
	Set pResponse = ##class(Demo.ZenService.Msg.WeatherOperationResponse).%New()
	
	// Break apart the response string and assign values to properties
	Set pResponse.Forecast = $P(response,"|",1)
	Set pResponse.MinTemperature = $P(response,"|",2)
	Set pResponse.MaxTemperature = $P(response,"|",3)
	
	// If there was a problem with the response string, get defaults 
	If ""=pResponse.Forecast { set pResponse.Forecast = "Mostly sunny with the occasional shower" }
	If ""=pResponse.MinTemperature { set pResponse.MinTemperature = 22 }
	If ""=pResponse.MaxTemperature { set pResponse.MaxTemperature = 35 }

	Quit $$$OK
}

Method GetTheWeather(location As %String) As %String
{
	Set response = $CASE(location,"":"No weather|0|0",
								  "London":"Raining|-2|1",
								  "UK":"Raining|-2|1",
								  "England":"Raining|-2|1",
								  :"Scorching|25|35")
	Quit response
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>GetWeatherReport</Method>
	</MapItem>
</MapItems>
}

}
