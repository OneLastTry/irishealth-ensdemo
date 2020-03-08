Class Demo.ComplexMap.SemesterFixed.Student Extends EnsLib.RecordMap.RecordMap
{

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.SemesterFixed.Student" type="fixedwidth" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.SemesterFixed.Student.Record" complexBatchManaged="1" label="STU|" paddingChars="\x20" padFromLeft="0" recordTerminator="\x0d\x0a" allowEarlyTerminator="0">
  <Field name="StudentID" required="0" datatype="%String" width="9" index="1"></Field>
  <Field name="LastName" required="0" datatype="%String" width="25"></Field>
  <Field name="FirstName" required="0" datatype="%String" width="20"></Field>
  <Field name="MiddleName" required="0" datatype="%String" width="20"></Field>
  <Field name="Grade" required="0" datatype="%Integer" width="2"></Field>
  <Field name="Email" required="0" datatype="%String" width="40"></Field>
  <Field name="Phone" required="0" datatype="%String" width="20"></Field>
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

Parameter OBJECTNAME = "Demo.ComplexMap.SemesterFixed.Student.Record";

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "STU|" } 
	Set tMaxLen = 136 + $length(tRecLabel)
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
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,9,"","","StudentID",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.StudentID = pObject.StudentIDDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,25,"","","LastName",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.LastName = pObject.LastNameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,20,"","","FirstName",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.FirstName = pObject.FirstNameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,20,"","","MiddleName",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.MiddleName = pObject.MiddleNameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,2,"","","Grade",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Grade = pObject.GradeDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,40,"","","Email",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Email = pObject.EmailDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,20,"","","Phone",tIgnoreEarlyTerminator)
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.Phone = pObject.PhoneDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Quit tStatus
}

/// Internal helper method to output object to a stream
ClassMethod PutRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pHasTopFields As %Boolean, ByRef pPadArray As %String) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	Do pStream.Write("STU|",,.tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).StudentIDLogicalToDisplay(pObject.StudentID), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 9 > tLen {
		Set tPadding = $get(pPadArray(9 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (9 - tLen + 1)) = ""
			Set pPadArray(9-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).LastNameLogicalToDisplay(pObject.LastName), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 25 > tLen {
		Set tPadding = $get(pPadArray(25 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (25 - tLen + 1)) = ""
			Set pPadArray(25-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).FirstNameLogicalToDisplay(pObject.FirstName), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 20 > tLen {
		Set tPadding = $get(pPadArray(20 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (20 - tLen + 1)) = ""
			Set pPadArray(20-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).MiddleNameLogicalToDisplay(pObject.MiddleName), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 20 > tLen {
		Set tPadding = $get(pPadArray(20 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (20 - tLen + 1)) = ""
			Set pPadArray(20-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).GradeLogicalToDisplay(pObject.Grade), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).EmailLogicalToDisplay(pObject.Email), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.ComplexMap.SemesterFixed.Student.Record).PhoneLogicalToDisplay(pObject.Phone), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 20 > tLen {
		Set tPadding = $get(pPadArray(20 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (20 - tLen + 1)) = ""
			Set pPadArray(20-tLen) = tPadding
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
	Set pClasses("Demo.ComplexMap.SemesterFixed.Student.Record")=""
	Set pClasses($classname())=""
	Quit $$$OK
}

ClassMethod getIdentifier() As %String [ CodeMode = expression ]
{
"STU|"
}

ClassMethod getType() As EnsLib.RecordMap.Model.DataType.RecordType [ CodeMode = expression ]
{
"fixedwidth"
}

}
