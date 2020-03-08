/// Demo.ZenService.Zen.Application provides general information about the Zen application, including the translation domain.
/// For the main application page, see Demo.ZenService.Zen.WeatherReportForm.
Class Demo.ZenService.Zen.Application Extends %ZEN.application
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Weather Application";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "Demo.ZenService.Zen.WeatherReportForm.cls";

/// Domain used for localization.
Parameter DOMAIN = "MyDomain";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

}
