/// Business Process that constructs a Demo.ComplexMap.SemesterFixed.StudentBatch based on an incoming Demo.ComplexMap.Semester.Batch, and sends it on to a file output operation.
Class Demo.ComplexMap.SemesterFixed.StudentBatchProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.ComplexMap.Semester.Batch' response='Ens.Response' height='2250' width='2000' >
<context>
<property name='StudentBatch' type='Demo.ComplexMap.SemesterFixed.StudentBatch' instantiate='1' >
</property>
<property name='SourceStudent' type='Demo.ComplexMap.Semester.Student.Record' instantiate='0' >
</property>
<property name='TargetStudent' type='Demo.ComplexMap.SemesterFixed.Student.Record' instantiate='0' >
</property>
<property name='Key' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='TempStudents' type='Demo.ComplexMap.Semester.Students' instantiate='0' >
</property>
</context>
<sequence xend='200' yend='750' >
<assign name="Copy %Source" property="context.StudentBatch.%Source" value="request.%Source" action="set" xpos='200' ypos='250' />
<transform name='Transform Semester Header' class='Demo.ComplexMap.Transform.SemesterToFixedSemester' source='request.Semester' target='context.StudentBatch.Semester' xpos='200' ypos='350' />
<assign name="Set RecordCount" property="context.StudentBatch.Semester.RecordCount" value="request.Students.Count()" action="set" xpos='200' ypos='450' />
<foreach name='For each Student' property='request.Students' key='context.Key' xpos='200' ypos='550' xend='200' yend='2000' >
<assign name="Get Students from request" property="context.TempStudents" value="request.Students.GetAt(context.Key)" action="set" xpos='200' ypos='250' />
<if name='TempStudents' condition='$IsObject(context.TempStudents)' xpos='200' ypos='350' xend='200' yend='1900' >
<true>
<assign name="Get actual Student" property="context.SourceStudent" value="context.TempStudents.Student" action="set" xpos='335' ypos='500' />
<assign name="Create TargetStudent" property="context.TargetStudent" value="##class(Demo.ComplexMap.SemesterFixed.Student.Record).%New()" action="set" xpos='335' ypos='600' />
<assign name="Set StudentID" property="context.TargetStudent.StudentID" value="context.SourceStudent.StudentID" action="set" xpos='335' ypos='700' />
<assign name="Set LastName" property="context.TargetStudent.LastName" value="context.SourceStudent.LastName" action="set" xpos='335' ypos='800' />
<assign name="Set FirstName" property="context.TargetStudent.FirstName" value="context.SourceStudent.FirstName" action="set" xpos='335' ypos='900' />
<assign name="Set MiddleName" property="context.TargetStudent.MiddleName" value="context.SourceStudent.MiddleName" action="set" xpos='335' ypos='1000' />
<assign name="Set Grade" property="context.TargetStudent.Grade" value="context.SourceStudent.Grade" action="set" xpos='335' ypos='1100' />
<assign name="Set Email" property="context.TargetStudent.Email" value="context.SourceStudent.Email" action="set" xpos='335' ypos='1200' />
<assign name="Set Phone" property="context.TargetStudent.Phone" value="context.SourceStudent.Phone" action="set" xpos='335' ypos='1300' />
<assign name="Add TargetStudent to batch" property="context.StudentBatch.Students" value="context.TargetStudent" action="set" key="context.Key" xpos='335' ypos='1400' />
<assign name="Reset TargetStudent" property="context.TargetStudent" value="&quot;&quot;" action="set" xpos='335' ypos='1500' />
<assign name="Reset SourceStudent" property="context.SourceStudent" value="&quot;&quot;" action="set" xpos='335' ypos='1600' />
<assign name="Reset TempStudents" property="context.TempStudents" value="&quot;&quot;" action="set" xpos='335' ypos='1700' />
<assign name="UnSwizzle source student" property="status" value="request.Students.%UnSwizzleAt(context.Key)" action="set" xpos='335' ypos='1800' />
</true>
</if>
</foreach>
<call name='Send StudentBatch' target='@process.BatchOperation' async='0' xpos='200' ypos='650' >
<request type='Demo.ComplexMap.SemesterFixed.StudentBatch' >
<assign property="callrequest" value="context.StudentBatch" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Parameter SETTINGS = "BatchOperation:Basic";

Property BatchOperation As Ens.DataType.ConfigName;

Storage Default
{
<Data name="StudentBatchProcessDefaultData">
<Subscript>"StudentBatchProcess"</Subscript>
<Value name="1">
<Value>BatchOperation</Value>
</Value>
</Data>
<DefaultData>StudentBatchProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
