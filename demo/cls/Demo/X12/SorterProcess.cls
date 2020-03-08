Class Demo.X12.SorterProcess Extends Ens.BusinessProcessBPL [ ClassType = persistent ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.EDI.X12.Document' response='Ens.Response' height='2500' width='2500' >
<context>
<property name='Document' type='EnsLib.EDI.X12.Document' />
<property name='Payors' type='%ArrayOfObjects' />
<property name='CurrentPayor' type='%String' />
<property name='InterchangeId' type='%Integer' />
<property name='GroupId' type='%Integer' />
</context>
<sequence xend='550' yend='2330' >
<switch name='Document type' xpos='550' ypos='200' xend='550' yend='2230' >
<case condition='"Interchange"=request.Name' name='Interchange' >
<code name='Send payor Interchanges to their Operations' xpos='938' ypos='419' >
<annotation>The Interchange parent document arrives last; when it arrives we know to push out the parent Interchange documents we created</annotation>
<![CDATA[
	// construct a context array of objects from the global array of ids
	Set tPayor="" For { Set tPayor=$O(^CacheTemp.Sorter(request.%Id(),tPayor),1,tInterchangeId)  Quit:""=tPayor
		Do:""'=tInterchangeId context.Payors.SetAt(##class(EnsLib.EDI.X12.Document).%OpenId(tInterchangeId),tPayor)
	}
]]>
</code>
<foreach name='Send payor Interchanges to their Operations' property='context.Payors' key='context.CurrentPayor' xpos='938' ypos='519' xend='550' yend='300' >
<call name='Send Interchange' target='FileOperation1' async='1' xpos='550' ypos='200' >
<request type='EnsLib.EDI.X12.Document' >
<assign property='callrequest' value='context.Payors.GetAt(context.CurrentPayor)' action='set' />
</request>
</call>
</foreach>
</case>
<case condition='"Group"=request.Name' name='Group' >
<code name='Send payor Groups to their Operations' xpos='550' ypos='394' >
<annotation>The Group parent document arrives last; when it arrives we know to push out the parent Group documents we created</annotation>
<![CDATA[
	// construct a context array of objects from the global array of ids
	Set tPayor="" For { Set tPayor=$O(^CacheTemp.Sorter($P(request.ParentId,":"),tPayor))  Quit:""=tPayor
		Set tGroupId=$G(^CacheTemp.Sorter($P(request.ParentId,":"),tPayor,"%Group"))
		Do:""'=tGroupId context.Payors.SetAt(##class(EnsLib.EDI.X12.Document).%OpenId(tGroupId),tPayor)
	}
]]>
</code>
<foreach name='Send payor Groups to their Operations' property='context.Payors' key='context.CurrentPayor' xpos='550' ypos='494' xend='550' yend='300' >
<call name='Send Group' target='FileOperation1' async='1' xpos='550' ypos='200' >
<request type='EnsLib.EDI.X12.Document' >
<assign property='callrequest' value='context.Payors.GetAt(context.CurrentPayor)' action='set' />
</request>
</call>
</foreach>
</case>
<default name='TransactionSet' >
<assign name='Clone Request Doc' property='context.Document' value='request.%ConstructClone()' action='set' xpos='418' ypos='1470' />
<assign name='Get Payor' property='context.CurrentPayor' value='$ZConvert(request.{2000B(1).2010BB.NM1-34:3},"U")' action='set' xpos='148' ypos='370' >
<annotation>Send the TransactionSet to the right Payor batch</annotation>
</assign>
<assign name='Check Payor' property='context.CurrentPayor' value='$S(""=context.CurrentPayor:"Unknown",1:context.CurrentPayor)' action='set' xpos='148' ypos='470' />
<if name='Need New Interchange?' condition='""=$G(^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor))' xpos='148' ypos='570' xend='148' yend='1220' >
<true>
<assign name='Create new target Interchange' property='tNewInterchange' value='request.ParentInterchange.%ConstructClone()' action='set' xpos='418' ypos='1470' >
<annotation>Create a fresh parent Interchange for documents to this payor</annotation>
</assign>
<assign name='Set DocType' property='tNewInterchange.DocType' value='"ISC_00401:Interchange"' action='set' xpos='418' ypos='820' />
<assign name='Set IEA w/ Control Number' property='tNewInterchange.{IEA-4}' value='"IEA"_tNewInterchange.ElementSeparator_"0"_tNewInterchange.ElementSeparator_tNewInterchange.{ISA-1:InterchangeControlNumber}' action='set' xpos='418' ypos='820' />
<assign name='Set ISA receiver qualifier:' property='tNewInterchange.{ISA-1:InterchangeIDQualifier2}' value='"01"' action='set' xpos='418' ypos='820' />
<assign name='Set Payor Into ISA receiver:' property='tNewInterchange.{ISA-1:InterchangeReceiverID}' value='$$$PAD(context.CurrentPayor,15)' action='set' xpos='418' ypos='820' />
<assign name='Set Interchange Source' property='tNewInterchange.Source' value='context.CurrentPayor_$C(13)_$P(tNewInterchange.Source,$C(13),2,99)' action='set' xpos='418' ypos='1120' />
<assign name='Save Interchange' property='tStatus' value='tNewInterchange.%Save()' action='set' xpos='418' ypos='820' />
<assign name='Get Interchange Id' property='context.InterchangeId' value='tNewInterchange.%Id()' action='set' xpos='418' ypos='920' />
<assign name='Store Interchange Id' property='^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor)' value='context.InterchangeId' action='set' xpos='418' ypos='1020' />
</true>
<false>
<assign name='Get stored Interchange Id' property='context.InterchangeId' value='^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor)' action='set' xpos='148' ypos='720' />
</false>
</if>
<if name='Need New Group?' condition='""=$G(^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor,"%Group"))' xpos='148' ypos='1320' xend='148' yend='1970' >
<true>
<assign name='Create new target Group' property='tNewGroup' value='request.Parent.%ConstructClone()' action='set' xpos='418' ypos='1470' >
<annotation>Create a fresh parent group for documents of this type to this payor</annotation>
</assign>
<assign name='Set DocType' property='tNewGroup.DocType' value='"ISC_00401:Group"' action='set' xpos='418' ypos='820' />
<assign name='Set GE w/ Control Number' property='tNewGroup.{GE-3}' value='"GE"_tNewGroup.ElementSeparator_"0"_tNewGroup.ElementSeparator_tNewGroup.{GS-1:GroupControlNumber}' action='set' xpos='418' ypos='820' />
<assign name='Add Group to Interchange' property='tNewGroup.ParentId' value='context.InterchangeId_":2"' action='set' xpos='418' ypos='1570' />
<assign name='Save Group' property='tStatus' value='tNewGroup.%Save()' action='set' xpos='418' ypos='1670' />
<assign name='Get Group Id' property='context.GroupId' value='tNewGroup.%Id()' action='set' xpos='418' ypos='1770' />
<assign name='Store Group Id' property='^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor,"%Group")' value='context.GroupId' action='set' xpos='418' ypos='1870' />
</true>
<false>
<assign name='Get stored Group Id' property='context.GroupId' value='^CacheTemp.Sorter($P(request.TopParentId,":"),context.CurrentPayor,"%Group")' action='set' xpos='148' ypos='1470' />
</false>
</if>
<assign name='Add to Group' property='context.Document.ParentId' value='context.GroupId_":2"' action='set' xpos='148' ypos='2053' />
<call name='Send to Operation' target='FileOperation1' async='1' xpos='149' ypos='2148' >
<request type='EnsLib.EDI.X12.Document' >
<assign property='callrequest' value='context.Document' action='set' />
</request>
</call>
</default>
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
