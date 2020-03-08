Class Demo.ComplexMap.Transform.SemesterBatchToSemesterSummaryBatch Extends Ens.DataTransformDTL [ DependsOn = (Demo.ComplexMap.Semester.Batch, Demo.ComplexMap.Summary.SummaryBatch) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.ComplexMap.Semester.Batch' targetClass='Demo.ComplexMap.Summary.SummaryBatch' create='new' language='objectscript' >
<assign value='source.%Source' property='target.%Source' action='set' />
<assign value='source.Semester.SemesterID' property='target.Semester.SemesterID' action='set' />
<assign value='source.Semester.Year' property='target.Semester.Year' action='set' />
<assign value='source.Semester.Name' property='target.Semester.Name' action='set' />
<assign value='source.Semester.NumWeeks' property='target.Semester.NumWeeks' action='set' />
<assign value='0' property='totalClasses' action='set' >
<annotation>Counter for the total number of classes in the semester.</annotation>
</assign>
<assign value='0' property='totalStudents' action='set' />
<assign value='0' property='totalGPA' action='set' >
<annotation>Local variable to store the sum of the GPAs we see.</annotation>
</assign>
<foreach property='source.Students()' key='k1' >
<assign value='totalStudents + 1' property='totalStudents' action='set' />
<assign value='0' property='studentClasses' action='set' />
<assign value='0' property='studentGPA' action='set' />
<assign value='source.Students.(k1).Student.StudentID' property='target.Students.(k1).Student.StudentID' action='set' />
<assign value='source.Students.(k1).Student.LastName' property='target.Students.(k1).Student.Name.Family' action='set' />
<assign value='source.Students.(k1).Student.FirstName' property='target.Students.(k1).Student.Name.Given' action='set' />
<assign value='source.Students.(k1).Student.MiddleName' property='target.Students.(k1).Student.Name.Middle' action='set' />
<assign value='source.Students.(k1).Student.Grade' property='target.Students.(k1).Student.Grade' action='set' />
<assign value='source.Students.(k1).Student.Email' property='target.Students.(k1).Student.Email' action='set' />
<assign value='source.Students.(k1).Student.Phone' property='target.Students.(k1).Student.Phone' action='set' />
<foreach property='source.Students.(k1).ClassInfo()' key='k2' >
<assign value='source.Students.(k1).ClassInfo.(k2)' property='target.Students.(k1).ClassInfo.(k2)' action='set' />
<assign value='studentClasses + 1' property='studentClasses' action='set' />
<assign value='studentGPA + source.Students.(k1).ClassInfo.(k2).Grade' property='studentGPA' action='set' />
</foreach>
<assign value='studentClasses' property='target.Students.(k1).Student.NumberClasses' action='set' />
<assign value='..Round(studentGPA / studentClasses,1)' property='target.Students.(k1).Student.GPA' action='set' />
<assign value='totalClasses + studentClasses' property='totalClasses' action='set' />
<assign value='totalGPA + studentGPA' property='totalGPA' action='set' />
<code>
<annotation>Ensure that we don&#39;t keep unnecessary object references in memory</annotation>
<![CDATA[ Set tSC = source.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit]]></code>
</foreach>
<assign value='totalStudents' property='target.Semester.NumberStudents' action='set' />
<assign value='..Round(totalGPA / totalClasses,1)' property='target.Semester.AverageGPA' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
