Class Demo.X12.SorterDTL.ByInterchange.SorterTransform Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.X12.Document, %ArrayOfObjects) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.X12.Document' targetClass='%ArrayOfObjects' sourceDocType='HIPAA_5010:Interchange' create='new' language='objectscript' >
<annotation>This sorts the Transaction Sets within an X12 Interchange into Groups and sorts those Groups into new Interchanges.  It also performs a few transforms on the Interchanges, Groups, and Transaction Sets which make use of the ability to easily access values from the Interchange, Group, and Transaction Set all in one place.</annotation>
<assign value='##class(%Library.ArrayOfObjects).%New()' property='ArrayOfGroups' action='set' >
<annotation>Create the array of Groups</annotation>
</assign>
<foreach property='source.{GroupDocsRef}' key='Group' >
<annotation>Loop over Groups in the Interchange</annotation>
<foreach property='Group.{TransactionSetDocsRef}' key='TSIn' >
<annotation>Loop over Transaction Sets in the Group</annotation>
<subtransform class='Demo.X12.SorterDTL.TSTransform' targetObj='TSOut' sourceObj='TSIn' >
<annotation>Transform the Transaction Set</annotation>
</subtransform>
<assign value='TSOut.{BPR:TransactionHandlingCode}' property='key1' action='set' >
<annotation>This key is used in sorting Transaction Sets into Groups.</annotation>
</assign>
<assign value='$Case(key1,"C":"C","H":"HP","P":"HP","I":"HP",:"UX")' property='key2' action='set' >
<annotation>This key is used in sorting Groups into Interchanges.</annotation>
</assign>
<assign value='##class(Demo.X12.SorterDTL.HelperMethods).FindParents(TSOut,Group,ArrayOfGroups,target,key1,key2)' property='tSC' action='set' >
<annotation>Note that target is the array of interchanges</annotation>
</assign>
<assign value='target.GetAt(key2)' property='InterOut' action='set'  />
<subtransform class='Demo.X12.SorterDTL.ByInterchange.InterchangeTransform' targetObj='InterOut' sourceObj='InterOut' >
<annotation>Transform the Interchange</annotation>
</subtransform>
<assign value='TSOut.{BPR:AccountNumber}' property='InterOut.{ISA:AuthorizationInformation}' action='set' >
<annotation>Use a Transaction Set value to transform a value in the Interchange</annotation>
</assign>
<assign value='source.{ISA:InterchangeReceiverID}_"_"_key2' property='InterOut.{ISA:InterchangeReceiverID}' action='set' >
<annotation>Transform a value in the Interchange</annotation>
</assign>
<assign value='##class(Demo.X12.SorterDTL.HelperMethods).SaveChanges(InterOut)' property='tSC' action='set'  />
<assign value='ArrayOfGroups.GetAt(key1)' property='GroupOut' action='set'  />
<subtransform class='Demo.X12.SorterDTL.GroupTransform' targetObj='GroupOut' sourceObj='GroupOut' >
<annotation>Transform the Group</annotation>
</subtransform>
<assign value='InterOut.{ISA:InterchangeReceiverID}_"-"_TSOut.{BPR:TransactionHandlingCode}' property='GroupOut.{GS:ApplicationReceiversCode}' action='set' >
<annotation>Use values from the Interchange and the Transaction Set to transform a value in the Group</annotation>
</assign>
<assign value='##class(Demo.X12.SorterDTL.HelperMethods).SaveChanges(GroupOut)' property='tSC' action='set'  />
</foreach>
</foreach>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
