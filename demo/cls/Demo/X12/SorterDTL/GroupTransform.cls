Class Demo.X12.SorterDTL.GroupTransform Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.X12.Document ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.X12.Document' targetClass='EnsLib.EDI.X12.Document' sourceDocType='HIPAA_5010:Group' targetDocType='HIPAA_5010:Group' create='existing' language='objectscript' >
<annotation>Copy the existing Group, but transform one value within it</annotation>
<assign value='$ZDATE($HOROLOG,8)' property='target.{GS:Date}' action='set' >
<annotation>Transform a value in the Group</annotation>
</assign>
</transform>
}

}
