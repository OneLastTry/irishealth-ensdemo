Class Demo.ZenService.Msg.TranslationResponse Extends Ens.Response
{

Property TranslatedText As %String(MAXLEN = 32000);

Storage Default
{
<Data name="TranslationResponseDefaultData">
<Subscript>"TranslationResponse"</Subscript>
<Value name="1">
<Value>TranslatedText</Value>
</Value>
</Data>
<DefaultData>TranslationResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
