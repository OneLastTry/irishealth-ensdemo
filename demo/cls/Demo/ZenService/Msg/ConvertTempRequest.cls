Class Demo.ZenService.Msg.ConvertTempRequest Extends Ens.Request
{

Property Direction As %String;

Property InputTemp As %Integer;

Storage Default
{
<Data name="ConvertTempRequestDefaultData">
<Subscript>"ConvertTempRequest"</Subscript>
<Value name="1">
<Value>Direction</Value>
</Value>
<Value name="2">
<Value>InputTemp</Value>
</Value>
</Data>
<DefaultData>ConvertTempRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
