Class Demo.ComplexMap.Transform.CreateClassBatch Extends Ens.DataTransformDTL [ DependsOn = (Demo.ComplexMap.Semester.Batch, Demo.ComplexMap.SemesterFixed.ClassBatch) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.ComplexMap.Semester.Batch' targetClass='Demo.ComplexMap.SemesterFixed.ClassBatch' create='new' language='objectscript' >
<subtransform class='Demo.ComplexMap.Transform.SemesterToFixedSemester' targetObj='target.Semester' sourceObj='source.Semester' >
<annotation>This simple transform is executed as a subtransform as we need to perform the same action in Demo.ComplexMap.Transform.CreateStudentBatch.</annotation>
</subtransform>
<foreach property='source.Students()' key='k1' >
<foreach property='source.Students.(k1).ClassInfo()' key='k2' >
<if condition='&apos;$data(classMap(source.Students.GetValueAt(k1).ClassInfo.GetValueAt(k2).ClassID,source.Students.GetValueAt(k1).ClassInfo.GetValueAt(k2).SectionID))' >
<true>
<assign value='source.Students.(k1).ClassInfo.(k2).ClassID' property='target.Classes.(k2).ClassID' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).SectionID' property='target.Classes.(k2).SectionID' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).Title' property='target.Classes.(k2).Title' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).Grade' property='target.Classes.(k2).Grade' action='set' />
<assign value='1' property='classMap(source.Students.GetValueAt(k1).ClassInfo.GetValueAt(k2).ClassID,source.Students.GetValueAt(k1).ClassInfo.GetValueAt(k2).SectionID)' action='set' />
</true>
</if>
</foreach>
<code>
<![CDATA[ Set tSC = source.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit
 Set tSC = target.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit]]></code>
</foreach>
</transform>
}

}
