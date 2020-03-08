/// 
Class Demo.HL7.MsgRouter.ABCRoutingRule Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssistCompatible";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<when condition="((HL7.ParentId)!=(&quot;&quot;))">
<send transform="" target="Batch_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="2.3.1"></constraint>
<when condition="((HL7.ParentId)!=(&quot;&quot;))">
<send transform="" target="Batch_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="2.3.1"></constraint>
<constraint name="docType" value="FHS,BHS"></constraint>
<when condition="1">
<send transform="" target="Batch_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ADT_A08"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ADT_A01"></constraint>
<when condition="1">
<send transform="" target="Priority_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ADT_A08"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ADT_A01"></constraint>
<when condition="1">
<send transform="" target="ADT_A08_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ORM_O01"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ORM_O01"></constraint>
<when condition="((HL7.{PIDgrp.PV1grp.PV1:PatientClass})=(&quot;E&quot;))">
<send transform="" target="Priority_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ORM_O01"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ORM_O01"></constraint>
<when condition="1">
<send transform="" target="ORM_O01_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ADT_A31"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ADT_A01"></constraint>
<when condition="1">
<send transform="" target="ADT_A31_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ORU_R01"></constraint>
<constraint name="docCategory" value="2.3.1"></constraint>
<constraint name="docType" value="ORU_R01"></constraint>
<when condition="1">
<send transform="" target="Extra_Observations"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<when condition="1">
<send transform="" target="Regular_FileOperation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
