Class Demo.ComplexMap.SemesterFixed.StudentMap Extends EnsLib.RecordMap.ComplexMap
{

Parameter RECORDMAPGENERATED = 1;

XData ComplexBatch [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<ComplexBatch xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.SemesterFixed.StudentMap" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.SemesterFixed.StudentBatch">
  <Header name="Semester" recordMap="Demo.ComplexMap.SemesterFixed.Semester"></Header>
  <RecordReference name="Students" required="0" repeating="1" minRepeats="1" recordMap="Demo.ComplexMap.SemesterFixed.Student"></RecordReference>
</ComplexBatch>
}

Parameter BATCHCLASS = "Demo.ComplexMap.SemesterFixed.StudentBatch";

ClassMethod PutBatch(pIOStream As %IO.DeviceStream, pBatch As EnsLib.RecordMap.ComplexBatch) As %Status
{
	Set tStatus = $$$OK
	Try {
		If '$IsObject($get(pBatch)) Set tStatus = $$$ERROR($$$ObjectInstanceRequired) Quit
		If '$IsObject(pIOStream) {
			Set tFilename = pIOStream
			Set pIOStream = ##class(%IO.FileStream).%New()
			Do pIOStream.Open(tFilename,"WAE",,"UTF-8",.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.Semester).PutObject(pIOStream,pBatch.Semester,0)
		If $$$ISERR(tStatus) Quit
		For i=1:1:pBatch.Students.Count() {
			Set tElement = pBatch.Students.GetAt(i)
			If $IsObject(tElement) {
				Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.Student).PutObject(pIOStream,tElement,0)
				If $$$ISERR(tStatus) Quit
			}
		}
		If $$$ISERR(tStatus) Quit
		Do pIOStream.Flush(.tStatus)
		If $$$ISERR(tStatus) Quit
	} Catch ex {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

ClassMethod GetBatch(pIOStream As %IO.DeviceStream, pTimeout As %Numeric = -1, Output pBatch As EnsLib.RecordMap.ComplexBatch) As %Status
{
	Set tStatus = $$$OK
	Try {
		If '$IsObject(pIOStream) {
			Set tFilename = pIOStream
			Set pIOStream = ##class(%IO.FileStream).%New()
			Do pIOStream.Open(tFilename,,pTimeout,"UTF-8",.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set pIOStream.CharEncoding = "UTF-8"
		Set pBatch = ##class(Demo.ComplexMap.SemesterFixed.StudentBatch).%New()
		Set pBatch.%Source = pIOStream.Name
		Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.Semester).GetObject(pIOStream,.tHeader,pTimeout)
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexBasic,"Semester","Demo.ComplexMap.SemesterFixed.Semester",$classname()),tStatus) Quit
		Set pBatch.Semester = tHeader
		Set tLookAhead = ""
		If (4 > $length(tLookAhead)) {
			Set tLookAhead = pIOStream.Read(4-$length(tLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tCount = 0
		While ($extract(tLookAhead,1,4) = "STU|") {
			Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.Student).GetObject(pIOStream,.tObject,pTimeout,.tLookAhead)
			Set tCount = tCount + 1
			If $$$ISERR(tStatus) Quit
			Set tStatus = pBatch.Students.SetAt(tObject,tCount)
			If $$$ISERR(tStatus) Quit
			Set tLookAhead = pIOStream.Read(4-$length(tLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexRepeating,"Students","Demo.ComplexMap.SemesterFixed.Student",$classname(),tCount),tStatus) Quit
		If (1 > tCount) {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrRepeatMin,1,"Students")
			Quit
		}
	} Catch {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

}
