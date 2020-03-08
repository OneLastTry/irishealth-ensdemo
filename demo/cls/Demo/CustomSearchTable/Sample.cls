/// This is a sample CustomSearchTable to demonstrate the some of the primary features of 
/// custom search tables by showing possible indexing strategies for the <class>Ens.StreamContainer</class> class.<br/>
/// The SearchTable implements a multi-index approach to indexing the first 12 characters of the
/// target Stream property using bitmap indices on <property>%FirstFour</property>, <property>%SecondFour</property> and
/// <property>%ThirdFour</property>. The underlying properties start with the "%" character so they are not
/// directly exposed to users as options - instead, the Stream12 virtual property is listed as an indexed property
/// in <method>GetVirtualPropertyList</method>(), so users can search on the first 12 characters. The actual search implementation
/// is in the <method>OnProcessCondition</method>() callback so that the indices are used by the SQL engine. <br/>
/// The Stream250Early and Stream250Late virtual properties demonstrate the two options available for retrieving and displaying
/// the first 250 characters of the stream without needing to index the contents of the stream. 
/// The Stream250Early property is fetched "Early" because it is fetched using an SQL stored procedure during the SQL processing of results
/// and any conditions on the property are applied by the SQL engine. The Stream250Late property is fetched "Late" because it is 
/// fetched using a COS callback after the SQL engine has constructed a result set, so any conditions are applied as the COS code iterates
/// over the results produced using standard SQL. Both properties are listed as non-indexed virtual properties in 
/// <method>GetVirtualPropertyList</method>(), and the code to actually fetch the values is implemented in <method>GetVirtualProperty</method>().
Class Demo.CustomSearchTable.Sample Extends Ens.CustomSearchTable
{

/// This class is intended to index <class>Ens.StreamContainer</class> messages.
/// The <class>EnsLib.File.PassthroughService</class> and <class>EnsLib.FTP.PassthroughService</class>
/// services send these messages, so you can experiment by indexing messages as sent by these services.
Parameter DOCCLASS = "Ens.StreamContainer";

/// OrigFilename is stored as a non-indexed property of the SearchTable class.
/// This is somewhat redundant, but means that SQL operations which display this value
/// don't need to load data from the original data location when the SearchTable is used
/// to perform comparisons in a query.
Property OrigFilename As %String;

/// Type describes the type of stream referenced in the Stream property of the StreamContainer.
/// It is a short text code, so lends itself to creating a bitmap index -- see the Type for details.
/// The property is also declared with EXACT collation to ensure that any character-based matches
/// are peformed using exact matching and NOT the default of uppercase matching.
Property Type As %String(COLLATION = "EXACT");

/// The Type index is declared as a bitmap index as the <property>Type</property> property contains a short character
/// code, so it is very efficient to match on specific values for this field.
Index Type On Type [ Type = bitmap ];

/// %FirstFour is intended to capture the first four characters of the StreamContainer's Stream contents.
/// The property demonstrates how properties which start with "%" are not displayed to the user, but may be used
/// when constructing queries. The four character restriction is imposed to allow the First bitmap 
/// index to be created on only these characters.
Property %FirstFour As %String(MAXLEN = 4);

/// This is a bitmap index on the first four characters of the stream's contents. It is intended to be used in 
/// conjunction with the Second and Third indices to find the first 12 characters of
/// stream contents very efficiently. The eventual goal is to use a virtual property which relies on these indices
/// to construct rapid searches on the underlying data without needing expensive reads of the entire stream from disk.
Index First On %FirstFour [ Type = bitmap ];

/// %SecondFour is intended to capture the second four characters of the StreamContainer's Stream contents.
/// The property demonstrates how properties which start with "%" are not displayed to the user, but may be used
/// when constructing queries. The four character restriction is imposed to allow the Second bitmap
/// index to be created on only these characters.
Property %SecondFour As %String(MAXLEN = 4);

/// This is a bitmap index on the second four characters of the stream's contents. It is intended to be used in 
/// conjunction with the First and Third indices to find the first 12 characters of
/// stream contents very efficiently. The eventual goal is to use a virtual property which relies on these indices
/// to construct rapid searches on the underlying data without needing expensive reads of the entire stream from disk.
Index Second On %SecondFour [ Type = bitmap ];

/// %ThirdFour is intended to capture the third four characters of the StreamContainer's Stream contents.
/// The property demonstrates how properties which start with "%" are not displayed to the user, but may be used
/// when constructing queries. The four character restriction is imposed to allow the Third bitmap
/// index to be created on only these characters.
Property %ThirdFour As %String(MAXLEN = 4);

/// This is a bitmap index on the third four characters of the stream's contents. It is intended to be used in 
/// conjunction with the First and Second indices to find the first 12 characters of
/// stream contents very efficiently. The eventual goal is to use a virtual property which relies on these indices
/// to construct rapid searches on the underlying data without needing expensive reads of the entire stream from disk.
Index Third On %ThirdFour [ Type = bitmap ];

/// Callback invoked by the Message Viewer UI whenever a condition for a CustomSearchTable
/// is selected. <var>pProperty</var> specifies the property name to be retrieved. Note: <var>pProperty</var> may be
/// the empty string when adding a SearchTable for the first time. Ensure that the code in this method handles this case.
/// <var>pDisplayOnly</var> indicates whether the user has selected the property as a display-only field. If <var>pDisplayOnly</var>
/// is true, the values for the value and operator supplied in <var>pValue</var> and <var>pOperator</var>, respectively,
/// should be ignored and no conditions should be added to the WHERE clause. If <var>pDisplayOnly</var> is false,
/// users should make use of the GetSQLCondition() API in <class>EnsPortal.MsgFilter.Assistant</class> to produce
/// valid SQL WHERE conditions based on the supplied arguments. <var>pTableName</var> specifies the name of the table to
/// use in the FROM clause, and <var>pTableInFrom</var> indicates whether the table is already present in the FROM clause.
/// <var>pSelectAsName</var> is the alias which should be used for the column in the eventual resultset.
/// The <var>pSelect</var>, <var>pFrom</var> and <var>pWhere</var> arguments are strings which determine which subclauses (if any)
/// should be added to the corresponding sections of the overall SQL query, and can be modified as needed while in this callback. The
/// <var>pSQLFetch</var> flag indicates whether the value will be completely fetched by the supplied SQL terms. By default, ALL virtual
/// properties will only be retrieved using ObjectScript AFTER the main SQL results have been produced. The purpose of this is to allow
/// the post-SQL filter code to load all encountered virtual properties using the <method>GetVirtualProperties</method>() API.
/// Users should override this behaviour when indices are available in this class to improve the fetch performance of the generated query.
/// In a similar vein, users may want to delay retrieval of non-indexed standard properties until after the SQL phase is complete, though
/// this is not necessarily more efficient.
ClassMethod OnProcessCondition(pProperty As %String, pOperator As %String, pValue As %String, pTableName As %String, pTableInFrom As %Boolean, pSelectAsName As %String, pDisplayOnly As %Boolean = 0, ByRef pSelect As %String, ByRef pFrom As %String, ByRef pWhere As %String, ByRef pSQLFetch As %Boolean) As %Status
{
	// Ensure the source table has been added to the FROM clause as we reference the table in the SELECT clause
	If 'pTableInFrom {
		Set pFrom = pFrom _ $select(pFrom = "": "", 1: ", ") _ pTableName
	}
	If (pProperty = "Stream12") {
		// Indicate that all processing will occur in the SQL query
		Set pSQLFetch = 1
		// Add the properties to the SELECT clause
		Set pSelect = "("_pTableName_".%FirstFour || "_pTableName_".%SecondFour || "_pTableName_".%ThirdFour) As "_pSelectAsName
		If 'pDisplayOnly {
			// Get the requested values
			Set tValOne = $extract(pValue,1,4)
			Set tValTwo = $extract(pValue,5,8)
			Set tValThree = $extract(pValue,9,12)
		
			// Use the GetSQLCondition() helper method in EnsPortal.MsgFilter.Assistant to get a valid WHERE subclause for each comparison
			Set tWhere(1) = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,pTableName_".%FirstFour",tValOne)
			Set tWhere(2) = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,pTableName_".%SecondFour",tValTwo)
			Set tWhere(3) = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,pTableName_".%ThirdFour",tValThree)
			// Add the conditions to the WHERE clause
			For i=1:1:3 {
				Set pWhere = pWhere _ $select(pWhere = "": "", tWhere(i) = "": "", 1: " AND ") _ tWhere(i)
			}
		}
	}
	ElseIf (pProperty = "Stream250Early") {
		// Override the default behaviour for virtual properties and fetch the data using the Stored Procedure API.
		Set pSQLFetch = 1
		Set tProc = "Ens.CustomSearchTable_GetVirtualPropertyProc('"_$classname()_"',head.MessageBodyId,'Stream250Early')"
		Set pSelect = tProc _ " As " _ pSelectAsName
		// Add conditions if needed
		If 'pDisplayOnly {
			Set tWhere = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,tProc,pValue)
			If tWhere '= "" Set pWhere = pWhere _ $select(pWhere = "": "", 1: " AND ") _ tWhere
		}
	}
	ElseIf (pProperty = "StreamType") || (pProperty = "Stream250Late"){
		// The default behaviour for virtual properties to add a clause where we SELECT NULL As SearchTable_Alias
		// So we don't need to do anything for this case.
	}
	// We can also modify the way standard fields are fetched, as this method is invoked for ALL requested types.
	// By default, Type and OriginalFilename will be fetched directly using SQL references against the table.
	Quit $$$OK
}

/// We provide a number of virtual properties in this class.
/// Stream12 is a virtual property which represents the first 12 characters of the stream, which are indexed.
/// Stream250Early and Stream250Late both represent the first 250 characters of the stream which are not indexed.
/// Stream250Early is a virtual property which is fetched via a stored procedure during SQL execution, while
/// Stream250Late is a virtual property which is fetched via the <method>GetVirtualProperties</method>() API.
/// StreamType is a virtual property which represents the actual stream type and is fetched via the <method>GetVirtualProperties()</method> API.
/// For both of the last two properties, code is needed in <method>OnProcessCondition</method>() to indicate that
/// the property should not be fetched via SQL.
ClassMethod GetVirtualPropertyList(Output pIndexedVirtualProperties As %List, Output pVirtualProperties As %List) As %Status
{
	Set pIndexedVirtualProperties = $lb("Stream12")
	Set pVirtualProperties = $lb("Stream250Early","Stream250Late","StreamType")
	Quit $$$OK
}

/// API to retrieve a named virtual property for a given document ID.
/// If a virtual property is specified in <method>GetVirtualPropertyList</method>(), this
/// method should be updated to implement retrieval code for the property. Note that if
/// <method>GetVirtualProperties</method>() is overridden, this method may not be called for value retrieval.
ClassMethod GetVirtualProperty(pDocID As %String, pPropName As %String, Output pPropValue As %String, ByRef pUserArgs) As %Status
{
	Set pPropValue = ""
	If (pPropName = "Stream250Early") || (pPropName = "Stream250Late") {
		Set tContainer = ##class(Ens.StreamContainer).%OpenId(pDocID)
		If $IsObject(tContainer) && $IsObject(tContainer.Stream) {
			Set pPropValue = tContainer.Stream.Read(250)
		}
	}
	Quit $$$OK
}

/// Callback which should be implemented by users to populate the CustomSearchTable
/// supplied in <var>Ens.CustomSearchTable</var> based on <var>pDocObj</var>. Note that
/// the DocId property is prepopulated, so doesn't need to be reset. If the user doesn't
/// want a particular CustomSearchTable instance to be saved, the user can set <var>pSearchTable</var>
/// to the empty string (i.e. "") to prevent the indexing framework from saving an entry to disk.
ClassMethod OnIndexDoc(pDocObj As Ens.StreamContainer, pSearchTable As Demo.CustomSearchTable.Sample) As %Status
{
	Set pSearchTable.OrigFilename = pDocObj.OriginalFilename
	Set pSearchTable.Type = pDocObj.Type
	Do pDocObj.Stream.Rewind()
	Set tTwelve = pDocObj.Stream.Read(12)
	Do pDocObj.Stream.Rewind()
	Set pSearchTable.%FirstFour = $extract(tTwelve,1,4)
	Set pSearchTable.%SecondFour = $extract(tTwelve,5,8)
	Set pSearchTable.%ThirdFour = $extract(tTwelve,9,12)
	Quit $$$OK
}

/// Override of the base implementation of GetVirtualProperties(). We only load the
/// target <class>Ens.StreamContainer</class> object once when retrieving multiple
/// values for the instance.
ClassMethod GetVirtualProperties(pDocID As %String, pPropNames As %List, Output pPropValues As %List) As %Status
{
	Set tSC = $$$OK
	Set pPropValues = ""
	If $listlength($get(pPropNames)) = 0 Quit tSC
	Set tContainer = ##class(Ens.StreamContainer).%OpenId(pDocID)
	If $IsObject(tContainer) {
		Do tContainer.Stream.Rewind()
		Set tFirst250 = $select($listfind(pPropNames,"Stream250Late") || $listfind(pPropNames,"Stream250Early"): tContainer.Stream.Read(250), 1: "")
		For i=1:1:$ll(pPropNames) {
			Set tProp = $lg(pPropNames,i)
			Set $li(pPropValues,i) = $case(tProp,
										"StreamType": $classname(tContainer.Stream),
										"Stream250Early": tFirst250,
										"Stream250Late": tFirst250,
										: "")
		}
		Do tContainer.Stream.Rewind()
	}
	Quit tSC
}

Storage Default
{
<Data name="SampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>OrigFilename</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>%FirstFour</Value>
</Value>
<Value name="6">
<Value>%SecondFour</Value>
</Value>
<Value name="7">
<Value>%ThirdFour</Value>
</Value>
</Data>
<DataLocation>^Demo.CustomSearchTable.SampleD</DataLocation>
<DefaultData>SampleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.CustomSearchTable.SampleD</IdLocation>
<IndexLocation>^Demo.CustomSearchTable.SampleI</IndexLocation>
<StreamLocation>^Demo.CustomSearchTable.SampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
