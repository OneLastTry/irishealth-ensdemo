/// This Zen page displays an interface to the user who wants a weather report.
/// It shows seven days' worth of static images. When the user clicks the
/// Get Report button, the page calls its showWeather() client method which in turn calls its
/// GetWeatherReport() server method to invoke the Zen Service business service to get the weather.
/// The weather report returns as the output of the GetWeatherReport() method and
/// the display changes accordingly.
/// <p>
/// This simple demonstration depends on some static values that have already been prepared. The most
/// meaningful values to enter for location are "US" "USA" "UK" "England" "London" "Germany" "France" "Spain" "Mexico" and "Italy".
/// You may enter other locations but will not get very meaningful results.
Class Demo.ZenService.Zen.WeatherReportForm Extends %ZEN.Component.page
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "Demo.ZenService.Zen.Application";

/// Displayed name of this page.
Parameter PAGENAME = "WeatherReportForm";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* set style used for html element */
#html1 {
	border: 1px solid darkblue;
	background: DFEFFF;
	padding: 5px;
	width: 500px;
}
/* Style for labelText component. */
.labelText {
	font-size: x-large;
}

</style>
}

/// This XML block defines the contents of this page, which consists of Zen components and groups.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="Ensemble Weather Report">
<hgroup align="left">
<spacer width="50"/>
<vgroup>
<spacer height="30"/>
<label id="title" align="center" value="Welcome to the Ensemble Weather Report"/>
<spacer height="5"/>
<hgroup align="center">
<image align="center" src="/csp/ensdemo/images/rain.gif"/>
<image align="center" src="/csp/ensdemo/images/clearday.gif"/>
<image align="center" src="/csp/ensdemo/images/mcloudyday.gif"/>
<image align="center" src="/csp/ensdemo/images/rain.gif"/>
<image align="center" src="/csp/ensdemo/images/clearday.gif"/>
<image align="center" src="/csp/ensdemo/images/mcloudyday.gif"/>
<image align="center" src="/csp/ensdemo/images/rain.gif"/>
</hgroup>
<spacer height="10"/>
<hgroup align="center">
<combobox align="center" id="txtLocation" label="Location"  
         valueList="England,France,Germany,Italy,London,Mexico,Spain,UK,USA" 
          onchange="zenPage.showWeather();" />
</hgroup>
<spacer height="25"/>
<html id="html1"><!-- initially empty -->
</html>

</vgroup>
</hgroup>
</page>
}

/// Client method showWeather() is called when the user selects a location from the drop-down list.
/// showWeather() gets the value from the list
/// and sends it as the location argument to be used with server method GetWeatherReport().
ClientMethod showWeather() [ Language = javascript ]
{
	try {
		var location = zen('txtLocation').getValue();
		zenPage.GetWeatherReport(location);
	}
	catch (ex) {
		zenExceptionHandler(ex,arguments);
	}
}

/// GetWeatherReport() is a server side ZenMethod. It starts processing by invoking the ProcessInput() method of the
/// business service called Zen Service in the production. The output of this call
/// is a message of a particular type, Demo.ZenService.Msg.WeatherReportResponse. GetWeatherReport()
/// inserts the properties of this message into a string which it displays as the
/// HTML-formatted contents of an <html> component that already existed, previously empty, on the Zen page.
/// Each time GetWeatherReport() is called, 
/// if there is a new output string, the contents of the <html> component change.
Method GetWeatherReport(Location As %String) [ ZenMethod ]
{
	// declare the type of the output variable as the response message type
	#dim output as Demo.ZenService.Msg.WeatherReportResponse
	
	Try {
		// Create the business service
		Set tSC=##class(Ens.Director).CreateBusinessService("Zen Service",.tService)
		If ($$$ISERR(tSC)) Quit
		
		// Create the request message and give its property a value
		set strContainer=##class(Ens.StringContainer).%New()
		set strContainer.StringValue=Location
		
		// Call the ProcessInput method of the business service
		Set tSC=tService.ProcessInput(strContainer,.output)
		If ($$$ISERR(tSC)) Quit
		
		// Use the result to output messages to the screen using our Zen <html> component with the id "html1"
		If $IsObject($G(output)) {
			Set htmlOutput = %page.%GetComponentById("html1")
			Set htmlOutput.content = "The Current Weather is:<p> Low:"_
				output.MinTemp_output.TempScale_"<p> High:"_
				output.MaxTemp_output.TempScale_"<p><p> Today's weather report:<p>"_
				output.Report
		}
	}
	Catch(ex) { 
		// Display the server side error to the client
		&js<alert('Error in Server method:\n#($ZCVT(ex.DisplayString(),"O","JS"))#');>
	}
	Quit
}

}
