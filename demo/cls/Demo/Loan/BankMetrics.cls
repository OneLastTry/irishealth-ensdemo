/// Business Metric Class for Demo Loan Production
Class Demo.Loan.BankMetrics Extends Ens.BusinessMetric [ ClassType = "", ProcedureBlock ]
{

/// Total number of loan requests to date.
Property LoansRequested As Ens.DataType.Metric(RANGELOWER = 0, RANGEUPPER = 10000, UNITS = "Applications");

/// Total number of loans approved to date.
Property LoansApproved As Ens.DataType.Metric(RANGELOWER = 0, RANGEUPPER = 10000, UNITS = "Applications");

/// Calculate and update the set of metrics for this class
Method OnCalculateMetrics() As %Status
{
	// Note: these calculations are not accurate, they 
	// are demonstrative.
	
	// set the values of our metrics
	&sql(SELECT COUNT(*) INTO :count
		 FROM Demo_Loan_Msg.Application)

	Set ..LoansRequested = count
	
	// set the values of our metrics
	&sql(SELECT COUNT(*) INTO :count 
		 FROM Demo_Loan_Msg.Approval
		 WHERE IsApproved = 1)

	Set ..LoansApproved = count

	Quit $$$OK
}

}
