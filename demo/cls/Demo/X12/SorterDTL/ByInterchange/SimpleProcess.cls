/// This process calls for the sorting transform and then sends each resulting Interchange to the file operation.
Class Demo.X12.SorterDTL.ByInterchange.SimpleProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.EDI.X12.Document' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='ArrayOfGroups' type='EnsLib.EDI.X12.Document' collection='array' instantiate='0' >
</property>
<property name='key' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='ArrayOfInterchanges' type='EnsLib.EDI.X12.Document' collection='array' instantiate='0' >
</property>
</context>
<sequence xend='200' yend='450' >
<transform name='Split Transform' class='Demo.X12.SorterDTL.ByInterchange.SorterTransform' source='request' target='context.ArrayOfInterchanges' xpos='200' ypos='250' >
<annotation><![CDATA[The transform does the sorting.]]></annotation>
</transform>
<foreach name='Interchange Loop' property='context.ArrayOfInterchanges' key='context.key' xpos='200' ypos='350' xend='200' yend='350' >
<annotation><![CDATA[Loop over the resulting Interchanges and send each to the file operation.]]></annotation>
<call name='Output Interchange' target='ByInterchangeFileOperation' async='1' xpos='200' ypos='250' >
<request type='EnsLib.EDI.X12.Document' >
<assign property="callrequest" value="context.ArrayOfInterchanges.GetAt(context.key)" action="set" />
</request>
</call>
</foreach>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
