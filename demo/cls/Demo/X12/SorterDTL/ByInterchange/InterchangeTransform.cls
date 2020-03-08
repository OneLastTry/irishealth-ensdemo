Class Demo.X12.SorterDTL.ByInterchange.InterchangeTransform Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.X12.Document ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.X12.Document' targetClass='EnsLib.EDI.X12.Document' sourceDocType='HIPAA_5010:Interchange' targetDocType='HIPAA_5010:Interchange' create='existing' language='objectscript' >
<annotation>Copy the existing Interchange, but transform one value within it</annotation>
<assign value='$E($ZDATE($HOROLOG,8),3,*)' property='target.{ISA:InterchangeDate}' action='set' >
<annotation>Transform a value in the Interchange</annotation>
</assign>
</transform>
}

}
