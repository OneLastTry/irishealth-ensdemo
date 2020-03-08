Class Demo.ComplexMap.Transform.SemesterToFixedSemester Extends Ens.DataTransformDTL [ DependsOn = (Demo.ComplexMap.Semester.SemesterHeader.Record, Demo.ComplexMap.SemesterFixed.Semester.Record) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.ComplexMap.Semester.SemesterHeader.Record' targetClass='Demo.ComplexMap.SemesterFixed.Semester.Record' create='new' language='objectscript' >
<assign value='source.%Source' property='target.%Source' action='set' />
<assign value='source.SemesterID' property='target.SemesterID' action='set' />
<assign value='source.Year' property='target.Year' action='set' />
<assign value='source.Name' property='target.Name' action='set' />
<assign value='source.NumWeeks' property='target.NumWeeks' action='set' />
</transform>
}

}
