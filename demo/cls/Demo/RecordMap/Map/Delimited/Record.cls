/// RECORDMAP: Generated from RecordMap 'Demo.RecordMap.Map.Delimited'
/// on 2010-09-30 at 16:20:02.209 [2010-09-30 21:20:02.209 UTC]
/// by user DemoUser
Class Demo.RecordMap.Map.Delimited.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Relationship %ParentBatch As Demo.RecordMap.Map.Delimited.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

Index LastNameIdx On LastName;

Index PersonIDIdx On PersonID;

Index SSNIdx On SSN;

Parameter RECORDMAPGENERATED = 1;

Parameter INCLUDETOPFIELDS = 1;

Property PersonID As %Integer;

Property Age As %Integer;

Property DateOfBirth As %Date(FORMAT = 1);

Property FavoriteColor As %String;

Property LastName As %String;

Property FirstName As %String;

Property MiddleInitial As %String;

Property SSN As %String(PATTERN = "3N1""-""2N1""-""4N");

Property HomeAddress As Demo.RecordMap.Map.Delimited.Record.HomeAddress;

Property WorkAddress As Demo.RecordMap.Map.Delimited.Record.WorkAddress;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%Source</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>DateOfBirth</Value>
</Value>
<Value name="5">
<Value>FavoriteColor</Value>
</Value>
<Value name="6">
<Value>LastName</Value>
</Value>
<Value name="7">
<Value>FirstName</Value>
</Value>
<Value name="8">
<Value>MiddleInitial</Value>
</Value>
<Value name="9">
<Value>SSN</Value>
</Value>
<Value name="10">
<Value>HomeAddress</Value>
</Value>
<Value name="11">
<Value>WorkAddress</Value>
</Value>
<Value name="12">
<Value>%ParentBatch</Value>
</Value>
<Value name="13">
<Value>PersonID</Value>
</Value>
</Data>
<DataLocation>^Demo.RecordMap.MapC0CE.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.RecordMap.MapC0CE.RecordD</IdLocation>
<IndexLocation>^Demo.RecordMap.MapC0CE.RecordI</IndexLocation>
<StreamLocation>^Demo.RecordMap.MapC0CE.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
