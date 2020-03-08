/// Complex RecordMap to represent all the students and the classes they are enrolled in for a given semester.
Class Demo.ComplexMap.Semester.SemesterData Extends EnsLib.RecordMap.ComplexMap
{

XData ComplexBatch [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<ComplexBatch xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.Semester.SemesterData" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.Semester.Batch">
  <Header name="Semester" recordMap="Demo.ComplexMap.Semester.SemesterHeader"></Header>
  <RecordSequence name="Students" required="1" repeating="1" minRepeats="1">
    <RecordReference name="Student" required="1" repeating="0" recordMap="Demo.ComplexMap.Semester.Student"></RecordReference>
    <RecordReference name="ClassInfo" required="1" repeating="1" minRepeats="1" recordMap="Demo.ComplexMap.Semester.ClassInfo"></RecordReference>
  </RecordSequence>
</ComplexBatch>
}

Parameter RECORDMAPGENERATED = 1;

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
		Set tStatus = ##class(Demo.ComplexMap.Semester.SemesterHeader).PutObject(pIOStream,pBatch.Semester,0)
		If $$$ISERR(tStatus) Quit
		For i=1:1:pBatch.Students.Count() {
			Set tElement = pBatch.Students.GetAt(i)
			If $IsObject(tElement) {
				Set tStatus = tElement.PutSequence(pIOStream)
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
		Set pBatch = ##class(Demo.ComplexMap.Semester.Batch).%New()
		Set pBatch.%Source = pIOStream.Name
		Set tStatus = ##class(Demo.ComplexMap.Semester.SemesterHeader).GetObject(pIOStream,.tHeader,pTimeout)
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexBasic,"Semester","Demo.ComplexMap.Semester.SemesterHeader",$classname()),tStatus) Quit
		Set pBatch.Semester = tHeader
		Set tLookAhead = ""
		If (4 > $length(tLookAhead)) {
			Set tLookAhead = tLookAhead _ pIOStream.Read(4-$length(tLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexBasic,"Students","Demo.ComplexMap.Semester.Students",$classname()),tStatus) Quit
		}
		Set tCount = 0
		While ($extract(tLookAhead,1,4)="STU|") {
			Set tStatus = ..getSeqStudents(pIOStream,.tSequence,.tLookAhead,pBatch,pTimeout)
			Set tCount = tCount + 1
			If $$$ISERR(tStatus) Quit
			Set tStatus = pBatch.Students.SetAt(tSequence,tCount)
			If $$$ISERR(tStatus) Quit
			If (4 > $length(tLookAhead)) {
				Set tLookAhead = tLookAhead _ pIOStream.Read(4-$length(tLookAhead),pTimeout,.tStatus)
				If $$$ISERR(tStatus) Quit
			}
		}
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexRepeating,"Students","Demo.ComplexMap.Semester.Students",$classname(),tCount),tStatus) Quit
		If (1 > tCount) {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrRepeatMin,1,"Students")
			Quit
		}
	} Catch {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

Parameter BATCHCLASS = "Demo.ComplexMap.Semester.Batch";

ClassMethod getSeqStudents(pIOStream As %IO.DeviceStream, Output pSequence As EnsLib.RecordMap.ComplexSequence, ByRef pLookAhead As %String = "", pBatch As EnsLib.RecordMap.ComplexBatch, pTimeout As %Numeric = -1) As %Status [ Private ]
{
	Set tStatus = $$$OK
	Try {
		Set pSequence = ##class(Demo.ComplexMap.Semester.Students).%New()
		Set tStatus = ##class(Demo.ComplexMap.Semester.Student).GetObject(pIOStream,.tObject,pTimeout,.pLookAhead)
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexBasic,"Student","Demo.ComplexMap.Semester.Student",$classname()),tStatus) Quit
		Set pSequence.Student = tObject
		If (4 > $length(pLookAhead)) {
			Set pLookAhead = pIOStream.Read(4-$length(pLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		Set tCount = 0
		While ($extract(pLookAhead,1,4) = "CLS|") {
			Set tStatus = ##class(Demo.ComplexMap.Semester.ClassInfo).GetObject(pIOStream,.tObject,pTimeout,.pLookAhead)
			Set tCount = tCount + 1
			If $$$ISERR(tStatus) Quit
			Set tStatus = pSequence.ClassInfo.SetAt(tObject,tCount)
			If $$$ISERR(tStatus) Quit
			Set pLookAhead = pIOStream.Read(4-$length(pLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexRepeating,"ClassInfo","Demo.ComplexMap.Semester.ClassInfo",$classname(),tCount),tStatus) Quit
		If (1 > tCount) {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrRepeatMin,1,"ClassInfo")
			Quit
		}
	}
	Catch {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

}
