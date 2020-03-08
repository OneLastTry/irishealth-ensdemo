Class Demo.X12.SorterDTL.ByGroup.SorterTransform Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.X12.Document ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.X12.Document' targetClass='EnsLib.EDI.X12.Document' sourceDocType='HIPAA_5010:Interchange' targetDocType='HIPAA_5010:Interchange' create='copy' language='objectscript' >
<annotation>This sorts the Transaction Sets from an Interchange into Groups.  It also performs a few transforms on the Interchanges, Groups, and Transaction Sets which make use of the ability to easily access values from the Interchange, Group, and Transaction Set all in one place.</annotation>
<assign value='0' property='target.{GroupDocsRef:ChildCount}' action='set' >
<annotation>Initiate the child count in the Interchange to zero</annotation>
</assign>
<assign value='0' property='target.{IEA:NumberofIncludedFunctionalGr}' action='set' >
<annotation>Initiate the child count in the Interchange to zero</annotation>
</assign>
<assign value='$E($ZDATE($HOROLOG,8),3,*)' property='target.{ISA:InterchangeDate}' action='set' >
<annotation>Transform a value in the Interchange</annotation>
</assign>
<assign value='##class(%Library.ArrayOfObjects).%New()' property='ArrayOfGroups' action='set' >
<annotation>Create the array of Groups</annotation>
</assign>
<foreach property='source.{GroupDocsRef}' key='GroupIn' >
<annotation>Loop over the Groups in the Interchange</annotation>
<foreach property='GroupIn.{TransactionSetDocsRef}' key='TSIn' >
<annotation>Loop over the Transaction Sets in the Group</annotation>
<subtransform class='Demo.X12.SorterDTL.TSTransform' targetObj='TSOut' sourceObj='TSIn' >
<annotation>Transform the Transaction Set</annotation>
</subtransform>
<assign value='TSOut.{BPR:TransactionHandlingCode}' property='key' action='set' >
<annotation>This key is used in sorting the Transaction Sets into Groups</annotation>
</assign>
<assign value='##class(Demo.X12.SorterDTL.HelperMethods).FindParents(TSOut,GroupIn,ArrayOfGroups,,key)' property='tSC' action='set'  />
<assign value='TSOut.{BPR:AccountNumber}' property='target.{ISA:AuthorizationInformation}' action='set' >
<annotation>Use a value from the Transaction Set to determine a value in the Interchange</annotation>
</assign>
<assign value='ArrayOfGroups.GetAt(key)' property='GroupOut' action='set'  />
<assign value='target.{ISA:InterchangeReceiverId}_"_"_TSOut.{BPR:TransactionHandlingCode}' property='GroupOut.{GS:ApplicationReceiversCode}' action='set' >
<annotation>Use values from the Interchange and the Transaction Set to determine a value in the Group</annotation>
</assign>
</foreach>
</foreach>
<foreach property='ArrayOfGroups' key='tKey' >
<assign value='ArrayOfGroups.GetAt(tKey)' property='tGroupOut' action='set'  />
<subtransform class='Demo.X12.SorterDTL.GroupTransform' targetObj='tGroupOut' sourceObj='tGroupOut' >
<annotation>Transform the Group</annotation>
</subtransform>
<assign value='##class(Demo.X12.SorterDTL.HelperMethods).AddChildToDocsRef(tGroupOut,target,"GroupDocsRef")' property='tSC' action='set'  />
</foreach>
</transform>
}

}
