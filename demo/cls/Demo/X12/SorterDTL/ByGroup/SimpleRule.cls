/// This Rule sends an Interchange to the transform before sending the newly transformed Interchange on to the File Operation.
Class Demo.X12.SorterDTL.ByGroup.SimpleRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.VDocRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.VDocRoutingEngine" production="Demo.X12.SorterDTL.ByGroup.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Interchange Transform" disabled="false">
<constraint name="source" value="ByGroupFileService"></constraint>
<constraint name="msgClass" value="EnsLib.EDI.X12.Document"></constraint>
<constraint name="docCategory" value="HIPAA_5010"></constraint>
<constraint name="docName" value="Interchange"></constraint>
<when condition="1">
<send transform="Demo.X12.SorterDTL.ByGroup.SorterTransform" target="ByGroupFileOperation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
