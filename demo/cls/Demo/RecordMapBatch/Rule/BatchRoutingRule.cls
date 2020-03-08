/// 
Class Demo.RecordMapBatch.Rule.BatchRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.RecordMapBatch.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="source" value="BatchFileService"></constraint>
<constraint name="msgClass" value="Demo.RecordMapBatch.Map.TrainDataIn.BatchIn"></constraint>
<when condition="1">
<send transform="Demo.RecordMapBatch.Transform" target="BatchFileOperation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
