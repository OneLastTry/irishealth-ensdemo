/// Business rule responsible for mapping an input location to an output language.
Class Demo.ZenService.Bproc.WeatherReport.LanguageFromLocation Extends Ens.Rule.Definition [ ProcedureBlock ]
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Demo.ZenService.Bproc.WeatherReport.Context">
<ruleSet effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="(Location = &quot;US&quot;)||(Location = &quot;USA&quot;)||(Location = &quot;England&quot;)||(Location = &quot;London&quot;)||(Location = &quot;UK&quot;)">
<return>"English"</return>
</when>
<when condition="(Location = &quot;Spain&quot;)||(Location = &quot;Mexico&quot;)">
<return>"Spanish"</return>
</when>
<when condition="Location = &quot;France&quot;">
<return>"French"</return>
</when>
<when condition="Location = &quot;Italy&quot;">
<return>"Italian"</return>
</when>
<when condition="Location = &quot;Germany&quot;">
<return>"German"</return>
</when>
<otherwise>
<return>"Unknown"</return>
</otherwise>
</rule>
</ruleSet>
</ruleDefinition>
}

}
