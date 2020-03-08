Include Ensemble

Class Demo.REST.DirectoryRequest Extends (%Persistent, %XML.Adaptor)
{

Parameter RESPONSECLASSNAME = "Demo.REST.DirectoryResponse";

Property Command As %String [ InitialExpression = "GET" ];

Property Type As %String [ InitialExpression = "person" ];

Property Key As %String [ InitialExpression = "name" ];

Property KeyValue As %String;

Property Field As %String;

/// For JSON content submission
Property Body As %GlobalCharacterStream;

ClassMethod NewResponse(Output pResponse As Ens.Response) As %Status
{
	try {
		Set pResponse = $classmethod(..#RESPONSECLASSNAME,"%New")  Set tSC=$S($IsObject(pResponse):$$$OK, 1:%objlasterror)
	} catch {
		Set tSC=$$$SystemError
	}
	Quit tSC
}

Storage Default
{
<Data name="DirectoryRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Command</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Key</Value>
</Value>
<Value name="5">
<Value>KeyValue</Value>
</Value>
<Value name="6">
<Value>Field</Value>
</Value>
<Value name="7">
<Value>Body</Value>
</Value>
</Data>
<DataLocation>^Demo.REST.DirectoryRequestD</DataLocation>
<DefaultData>DirectoryRequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.REST.DirectoryRequestD</IdLocation>
<IndexLocation>^Demo.REST.DirectoryRequestI</IndexLocation>
<StreamLocation>^Demo.REST.DirectoryRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
