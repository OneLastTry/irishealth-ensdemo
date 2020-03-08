/// Business Activity Dashboard for Demo.Loan application.
Class Demo.Loan.Dashboard Extends Ens.Dashboard [ ClassType = "", ProcedureBlock ]
{

XData Dashboard
{
<Dashboard RefreshRate="2000" Metric="Demo.Loan.BankMetrics">
<Speedometer Label="Requests" Property="LoansRequested" />
<Speedometer Label="Approvals" Property="LoansApproved" />
</Dashboard>
}

}
