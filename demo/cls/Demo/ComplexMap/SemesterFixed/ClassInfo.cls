/// RECORDMAP: Modified during compilation of RecordMap 'Demo.ComplexMap.SemesterFixed.ClassInfo'
/// on 2015-10-29 at 10:48:06.106 [2015-10-29 15:48:06.106 UTC]
/// by user UnknownUser
Class Demo.ComplexMap.SemesterFixed.ClassInfo Extends EnsLib.RecordMap.RecordMap
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

Parameter OBJECTNAME = "Demo.ComplexMap.SemesterFixed.ClassInfo.Record";

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "CLS|" } 
	Set tMaxLen = 73 + $length(tRecLabel)
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, tMaxLen, pTimeout, $char(13,10), tRecLabel, .pLookAhead, .tExtra)
	If $$$ISERR(tStatus) Quit tStatus
	Set pLookAhead = $get(tExtra)
	Set tIgnoreEarlyTerminator = 0
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tCurrPos = 1
	Set tNewChunk = 1
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,15,"","","ClassID",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.ClassID = pObject.ClassIDDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,10,"","","SectionID",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.SectionID = pObject.SectionIDDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,40,"","","Title",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Title = pObject.TitleDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,5,"","","Grade",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Grade = pObject.GradeDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,3,"","","StudentCount",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.StudentCount = pObject.StudentCountDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write("CLS|",,.tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).ClassIDLogicalToDisplay(pObject.ClassID), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 15 > tLen {
		Set tPadding = $get(pPadArray(15 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (15 - tLen + 1)) = ""
			Set pPadArray(15-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).SectionIDLogicalToDisplay(pObject.SectionID), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 10 > tLen {
		Set tPadding = $get(pPadArray(10 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (10 - tLen + 1)) = ""
			Set pPadArray(10-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).TitleLogicalToDisplay(pObject.Title), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 40 > tLen {
		Set tPadding = $get(pPadArray(40 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (40 - tLen + 1)) = ""
			Set pPadArray(40-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).GradeLogicalToDisplay(pObject.Grade), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 5 > tLen {
		Set tPadding = $get(pPadArray(5 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (5 - tLen + 1)) = ""
			Set pPadArray(5-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo.Record).StudentCountLogicalToDisplay(pObject.StudentCount), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 3 > tLen {
		Set tPadding = $get(pPadArray(3 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (3 - tLen + 1)) = ""
			Set pPadArray(3-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Do pStream.Write($char(13,10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

ClassMethod GetGeneratedClasses(Output pClasses As %String) As %Status
{
	Kill pClasses
	Set pClasses("Demo.ComplexMap.SemesterFixed.ClassInfo.Record")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
"CLS|"
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"fixedwidth"
}

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.SemesterFixed.ClassInfo" type="fixedwidth" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.SemesterFixed.ClassInfo.Record" complexBatchManaged="1" label="CLS|" paddingChars="\x20" padFromLeft="0" recordTerminator="\x0d\x0a" allowEarlyTerminator="0">
  <Field name="ClassID" required="0" datatype="%String" width="15" index="1">
  </Field>
  <Field name="SectionID" required="0" datatype="%String" width="10">
  </Field>
  <Field name="Title" required="0" datatype="%String" width="40">
  </Field>
  <Field name="Grade" required="0" datatype="%String" width="5" repeating="0">
  </Field>
  <Field name="StudentCount" required="0" datatype="%Integer" width="3">
  </Field>
</Record>
}

}
