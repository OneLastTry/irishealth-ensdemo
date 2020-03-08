Class Demo.ComplexMap.SemesterFixed.Semester Extends EnsLib.RecordMap.RecordMap
{

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.SemesterFixed.Semester" type="fixedwidth" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.SemesterFixed.Semester.Record" complexBatchManaged="1" label="SEM|" paddingChars="\x20" padFromLeft="0" recordTerminator="\x0d\x0a" allowEarlyTerminator="0">
  <Field name="SemesterID" required="0" datatype="%Integer" width="4" index="1"></Field>
  <Field name="Year" required="0" datatype="%Integer" width="4"></Field>
  <Field name="Name" required="0" datatype="%String" width="10"></Field>
  <Field name="NumWeeks" required="0" datatype="%Integer" width="2"></Field>
  <Field name="RecordCount" required="0" datatype="%Integer" width="5"></Field>
</Record>
}

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

Parameter OBJECTNAME = "Demo.ComplexMap.SemesterFixed.Semester.Record";

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "SEM|" } 
	Set tMaxLen = 25 + $length(tRecLabel)
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
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,4,"","","SemesterID",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.SemesterID = pObject.SemesterIDDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,4,"","","Year",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Year = pObject.YearDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,10,"","","Name",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Name = pObject.NameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,2,"","","NumWeeks",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.NumWeeks = pObject.NumWeeksDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,5,"","","RecordCount",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.RecordCount = pObject.RecordCountDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write("SEM|",,.tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).SemesterIDLogicalToDisplay(pObject.SemesterID), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 4 > tLen {
		Set tPadding = $get(pPadArray(4 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (4 - tLen + 1)) = ""
			Set pPadArray(4-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).YearLogicalToDisplay(pObject.Year), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 4 > tLen {
		Set tPadding = $get(pPadArray(4 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (4 - tLen + 1)) = ""
			Set pPadArray(4-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).NameLogicalToDisplay(pObject.Name), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).NumWeeksLogicalToDisplay(pObject.NumWeeks), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 2 > tLen {
		Set tPadding = $get(pPadArray(2 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (2 - tLen + 1)) = ""
			Set pPadArray(2-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Semester.Record).RecordCountLogicalToDisplay(pObject.RecordCount), tLen = $length(tValue) }
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
	Do pStream.Write($char(13,10), 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Quit tStatus
}

ClassMethod GetGeneratedClasses(Output pClasses As %String) As %Status
{
	Kill pClasses
	Set pClasses("Demo.ComplexMap.SemesterFixed.Semester.Record")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
"SEM|"
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"fixedwidth"
}

}
