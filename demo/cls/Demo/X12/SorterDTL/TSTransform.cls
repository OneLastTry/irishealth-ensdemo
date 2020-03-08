Class Demo.X12.SorterDTL.TSTransform Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.X12.Document ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.X12.Document' targetClass='EnsLib.EDI.X12.Document' sourceDocType='HIPAA_5010:835' targetDocType='HIPAA_5010:835' create='new' language='objectscript' >
<annotation>Transform the Transaction Set, making use of values from the Group and Interchange.</annotation>
<assign value='source.{ST}' property='target.{ST}' action='set'  />
<assign value='source.{BPR}' property='target.{BPR}' action='set'  />
<assign value='source.{TRN}' property='target.{TRN}' action='set'  />
<assign value='source.{CUR}' property='target.{CUR}' action='set'  />
<assign value='source.{REF()}' property='target.{REF()}' action='set'  />
<assign value='source.{DTM}' property='target.{DTM}' action='set'  />
<assign value='source.{loop1000A}' property='target.{loop1000A}' action='set'  />
<assign value='source.{loop1000B}' property='target.{loop1000B}' action='set'  />
<assign value='source.{loop2000()}' property='target.{loop2000()}' action='set'  />
<assign value='source.{PLB()}' property='target.{PLB()}' action='set'  />
<assign value='source.{SE}' property='target.{SE}' action='set'  />
<assign value='$zdate($horolog,8)' property='target.{DTM:Date}' action='set' >
<annotation>Transform a value in the Transaction Set</annotation>
</assign>
<assign value='source.Parent.Parent.{ISA:InterchangeSenderID}' property='target.{BPR:OriginatingCompanyIdentifier}' action='set' >
<annotation>Use a value from the Interchange to determine a value in the Transaction Set</annotation>
</assign>
<assign value='source.Parent.{GS:ApplicationSendersCode}' property='target.{BPR:OriginatingCompanySupplement}' action='set' >
<annotation>Use a value in the Group to determine a value in the Transaction Set</annotation>
</assign>
</transform>
}

}
