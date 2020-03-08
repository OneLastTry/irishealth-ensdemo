/// Business rule responsible for mapping an input location to "F" for Fahrenheit or "C" for Celsius temperature scale.
Class Demo.ZenService.Bproc.WeatherReport.TempScale Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Demo.ZenService.Bproc.WeatherReport.Context">
<ruleSet effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="(Location=&quot;US&quot;)||(Location=&quot;USA&quot;)">
<return>"F"</return>
</when>
<otherwise>
<return>"C"</return>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
