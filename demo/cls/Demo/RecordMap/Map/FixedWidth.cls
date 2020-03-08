Class Demo.RecordMap.Map.FixedWidth Extends EnsLib.RecordMap.RecordMap [ ProcedureBlock ]
{

XData RecordMap [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<Record xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.RecordMap.Map.FixedWidth" type="fixedwidth" char_encoding="UTF-8" targetClassname="Demo.RecordMap.Map.FixedWidth.Record" paddingChars="\x20" padFromLeft="0" recordTerminator="\x0d\x0a">
  <Field name="PersonID" required="0" datatype="%String" width="8" index="1"></Field>
  <Field name="FirstName" required="0" datatype="%String" width="25"></Field>
  <Field name="MiddleInitial" required="0" datatype="%String" width="25"></Field>
  <Field name="LastName" required="0" datatype="%String" width="30"></Field>
  <Field name="DateOfBirth" required="0" datatype="%Date" width="10" params="FORMAT=3"></Field>
  <Field name="SSN" required="0" datatype="%String" width="11" index="1" params="PATTERN=3N1&quot;-&quot;2N1&quot;-&quot;4N"></Field>
  <Composite name="HomeAddress" required="0">
    <Field name="HomeAddress.StreetLine1" required="0" datatype="%String" width="30"></Field>
    <Field name="HomeAddress.City" required="0" datatype="%String" width="25"></Field>
    <Field name="HomeAddress.State" required="0" datatype="%String" width="2"></Field>
    <Field name="HomeAddress.ZipCode" required="0" datatype="%String" width="5"></Field>
  </Composite>
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

Parameter OBJECTNAME = "Demo.RecordMap.Map.FixedWidth.Record";

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
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).PersonIDLogicalToDisplay(pObject.PersonID), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 8 > tLen {
		Set tPadding = $get(pPadArray(8 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (8 - tLen + 1)) = ""
			Set pPadArray(8-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).FirstNameLogicalToDisplay(pObject.FirstName), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).MiddleInitialLogicalToDisplay(pObject.MiddleInitial), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).LastNameLogicalToDisplay(pObject.LastName), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 30 > tLen {
		Set tPadding = $get(pPadArray(30 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (30 - tLen + 1)) = ""
			Set pPadArray(30-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).DateOfBirthLogicalToDisplay(pObject.DateOfBirth), tLen = $length(tValue) }
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
	If pHasTopFields { Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record).SSNLogicalToDisplay(pObject.SSN), tLen = $length(tValue) }
	Else { Set tValue = "", tLen = 0}
	If 11 > tLen {
		Set tPadding = $get(pPadArray(11 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (11 - tLen + 1)) = ""
			Set pPadArray(11-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record.HomeAddress).StreetLine1LogicalToDisplay(pObject.HomeAddress.StreetLine1), tLen = $length(tValue)
	If 30 > tLen {
		Set tPadding = $get(pPadArray(30 - tLen))
		If tPadding = "" {
			Set $piece(tPadding, $char(32), (30 - tLen + 1)) = ""
			Set pPadArray(30-tLen) = tPadding
		}
		Set tValue = tValue_tPadding
	}
	Do pStream.Write(tValue, 0, .tStatus)
	If $$$ISERR(tStatus) Quit tStatus
	Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record.HomeAddress).CityLogicalToDisplay(pObject.HomeAddress.City), tLen = $length(tValue)
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
	Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record.HomeAddress).StateLogicalToDisplay(pObject.HomeAddress.State), tLen = $length(tValue)
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
	Set tValue = ##class(Demo.RecordMap.Map.FixedWidth.Record.HomeAddress).ZipCodeLogicalToDisplay(pObject.HomeAddress.ZipCode), tLen = $length(tValue)
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

/// Internal helper method to perform parse of incoming data
ClassMethod GetRecord(pStream As %IO.DeviceStream, pObject As %RegisteredObject, pGetTopFields As %Boolean, pTimeout As %Numeric, ByRef pLookAhead As %String = "", pLabelFound As %Boolean = 0) As %Status [ Internal, Private ]
{
	Set tStatus = $$$OK
	If pLabelFound { Set tRecLabel = "" } 
	Else { Set tRecLabel = "" } 
	Set tMaxLen = 171
	Set tStatus = ..chunkRecord(pStream, .tRecordData, .tCharCount, tMaxLen, pTimeout, $char(13,10), tRecLabel, pLookAhead)
	If $$$ISERR(tStatus) Quit tStatus
	Set tMaxLocal = $$$MaxLocalLength
	Set tRecordData("charcount") = +$get(tCharCount)
	Set tCurrChunk = 1
	Set tCurrPos = 1
	Set tNewChunk = 1
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,8,"","","PersonID")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.PersonID = pObject.PersonIDDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,25,"","","FirstName")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.FirstName = pObject.FirstNameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,25,"","","MiddleInitial")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.MiddleInitial = pObject.MiddleInitialDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,30,"","","LastName")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.LastName = pObject.LastNameDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,10,"","","DateOfBirth")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.DateOfBirth = pObject.DateOfBirthDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,11,"","","SSN")
	If $$$ISERR(tStatus) Quit tStatus
	If pGetTopFields Set pObject.SSN = pObject.SSNDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,30,"","","HomeAddress.StreetLine1")
	If $$$ISERR(tStatus) Quit tStatus
	Set pObject.HomeAddress.StreetLine1 = pObject.HomeAddress.StreetLine1DisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,25,"","","HomeAddress.City")
	If $$$ISERR(tStatus) Quit tStatus
	Set pObject.HomeAddress.City = pObject.HomeAddress.CityDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,2,"","","HomeAddress.State")
	If $$$ISERR(tStatus) Quit tStatus
	Set pObject.HomeAddress.State = pObject.HomeAddress.StateDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Set tCurrVal = ..checkFixedWidthChunk(.tStatus,.tNewChunk,.tCurrChunk,.tRecordData,.tCurrString,.tCurrLen,.tCurrPos,5,"","","HomeAddress.ZipCode")
	If $$$ISERR(tStatus) Quit tStatus
	Set pObject.HomeAddress.ZipCode = pObject.HomeAddress.ZipCodeDisplayToLogical($ZStrip(tCurrVal, ">", $char(32)))
	Quit tStatus
}

}
