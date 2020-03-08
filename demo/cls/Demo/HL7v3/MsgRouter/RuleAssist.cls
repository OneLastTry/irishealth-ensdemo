Class Demo.HL7v3.MsgRouter.RuleAssist Extends EnsLib.MsgRouter.RuleAssist [ Abstract ]
{

ClassMethod GetDescription() As %String
{
	quit "HL7v3 Demo Message Routing Rule"
}

ClassMethod GetContextClass() As %String
{
	quit "Demo.HL7v3.MsgRouter.RoutingEngine"
}

ClassMethod IsHidden() As %String
{
	quit 1
}

}
