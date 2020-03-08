Class Demo.ZenService.Msg.TranslationRequest Extends Ens.Request
{

Property FromLanguage As %String;

Property ToLanguage As %String;

Property TextToTranslate As %String(MAXLEN = 32000);

Storage Default
{
<Data name="TranslationRequestDefaultData">
<Subscript>"TranslationRequest"</Subscript>
<Value name="1">
<Value>FromLanguage</Value>
</Value>
<Value name="2">
<Value>ToLanguage</Value>
</Value>
<Value name="3">
<Value>TextToTranslate</Value>
</Value>
</Data>
<DefaultData>TranslationRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
