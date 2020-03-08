/// Sample business metric class for Workflow demo
Class Demo.Workflow.WFMetric Extends Ens.BusinessMetric [ ClassType = "", ProcedureBlock ]
{

/// Active Tasks
Property ActiveTasks As Ens.DataType.Metric(AUTOHISTORY = 10, RANGELOWER = 0, RANGEUPPER = 50, UNITS = "Tasks") [ MultiDimensional ];

/// Active Load
Property Load As Ens.DataType.Metric(AUTOHISTORY = 10, RANGELOWER = 0, RANGEUPPER = 100, THRESHOLDUPPER = 90, UNITS = "%") [ MultiDimensional ];

/// Completed Tasks (since previous day)
Property CompletedTasks As Ens.DataType.Metric(AUTOHISTORY = 10, RANGELOWER = 0, RANGEUPPER = 100, UNITS = "Tasks") [ MultiDimensional ];

/// Calculate and update the set of metrics for this class
Method OnCalculateMetrics() As %Status
{
	// set the values of our metrics
	// %Instance is the current instance (RoleName in this case)
	Set tRole = ..%Instance

	Set ..ActiveTasks = ##class(EnsLib.Workflow.Engine).BamActiveTasks(tRole)
	Set ..Load = ##class(EnsLib.Workflow.Engine).BamActiveLoad(tRole)

	// Get task since start of previous day
	Set tStart = $ZDT($H-1,3)

	Set ..CompletedTasks = ##class(EnsLib.Workflow.Engine).BamCompletedTasks(tRole,tStart)

	Quit $$$OK
}

/// Set of instances for this metric class<br>
/// There is one instance for every defined role.
Query MetricInstances() As %SQLQuery
{
	SELECT Name FROM EnsLib_Workflow.RoleDefinition
}

}
