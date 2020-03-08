Class Demo.FloodMonitor.WaterLevelRequest Extends Ens.Request [ ClassType = persistent, ProcedureBlock ]
{

Property Location As %String;

Property WaterLevel As %Integer;

Storage Default
{
<Data name="WaterLevelRequestDefaultData">
<Subscript>"WaterLevelRequest"</Subscript>
<Value name="1">
<Value>Location</Value>
</Value>
<Value name="2">
<Value>WaterLevel</Value>
</Value>
</Data>
<DefaultData>WaterLevelRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
