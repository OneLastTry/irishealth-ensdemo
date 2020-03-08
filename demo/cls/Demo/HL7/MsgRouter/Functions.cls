/// Functions to use in rule definitions for the sample message router production.
Class Demo.HL7.MsgRouter.Functions Extends Ens.Rule.FunctionSet [ ClassType = "", ProcedureBlock ]
{

/// Returns the ordinal position of the day in the week, 
/// where 1 is Sunday, 2 is Monday, and so on.
ClassMethod DayOfWeek() As %Integer [ CodeMode = expression, Final ]
{
$zd($H,10)
}

/// Returns the time as a number of seconds since midnight.
ClassMethod TimeInSeconds() As %Integer [ CodeMode = expression, Final ]
{
$p($H,",",2)
}

}
