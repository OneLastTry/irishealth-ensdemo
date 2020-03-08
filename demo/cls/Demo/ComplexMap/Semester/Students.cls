/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.Semester.SemesterData'
/// on 2013-01-14 at 13:28:31.441 [2013-01-14 18:28:31.441 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Semester.Students Extends (EnsLib.RecordMap.ComplexSequence, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Student As Demo.ComplexMap.Semester.Student.Record [ Required ];

Property ClassInfo As array Of Demo.ComplexMap.Semester.ClassInfo.Record [ Required ];

Method PutSequence(pIOStream As %IO.DeviceStream) As %Status
{
	Set tStatus = $$$OK
	Try {
		If $IsObject(..Student) {
			Set tStatus = ##class(Demo.ComplexMap.Semester.Student).PutObject(pIOStream,..Student,0)
			If $$$ISERR(tStatus) Quit
		}
		For i=1:1:..ClassInfo.Count() {
			Set tElement = ..ClassInfo.GetAt(i)
			If $IsObject(tElement) {
				Set tStatus = ##class(Demo.ComplexMap.Semester.ClassInfo).PutObject(pIOStream,tElement,0)
				If $$$ISERR(tStatus) Quit
			}
			Set tStatus = ..ClassInfo.%UnSwizzleAt(i)
			If $$$ISERR(tStatus) Quit
		}
		If $$$ISERR(tStatus) Quit
	}
	Catch {
		Set tStatus = $$$SystemError
	}
	Quit tStatus
}

Trigger OnDeleteTrigger [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.Semester.Students).%OnDelete($$$oidForm({ID}))
}

Storage Default
{
<Data name="ClassInfo">
<Attribute>ClassInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"ClassInfo"</Subscript>
</Data>
<Data name="StudentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Student</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.SD05B.StudentsD</DataLocation>
<DefaultData>StudentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.ComplexMap.SD05B.StudentsD</IdLocation>
<IndexLocation>^Demo.ComplexMap.SD05B.StudentsI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.SD05B.StudentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
