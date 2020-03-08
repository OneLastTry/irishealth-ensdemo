/// This is a ProblemReport message.
/// It is used by the Workflow demo to represent a technical
/// problem submitted by a customer.
Class Demo.Workflow.ProblemReport Extends Ens.Request [ ClassType = persistent, ProcedureBlock ]
{

/// Name of customer reporting the problem.
Property ReportedBy As %String(MAXLEN = 60);

/// Description of the problem.
Property Problem As %String(MAXLEN = 200);

Storage Default
{
<Data name="ProblemReportDefaultData">
<Subscript>"ProblemReport"</Subscript>
<Value name="1">
<Value>Problem</Value>
</Value>
<Value name="2">
<Value>ReportedBy</Value>
</Value>
</Data>
<DefaultData>ProblemReportDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
