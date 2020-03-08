/// ANNOTATION: Record Map describing the format of the data provided by MassDOT at http://developer.mbta.com/Data/Red.txt
/// RECORDMAP: Modified during compilation of RecordMap 'Demo.RecordMapBatch.Map.TrainDataIn'
/// on 2016-02-01 at 09:38:27.548 [2016-02-01 14:38:27.548 UTC]
/// by user UnknownUser
Class Demo.RecordMapBatch.Map.TrainDataIn Extends EnsLib.RecordMap.RecordMap
{

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

Parameter OBJECTNAME = "Demo.RecordMapBatch.Map.TrainDataIn.Record";

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "" } 
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, "", pTimeout, $char(13,10), tRecLabel, .pLookAhead, "")
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tTopPiece = 1
	Set tCurrSep = 1
	Set tStrings = 1
	Set tSeps = $listbuild($char(44,32))
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(44,32), tTopPiece)
	}
	Else {
		Set tCurrString = tRecordData(tCurrChunk)
		Set tCurrPiece = 1
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	If pGetTopFields {
		Set pObject.Line = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(44,32), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	If pGetTopFields {
		Set pObject.Trip =  pObject.TripDisplayToLogical(tCurrString)
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(44,32), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	If pGetTopFields {
		Set pObject.PlatformKey = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(44,32), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	If pGetTopFields {
		Set pObject.InformationType = tCurrString
	}
	If '$data(tRecordData(tCurrChunk, "block")) {
		Set tCurrString = $piece(tRecordData(tCurrChunk), $char(44,32), tTopPiece)
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	If pGetTopFields {
		Set pObject.Time = tCurrString
	}
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	Do ..checkMerge(.tCurrChunk, .tRecordData, .tCurrString, $char(44,32), .tTopPiece)
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write($select(pHasTopFields: pObject.Line,1: ""),0)
	Do pStream.Write($char(44,32) _ $select(pHasTopFields: pObject.TripLogicalToDisplay(pObject.Trip),1: ""),0)
	Do pStream.Write($char(44,32) _ $select(pHasTopFields: pObject.PlatformKey,1: ""),0)
	Do pStream.Write($char(44,32) _ $select(pHasTopFields: pObject.InformationType,1: ""),0)
	Do pStream.Write($char(44,32) _ $select(pHasTopFields: pObject.Time,1: ""),0)
	Do pStream.Write($char(44,32),0)
	Do pStream.Write($char(44,32),0)
	Do pStream.Write($char(44,32),0)
	Do pStream.Write($char(13,10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

ClassMethod GetGeneratedClasses(Output pClasses As %String) As %Status
{
	Kill pClasses
	Set pClasses("Demo.RecordMapBatch.Map.TrainDataIn.BatchIn")=""
	Set pClasses("Demo.RecordMapBatch.Map.TrainDataIn.Record")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
""
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"delimited"
}

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.RecordMapBatch.Map.TrainDataIn" type="delimited" char_encoding="UTF-8" targetClassname="Demo.RecordMapBatch.Map.TrainDataIn.Record" batchClass="Demo.RecordMapBatch.Map.TrainDataIn.BatchIn" complexBatchManaged="0" padFromLeft="0" recordTerminator="\x0d\x0a" allowEarlyTerminator="0">
  <Separators>
    <Separator>, </Separator>
  </Separators>
  <annotation>Record Map describing the format of the data provided by MassDOT at http://developer.mbta.com/Data/Red.txt</annotation>
  <Field name="Line" required="0" datatype="%String" repeating="0">
  </Field>
  <Field name="Trip" required="0" datatype="%Integer" repeating="0">
  </Field>
  <Field name="PlatformKey" required="0" datatype="%String" repeating="0">
  </Field>
  <Field name="InformationType" required="0" datatype="%String" repeating="0">
  </Field>
  <Field name="Time" required="0" datatype="%String" repeating="0">
  </Field>
  <Field name="TimeRemaining" required="0" ignored="1" datatype="%String" repeating="0">
    <annotation>This field appears in the incoming data, but is not mapped to a property in the record object.</annotation>
  </Field>
  <Field name="Revenue" required="0" ignored="1" datatype="%String" repeating="0">
    <annotation>This field appears in the incoming data, but is not mapped to a property in the record object.</annotation>
  </Field>
  <Field name="Route" required="0" ignored="1" datatype="%Boolean" repeating="0">
    <annotation>This field appears in the incoming data, but is not mapped to a property in the record object.</annotation>
  </Field>
</Record>
}

}
