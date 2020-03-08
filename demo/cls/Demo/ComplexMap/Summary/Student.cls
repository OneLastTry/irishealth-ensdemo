Class Demo.ComplexMap.Summary.Student Extends EnsLib.RecordMap.RecordMap
{

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.Summary.Student" type="delimited" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.Summary.Student.Record" complexBatchManaged="1" label="STS|" padFromLeft="0" recordTerminator="\x0d\x0a" allowEarlyTerminator="0">
  <Separators>
    <Separator>;</Separator>
    <Separator>,</Separator>
  </Separators>
  <Field name="StudentID" required="0" datatype="%Integer" index="1"></Field>
  <Composite name="Name" required="0">
    <Field name="Name.Family" required="0" datatype="%String"></Field>
    <Field name="Name.Given" required="0" datatype="%String"></Field>
    <Field name="Name.Middle" required="0" datatype="%String"></Field>
  </Composite>
  <Field name="Grade" required="0" datatype="%Integer"></Field>
  <Field name="Email" required="0" datatype="%String"></Field>
  <Field name="Phone" required="0" datatype="%String"></Field>
  <Field name="NumberClasses" required="0" datatype="%Integer"></Field>
  <Field name="GPA" required="0" datatype="%Numeric"></Field>
</Record>
}

Parameter OBJECTNAME = "Demo.ComplexMap.Summary.Student.Record";

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
		Set tStatus = ..GetRecord(pStream, tObject, tGetTopFields, pTimeout, .pLookAhead, pLabelFound)
		If $$$ISERR(tStatus) Quit
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	If $$$ISERR(tStatus) { Set pObject = $$$NULLOREF }
	Else { Set pObject = tObject }
	Quit tStatus
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

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "STS|" } 
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, "", pTimeout, $char(13,10), tRecLabel, .pLookAhead, "")
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tTopPiece = 1
	Set tCurrSep = 1
	Set tStrings = 1
	Set tSeps = $listbuild($char(59),$char(44))
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Else {
		Set tCurrString = tRecordData(tCurrChunk)
		Set tCurrPiece = 1
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.StudentID =  pObject.StudentIDDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	Set tStrings(tStrings) = tCurrString
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(44), 1)
	Set tStrings = tStrings + 1
	Set pObject.Name.Family = tStrings(tStrings)
	Set tStrings = tStrings - 1
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(44), 2)
	Set tStrings = tStrings + 1
	Set pObject.Name.Given = tStrings(tStrings)
	Set tStrings = tStrings - 1
	Set tStrings(tStrings+1) = $piece(tStrings(tStrings), $char(44), 3)
	Set tStrings = tStrings + 1
	Set pObject.Name.Middle = tStrings(tStrings)
	Set tStrings = tStrings - 1
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.Grade =  pObject.GradeDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.Email = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.Phone = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.NumberClasses =  pObject.NumberClassesDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(59), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(59), .tTopPiece)
	If pGetTopFields {
		Set pObject.GPA =  pObject.GPADisplayToLogical(tCurrString)
	}
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write("STS|",,.tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Do pStream.Write($select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).StudentIDLogicalToDisplay(pObject.StudentID), 1: ""),0)
	Do pStream.Write($char(59),0)
	Do pStream.Write(##class(Demo.ComplexMap.Summary.Student.Record.Name).FamilyLogicalToDisplay(pObject.Name.Family),0)
	Do pStream.Write($char(44) _ ##class(Demo.ComplexMap.Summary.Student.Record.Name).GivenLogicalToDisplay(pObject.Name.Given),0)
	Do pStream.Write($char(44) _ ##class(Demo.ComplexMap.Summary.Student.Record.Name).MiddleLogicalToDisplay(pObject.Name.Middle),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).GradeLogicalToDisplay(pObject.Grade), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).EmailLogicalToDisplay(pObject.Email), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).PhoneLogicalToDisplay(pObject.Phone), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).NumberClassesLogicalToDisplay(pObject.NumberClasses), 1: ""),0)
	Do pStream.Write($char(59) _ $select(pHasTopFields: ##class(Demo.ComplexMap.Summary.Student.Record).GPALogicalToDisplay(pObject.GPA), 1: ""),0)
	Do pStream.Write($char(13,10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

ClassMethod GetGeneratedClasses(Output pClasses As %String) As %Status
{
	Kill pClasses
	Set pClasses("Demo.ComplexMap.Summary.Student.Record")=""
	Set pClasses("Demo.ComplexMap.Summary.Student.Record.Name")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
"STS|"
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"delimited"
}

}
