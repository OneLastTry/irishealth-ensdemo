Include Ensemble

Class Demo.REST.DirectoryResponse Extends (%Persistent, %XML.Adaptor)
{

/// Single result value
Property Value As %String(MAXLEN = "");

/// Single record properties or list of records' single values
Property Properties As array Of %String(MAXLEN = "", XMLITEMNAME = "Value", XMLKEYNAME = "Key", XMLPROJECTION = "ELEMENT");

/// Array of records' properties
Property Records As array Of %ArrayOfDataTypes(XMLITEMNAME = "Record", XMLKEYNAME = "num", XMLPROJECTION = "NONE");

/// For the record: submitted Request URL
Property RequestURL As %String(MAXLEN = "") [ Internal ];

/// For the record: raw HTTP response body resulting from request URL
Property RawResponse As %Stream.GlobalCharacter [ Internal ];

/// For the record: ID of the session used to retrieve this response
Property SessionId As %String;

Storage Default
{
<Data name="DirectoryResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Values</Value>
</Value>
<Value name="3">
<Value>Objects</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>RequestURL</Value>
</Value>
<Value name="6">
<Value>RawResponse</Value>
</Value>
<Value name="7">
<Value>SessionId</Value>
</Value>
</Data>
<Data name="Properties">
<Attribute>Properties</Attribute>
<Structure>subnode</Structure>
<Subscript>"Properties"</Subscript>
</Data>
<Data name="Records">
<Attribute>Records</Attribute>
<Structure>subnode</Structure>
<Subscript>"Records"</Subscript>
</Data>
<DataLocation>^Demo.REST.DirectoryResponseD</DataLocation>
<DefaultData>DirectoryResponseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.REST.DirectoryResponseD</IdLocation>
<IndexLocation>^Demo.REST.DirectoryResponseI</IndexLocation>
<StreamLocation>^Demo.REST.DirectoryResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
