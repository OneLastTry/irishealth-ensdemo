/// RECORDMAP: Modified during compilation of Complex RecordMap 'Demo.ComplexMap.Summary.SemesterSummary'
/// on 2012-12-05 at 17:47:28.550 [2012-12-05 22:47:28.550 UTC]
/// by user DemoUser
Class Demo.ComplexMap.Summary.Students Extends (EnsLib.RecordMap.ComplexSequence, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

Parameter RECORDMAPGENERATED = 1;

Property Student As Demo.ComplexMap.Summary.Student.Record [ Required ];

Property ClassInfo As array Of Demo.ComplexMap.Semester.ClassInfo.Record [ Required ];

Method PutSequence(pIOStream As %IO.DeviceStream) As %Status
{
	Set tStatus = $$$OK
	Try {
		If $IsObject(..Student) {
			Set tStatus = ##class(Demo.ComplexMap.Summary.Student).PutObject(pIOStream,..Student,0)
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
	Set %ok = ##class(Demo.ComplexMap.Summary.Students).%OnDelete($$$oidForm({ID}))
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
<DataLocation>^Demo.ComplexMap.S46EE.StudentsD</DataLocation>
<DefaultData>StudentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Demo.ComplexMap.S46EE.StudentsD</IdLocation>
<IndexLocation>^Demo.ComplexMap.S46EE.StudentsI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.S46EE.StudentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
