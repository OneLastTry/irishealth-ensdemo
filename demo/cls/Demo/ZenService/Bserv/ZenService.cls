/// This business service takes an Ens.StringContainer as input and returns
/// a Demo.ZenService.Msg.WeatherReportResponse to the caller as output.
/// It is invoked from the Zen page Demo.ZenService.Zen.WeatherReportForm and invokes the business process that
/// has been configured in the production with the name "Weather Report".
Class Demo.ZenService.Bserv.ZenService Extends Ens.BusinessService [ ProcedureBlock ]
{

Method OnProcessInput(pInput As Ens.StringContainer, pOutput As Demo.ZenService.Msg.WeatherReportResponse) As %Status
{
	// Create the request message
	Set request = ##class(Ens.StringRequest).%New()
	
	// Place a value in the request message property
	Set request.StringValue = pInput.StringValue
	
	// Make a synchronous call to the business process and use the response message as our response 
	Set tSC = ..SendRequestSync("Weather Report", request, .pOutput)

	Quit tSC
}

}
