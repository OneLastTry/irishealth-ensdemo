/// This is a sample of a a Business Metric class;
/// It defines a set of Business Metric properties (aka Key Performance Indicators)
/// and provides the code to periodically calculate their values.
/// These metrics can then be displayed within an Ensemble Dashboard.
Class Demo.Dashboard.SalesMetrics Extends Ens.BusinessMetric [ ClassType = "", ProcedureBlock ]
{

/// This reports recent sales (in dollars) for a given product
Property Sales As Ens.DataType.Metric(AUTOHISTORY = 10, RANGELOWER = 0, RANGEUPPER = 100, UNITS = "Dollars") [ MultiDimensional ];

/// This reports recent sales (in units sold) for a given product
Property Units As Ens.DataType.Metric(AUTOHISTORY = 10, RANGELOWER = 0, RANGEUPPER = 100, UNITS = "Units") [ MultiDimensional ];

/// Recent backlog for current product
Property Backlog As Ens.DataType.Metric(RANGELOWER = 0, RANGEUPPER = 10, UNITS = "Days");

/// This reports total sales since start of the demo.
Property TotalSales As Ens.DataType.Metric(RANGELOWER = 0, RANGEUPPER = 10000, UNITS = "Dollars");

/// This reports total units sold since start of the demo.
Property TotalUnits As Ens.DataType.Metric(RANGELOWER = 0, RANGEUPPER = 10000, UNITS = "Units");

/// This reports some random news displayed in order to display it
/// within a tickertape feed.
Property News As Ens.DataType.Metric;

/// This method is called periodically, for each instance (product in this case)
/// in order to update the various metric values.
Method OnCalculateMetrics() As %Status
{
	// randomly get number of sales since last time
	Set ..Sales = $Random(50) + $Random(50)
	Set ..Units = $Random(5) + $Random(5)

	Set ..TotalSales = ..TotalSales + ..Sales
	Set ..TotalUnits = ..TotalUnits + ..Units
	
	Set ..Backlog = $Random(10)

	// make up some news
	If ((..%Instance = "Apples") && ($Random(100) > 75)) {
		Set tList1 = $LB("Rates are","Futures are","Prices are","Demand is")
		Set tList2 = $LB("up","down","level")
		Set ..News = $LG(tList1,$Random($LL(tList1))+1) _ " " _ $LG(tList2,$Random($LL(tList2))+1) _ "."
	}

	Quit $$$OK
}

/// This method returns a list of instances for this Business Metric;
/// in this case, every instance represents a specific product
ClassMethod OnGetInstances(ByRef pInstSet As %String) As %Status
{
	Set pInstSet(1) = "Apples"
	Set pInstSet(2) = "Bananas"
	Set pInstSet(3) = "Cherries"
	Set pInstSet(4) = "Dates"
	Set pInstSet(5) = "Eggplants"
	Set pInstSet(6) = "Figs"
	
	Quit $$$OK
}

}
