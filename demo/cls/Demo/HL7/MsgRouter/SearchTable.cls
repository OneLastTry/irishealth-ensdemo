/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to identify messages of interest.
/// Extends EnsLib.HL7.SearchTable; adds more searchable properties to the ones defined in that class.
Class Demo.HL7.MsgRouter.SearchTable Extends EnsLib.HL7.SearchTable [ ClassType = persistent, LegacyInstanceContext, ProcedureBlock ]
{

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<!--
	Items that do not depend on DocType, indexing any HL7 message.
	The | character cannot be used in IDKEY indexes. So using a + in this example
	Any | in the data (i.e. not used as a possible HL7 separator) will be converted
	on filing to the Search Table as a +
	Original HL7 data remains unchanged.
-->
<Item DocType=""               PropName="SendingFacilApp"  >{1:4}_"+"_{1:3}</Item>
<Item DocType=""               PropName="RecvingFacilApp"  >{1:6}_"+"_{1:5 }</Item>
<Item DocType=""               PropName="MSHDateTime" PropType='DateTime:HL7' >{1:7}</Item>

<!-- Get fields from named segments found in any HL7 message -->
<Item DocType=""               PropName="InsuranceCo"      >[IN1:4()]</Item>

<!-- Get specific field from specific segment HL7 message assigned a specific DocType  -->
<Item DocType="Demo.HL7.MsgRouter.Schema:ORM_O01 "  PropName="ServiceId">{ORCgrp().OBRuniongrp.OBRunion.OBR:UniversalServiceID.text}</Item>
<Item DocType="2.3.1:ORU_R01 "                      PropName="ServiceId">{PIDgrpgrp().ORCgrp(1).OBR:UniversalServiceID.text}</Item>
</Items>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
