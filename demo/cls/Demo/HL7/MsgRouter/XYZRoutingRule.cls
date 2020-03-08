/// Routing from the XYZ message source.
Class Demo.HL7.MsgRouter.XYZRoutingRule Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssistCompatible";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<when condition="((HL7.ParentId)!=(&quot;&quot;))">
<send transform="" target="Batch_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docCategory" value="2.3.1"></constraint>
<constraint name="docType" value="FHS,BHS"></constraint>
<when condition="1">
<send transform="" target="Batch_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ADT_A08"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ADT_A01"></constraint>
<when condition="(Contains(HL7.{PID:PatientName(1).familylastname},&quot;&lt;S&gt;&quot;))||(StartsWith(HL7.{PID:PatientName(1).familylastname},&quot;Z&quot;))">
<send transform="Demo.HL7.MsgRouter.ADTLastNameTransform" target="Other_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="">
<constraint name="msgClass" value="EnsLib.HL7.Message"></constraint>
<constraint name="docName" value="ORM_O01"></constraint>
<constraint name="docCategory" value="Demo.HL7.MsgRouter.Schema"></constraint>
<constraint name="docType" value="ORM_O01"></constraint>
<when condition="(StartsWith(HL7.{PIDgrp.PID:PatientName(1).familylastname},&quot;S&quot;))||(StartsWith(HL7.{PIDgrp.PID:PatientName(1).familylastname},&quot;Z&quot;))">
<send transform="Demo.HL7.MsgRouter.ORMLastNameTransform" target="Other_FileOperation"></send>
<return></return>
</when>
</rule>
<rule name="">
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
