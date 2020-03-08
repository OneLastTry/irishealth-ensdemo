/// Business operation responsible for providing a translation to/from the requested languages.
Class Demo.ZenService.Boper.GetTranslation Extends Ens.BusinessOperation [ ProcedureBlock ]
{

/// Use our own simple adapter since this business operation does not call outside Ensemble
Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

/// Get the information out of the request message to translate the weather report into another language.
/// The request message Demo.ZenService.Msg.TranslationRequest has three properties, FromLanguage, ToLanguage, and
/// TextToTranslate. The response message Demo.ZenService.Msg.TranslationResponse has one property, TranslatedText.
Method Translate(pRequest As Demo.ZenService.Msg.TranslationRequest, Output pResponse As Demo.ZenService.Msg.TranslationResponse) As %Status
{
	// Call a method on this business operation (just an example; usually you would call outside Ensemble)
	Set response = ..GetTranslation(pRequest.FromLanguage,pRequest.ToLanguage,pRequest.TextToTranslate)
	
	// Instantiate the response message object
	Set pResponse = ##class(Demo.ZenService.Msg.TranslationResponse).%New()

	// Get the translated text and put it into the response message
	Set pResponse.TranslatedText = response

	Quit $$$OK
}

/// Translate from the identified language (first argument) to the identified language (second argument). 
/// The text to translate is the last argument, text. Since this is a sample, this is actually a static method so that only
/// the value for the "to" argument has meaning. If it is "French" or "Italian" or "Spanish" or "German" there is a
/// statically identified translation (the same translation for any input value).
Method GetTranslation(from As %String, to As %String, text As %String) As %String [ WebMethod ]
{
	Set response = $CASE(to,"French":"Je suis une porte",
							"Italian":"Questo caldo mi fa stanco",
							"Spanish":"Creo que va a llover",
							"German":"Wo ist das Treffen?",
							:"No translation is available")
	Quit response
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.ZenService.Msg.TranslationRequest"> 
		<Method>Translate</Method>
	</MapItem>
</MapItems>
}

}
