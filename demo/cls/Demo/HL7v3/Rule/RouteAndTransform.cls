/// Test rule for HL7 version 3 productions
Class Demo.HL7v3.Rule.RouteAndTransform Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.VDocRuleAssistCompatible";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Demo.HL7v3.Rule.Context" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<constraint name="msgClass" value="Demo.HL7v3.Message"></constraint>
<constraint name="docName" value="MFMT_IN002101"></constraint>
<when condition="1">
<send transform="Demo.HL7v3.Transformation.MFMTIN002101" target="HL7v3 SOAP Out"></send>
<send transform="Demo.HL7v3.Transformation.MFMTIN002101" target="HL7v3 File Out MFMT"></send>
<return></return>
</when>
</rule>
<rule name="">
<constraint name="msgClass" value="Demo.HL7v3.Message"></constraint>
<constraint name="docName" value="QUPA_IN101103"></constraint>
<when condition="1">
<send transform="Demo.HL7v3.Transformation.QUPAIN101103" target="HL7v3 SOAP Out"></send>
<send transform="Demo.HL7v3.Transformation.QUPAIN101103" target="HL7v3 File Out QUPA"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
