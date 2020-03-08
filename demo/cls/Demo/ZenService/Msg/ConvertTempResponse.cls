Class Demo.ZenService.Msg.ConvertTempResponse Extends Ens.Response
{

Property OutputTemp As %Integer;

Storage Default
{
<Data name="ConvertTempResponseDefaultData">
<Subscript>"ConvertTempResponse"</Subscript>
<Value name="1">
<Value>OutputTemp</Value>
</Value>
</Data>
<DefaultData>ConvertTempResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
