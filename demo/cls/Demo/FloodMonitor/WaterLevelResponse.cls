Class Demo.FloodMonitor.WaterLevelResponse Extends Ens.Response [ ClassType = persistent, ProcedureBlock ]
{

Property IsTooHigh As %Boolean;

Storage Default
{
<Data name="WaterLevelResponseDefaultData">
<Subscript>"WaterLevelResponse"</Subscript>
<Value name="1">
<Value>IsTooHigh</Value>
</Value>
</Data>
<DefaultData>WaterLevelResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
