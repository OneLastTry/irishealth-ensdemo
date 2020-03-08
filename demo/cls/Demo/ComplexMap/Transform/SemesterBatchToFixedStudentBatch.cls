Class Demo.ComplexMap.Transform.SemesterBatchToFixedStudentBatch Extends Ens.DataTransformDTL [ DependsOn = (Demo.ComplexMap.Semester.Batch, Demo.ComplexMap.SemesterFixed.StudentBatch) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.ComplexMap.Semester.Batch' targetClass='Demo.ComplexMap.SemesterFixed.StudentBatch' create='new' language='objectscript' >
<assign value='source.%Source' property='target.%Source' action='set' />
<subtransform class='Demo.ComplexMap.Transform.SemesterToFixedSemester' targetObj='target.Semester' sourceObj='source.Semester' />
<assign value='source.Students.Count()' property='target.Semester.RecordCount' action='set' />
<foreach property='source.Students()' key='k1' >
<assign value='source.Students.(k1).Student.StudentID' property='target.Students.(k1).StudentID' action='set' />
<assign value='source.Students.(k1).Student.LastName' property='target.Students.(k1).LastName' action='set' />
<assign value='source.Students.(k1).Student.FirstName' property='target.Students.(k1).FirstName' action='set' />
<assign value='source.Students.(k1).Student.MiddleName' property='target.Students.(k1).MiddleName' action='set' />
<assign value='source.Students.(k1).Student.Grade' property='target.Students.(k1).Grade' action='set' />
<assign value='source.Students.(k1).Student.Email' property='target.Students.(k1).Email' action='set' />
<assign value='source.Students.(k1).Student.Phone' property='target.Students.(k1).Phone' action='set' />
<code>
<![CDATA[ Set tSC = source.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit
 Set tSC = target.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit]]></code>
</foreach>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
