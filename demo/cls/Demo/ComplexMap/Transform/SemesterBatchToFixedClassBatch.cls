Class Demo.ComplexMap.Transform.SemesterBatchToFixedClassBatch Extends Ens.DataTransformDTL [ DependsOn = (Demo.ComplexMap.Semester.Batch, Demo.ComplexMap.SemesterFixed.ClassBatch) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.ComplexMap.Semester.Batch' targetClass='Demo.ComplexMap.SemesterFixed.ClassBatch' create='new' language='objectscript' >
<subtransform class='Demo.ComplexMap.Transform.SemesterToFixedSemester' targetObj='target.Semester' sourceObj='source.Semester' >
<annotation>This simple transform is executed as a subtransform as we need to perform the same action in Demo.ComplexMap.Transform.CreateStudentBatch.</annotation>
</subtransform>
<assign value='0' property='Count' action='set' />
<foreach property='source.Students()' key='k1' >
<foreach property='source.Students.(k1).ClassInfo()' key='k2' >
<if condition='&apos;$data(classMap(source.Students.GetAt(k1).ClassInfo.GetAt(k2).ClassID,source.Students.GetAt(k1).ClassInfo.GetAt(k2).SectionID))' >
<true>
<assign value='Count + 1' property='Count' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).ClassID' property='target.Classes.(Count).ClassID' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).SectionID' property='target.Classes.(Count).SectionID' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).Title' property='target.Classes.(Count).Title' action='set' />
<assign value='source.Students.(k1).ClassInfo.(k2).Grade' property='target.Classes.(Count).Grade' action='set' />
<assign value='1' property='target.Classes.(Count).StudentCount' action='set' />
<assign value='Count' property='classMap(source.Students.GetAt(k1).ClassInfo.GetAt(k2).ClassID,source.Students.GetAt(k1).ClassInfo.GetAt(k2).SectionID)' action='set' />
</true>
<false>
<assign value='classMap(source.Students.GetAt(k1).ClassInfo.GetAt(k2).ClassID,source.Students.GetAt(k1).ClassInfo.GetAt(k2).SectionID)' property='index' action='set' />
<assign value='target.Classes.(index).StudentCount + 1' property='target.Classes.(index).StudentCount' action='set' />
<assign value='target.Classes.(index).Grade + source.Students.(k1).ClassInfo.(k2).Grade' property='target.Classes.(index).Grade' action='set' />
</false>
</if>
</foreach>
<code>
<![CDATA[ Set tSC = source.Students.%UnSwizzleAt(k1)
 If $$$ISERR(tSC) Quit]]></code>
</foreach>
<foreach property='target.Classes()' key='k3' >
<assign value='..Round(target.Classes.(k3).Grade / target.Classes.(k3).StudentCount,1)' property='target.Classes.(k3).Grade' action='set' >
<annotation>Compute average grade for each class.</annotation>
</assign>
</foreach>
</transform>
}

}
