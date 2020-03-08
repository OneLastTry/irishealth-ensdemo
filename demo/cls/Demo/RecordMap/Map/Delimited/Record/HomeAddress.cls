/// RECORDMAP: Generated from RecordMap 'Demo.RecordMap.Map.Delimited'
/// on 2010-09-30 at 16:20:02.182 [2010-09-30 21:20:02.182 UTC]
/// by user DemoUser
Class Demo.RecordMap.Map.Delimited.Record.HomeAddress Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property City As %String;

Property State As %String(MAXLEN = 2);

Property StreetLine1 As %String;

Property ZipCode As %String;

Storage Default
{
<Data name="HomeAddressState">
<Value name="1">
<Value>City</Value>
</Value>
<Value name="2">
<Value>State</Value>
</Value>
<Value name="3">
<Value>StreetLine1</Value>
</Value>
<Value name="4">
<Value>ZipCode</Value>
</Value>
</Data>
<State>HomeAddressState</State>
<StreamLocation>^Demo.RecordMap66BA.HomeAddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
