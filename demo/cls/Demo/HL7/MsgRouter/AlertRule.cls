/// See the AlertTable lookup table for a mapping of alert sources to email addresses. If no match is found in the lookup, EmailAlertTransformation sends the alert to the configured Recipient for the EMailAlertOperation.
Class Demo.HL7.MsgRouter.AlertRule Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="">
<constraint name="msgClass" value="Ens.AlertRequest"></constraint>
<when condition="1">
<send transform="Demo.HL7.MsgRouter.EmailAlertTransform" target="EMailAlertOperation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
