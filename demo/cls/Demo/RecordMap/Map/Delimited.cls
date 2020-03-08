Class Demo.RecordMap.Map.Delimited Extends EnsLib.RecordMap.RecordMap [ ProcedureBlock ]
{

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.RecordMap.Map.Delimited" type="delimited" char_encoding="UTF-8" targetClassname="Demo.RecordMap.Map.Delimited.Record" batchClass="Demo.RecordMap.Map.Delimited.Batch" padFromLeft="0" recordTerminator="\x0d\x0a">
  <Separators>
    <Separator>;</Separator>
    <Separator>,</Separator>
    <Separator>\x20</Separator>
  </Separators>
  <Field name="PersonID" required="0" datatype="%Integer" index="1"></Field>
  <Field name="Age" required="0" datatype="%Integer"></Field>
  <Field name="DateOfBirth" required="0" datatype="%Date" params="FORMAT=1"></Field>
  <Field name="FavoriteColor" required="0" datatype="%String"></Field>
  <Composite name="Name" required="0">
    <Field name="LastName" required="0" datatype="%String" index="1"></Field>
    <Composite name="GivenNames" required="0">
      <Field name="FirstName" required="0" datatype="%String"></Field>
      <Field name="MiddleInitial" required="0" datatype="%String"></Field>
    </Composite>
  </Composite>
  <Field name="SSN" required="0" datatype="%String" index="1" params="PATTERN=3N1&quot;-&quot;2N1&quot;-&quot;4N"></Field>
  <Field name="HomeAddress.City" required="0" datatype="%String"></Field>
  <Field name="HomeAddress.State" required="0" datatype="%String" params="MAXLEN=2"></Field>
  <Field name="HomeAddress.StreetLine1" required="0" datatype="%String"></Field>
  <Field name="HomeAddress.ZipCode" required="0" datatype="%String"></Field>
  <Field name="WorkAddress.City" required="0" datatype="%String"></Field>
  <Field name="WorkAddress.State" required="0" datatype="%String" params="MAXLEN=2"></Field>
  <Field name="WorkAddress.StreetLine1" required="0" datatype="%String"></Field>
  <Field name="WorkAddress.ZipCode" required="0" datatype="%String"></Field>
</Record>
}

/// Method to write a record to a stream or device. This method will be generated based on the
/// structure of the RecordMap. For testing purposes, a file name may be passed in the pStream argument.
ClassMethod PutObject(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pFlush As %Boolean = 1, ByRef pPadArray As %String) As %Status
{
	Try {
		Set tStatus = $$$OK
		If '$IsObject(pStream) {
			Set tFilename = pStream
			Set pStream = ##class(%IO.FileStream).%New()
			Do pStream.Open(tFilename,"WAE",,"UTF-8", .tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tHasTopFields = $parameter(pObject,"INCLUDETOPFIELDS")
		Set pStream.CharEncoding = "UTF-8"

		Set tStatus = ..PutRecord(pStream, pObject, tHasTopFields, .pPadArray)
		If $$$ISERR(tStatus) Quit
		If pFlush Do pStream.Flush(.tStatus)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Quit tStatus
}

Parameter OBJECTNAME = "Demo.RecordMap.Map.Delimited.Record";

/// Method to retrieve a record from a stream or device. This method will be generated based on the
/// structure of the RecordMap. For testing purposes, a file name may be passed in the pStream argument.
ClassMethod GetObject(pStream As %IO.DeviceStream, Output pObject As %RegisteredObject, pTimeout As %Numeric = -1, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status
{
	Try {
		Set tStatus = $$$OK
		Set pObject = $$$NULLOREF
		If '$IsObject(pStream) {
			Set tFilename = pStream
			Set pStream = ##class(%IO.FileStream).%New()
			Do pStream.Open(tFilename,,pTimeout,"UTF-8", .tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tObjectName = $parameter($this,"OBJECTNAME")
		Set tObject = $classmethod(tObjectName,"%New")
		If '$IsObject(tObject) {
			Set tStatus = $$$ERROR($$$CannotCreateObject,tObjectName)
			Quit
		}
		Set tObject.%Source = pStream.Name
		Set tGetTopFields = $parameter(tObject,"INCLUDETOPFIELDS")
		If pStream.AtEnd {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrStreamAtEnd, pStream.Name)
			Quit
		}
		Set pStream.CharEncoding = "UTF-8"

		#; Parse incoming stream
		Set tStatus = ..GetRecord(pStream, tObject, tGetTopFields, pTimeout, pLookAhead, pLabelFound)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $$$ISERR(tStatus) { Set pObject = $$$NULLOREF }
	Else { Set pObject = tObject }
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write($select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).PersonIDLogicalToDisplay(pObject.PersonID), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).AgeLogicalToDisplay(pObject.Age), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).DateOfBirthLogicalToDisplay(pObject.DateOfBirth), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).FavoriteColorLogicalToDisplay(pObject.FavoriteColor), 1: ""),0)
	Do pStream.Write($char(59),0)
	Do pStream.Write($select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).LastNameLogicalToDisplay(pObject.LastName), 1: ""),0)
	Do pStream.Write($char(44),0)
	Do pStream.Write($select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).FirstNameLogicalToDisplay(pObject.FirstName), 1: ""),0)
	Do pStream.Write($char(32) _ $select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).MiddleInitialLogicalToDisplay(pObject.MiddleInitial), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.RecordMap.Map.Delimited.Record).SSNLogicalToDisplay(pObject.SSN), 1: ""),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.HomeAddress).CityLogicalToDisplay(pObject.HomeAddress.City),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.HomeAddress).StateLogicalToDisplay(pObject.HomeAddress.State),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.HomeAddress).StreetLine1LogicalToDisplay(pObject.HomeAddress.StreetLine1),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.HomeAddress).ZipCodeLogicalToDisplay(pObject.HomeAddress.ZipCode),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.WorkAddress).CityLogicalToDisplay(pObject.WorkAddress.City),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.WorkAddress).StateLogicalToDisplay(pObject.WorkAddress.State),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.WorkAddress).StreetLine1LogicalToDisplay(pObject.WorkAddress.StreetLine1),0)
	Do pStream.Write($char(59) _ ##class(Demo.RecordMap.Map.Delimited.Record.WorkAddress).ZipCodeLogicalToDisplay(pObject.WorkAddress.ZipCode),0)
	Do pStream.Write($char(13,10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "" } 
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, "", pTimeout, $char(13,10), tRecLabel, pLookAhead, "")
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tTopPiece = 1
	Set tCurrSep = 1
	Set tStrings = 1
	Set tSeps = $listbuild($char(59),$char(44),$char(32))
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Else {
		Set tCurrString = tRecordData(tCurrChunk)
		Set tCurrPiece = 1
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.PersonID =  pObject.PersonIDDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.Age =  pObject.AgeDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.DateOfBirth =  pObject.DateOfBirthDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.FavoriteColor = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set tStrings(tStrings) = tCurrString
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(44), 1)
	Set tStrings = tStrings + 1
	If pGetTopFields {
		Set pObject.LastName = tStrings(tStrings)
	}
	Set tStrings = tStrings - 1
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(44), 2)
	Set tStrings = tStrings + 1
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(32), 1)
	Set tStrings = tStrings + 1
	If pGetTopFields {
		Set pObject.FirstName = tStrings(tStrings)
	}
	Set tStrings = tStrings - 1
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(32), 2)
	Set tStrings = tStrings + 1
	If pGetTopFields {
		Set pObject.MiddleInitial = tStrings(tStrings)
	}
	Set tStrings = tStrings - 1
	Set tStrings = tStrings - 1
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.SSN = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.HomeAddress.City = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.HomeAddress.State = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.HomeAddress.StreetLine1 = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.HomeAddress.ZipCode = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.WorkAddress.City = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.WorkAddress.State = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.WorkAddress.StreetLine1 = tCurrString
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set pObject.WorkAddress.ZipCode = tCurrString
	Quit tStatus
}

}
