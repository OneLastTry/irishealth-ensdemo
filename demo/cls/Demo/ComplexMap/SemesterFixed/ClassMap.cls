Class Demo.ComplexMap.SemesterFixed.ClassMap Extends EnsLib.RecordMap.ComplexMap
{

Parameter RECORDMAPGENERATED = 1;

XData ComplexBatch [ XMLNamespace = "http://www.intersystems.com/Ensemble/RecordMap" ]
{
<ComplexBatch xmlns="http://www.intersystems.com/Ensemble/RecordMap" name="Demo.ComplexMap.SemesterFixed.ClassMap" char_encoding="UTF-8" targetClassname="Demo.ComplexMap.SemesterFixed.ClassBatch">
  <Header name="Semester" recordMap="Demo.ComplexMap.SemesterFixed.Semester"></Header>
  <RecordReference name="Classes" required="0" repeating="1" minRepeats="1" recordMap="Demo.ComplexMap.SemesterFixed.ClassInfo"></RecordReference>
</ComplexBatch>
}

Parameter BATCHCLASS = "Demo.ComplexMap.SemesterFixed.ClassBatch";

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
		For i=1:1:pBatch.Classes.Count() {
			Set tElement = pBatch.Classes.GetAt(i)
			If $IsObject(tElement) {
				Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo).PutObject(pIOStream,tElement,0)
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
		Set pBatch = ##class(Demo.ComplexMap.SemesterFixed.ClassBatch).%New()
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
		While ($extract(tLookAhead,1,4) = "CLS|") {
			Set tStatus = ##class(Demo.ComplexMap.SemesterFixed.ClassInfo).GetObject(pIOStream,.tObject,pTimeout,.tLookAhead)
			Set tCount = tCount + 1
			If $$$ISERR(tStatus) Quit
			Set tStatus = pBatch.Classes.SetAt(tObject,tCount)
			If $$$ISERR(tStatus) Quit
			Set tLookAhead = pIOStream.Read(4-$length(tLookAhead),pTimeout,.tStatus)
			If $$$ISERR(tStatus) Quit
		}
		If $$$ISERR(tStatus) Set tStatus = $system.Status.AppendStatus($$$ERROR($$$EnsRecordMapErrComplexRepeating,"Classes","Demo.ComplexMap.SemesterFixed.ClassInfo",$classname(),tCount),tStatus) Quit
		If (1 > tCount) {
			Set tStatus = $$$ERROR($$$EnsRecordMapErrRepeatMin,1,"Classes")
			Quit
		}
	} Catch {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

}
