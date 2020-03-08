/// Dashboard class for the Workflow Demo
/// 
Class Demo.Workflow.Dashboard Extends Ens.Dashboard [ ClassType = "", ProcedureBlock ]
{

XData Dashboard
{
<Dashboard 
	Label="Role: {Instance}" 
	RefreshRate="2000" 
	Metric="Demo.Workflow.WFMetric({Instance})" 
	InstanceMenu="Roles"
>

<LightBar Label="ActiveTasks" Property="ActiveTasks"
	Link="WFTasksForRole.csp?$FRAME=Info&amp;$ID1={Instance}"
	Width="75"
/>

<LightBar Label="Load" Property="Load" 
	Link="WFTasksForRole.csp?$FRAME=Info&amp;$ID1={Instance}"
	Width="75"
/>

<LineChart Label="Tasks for Current Role" 
	Width="150" Height="100"
	AutoScale="true"
	XGridLines="20" YGridLines="9"
	>
<Series Label="Active" Property="ActiveTasks" Color="yellow" />
<Series Label="Completed" Property="CompletedTasks" Color="red" />
</LineChart>

</Dashboard>
}

}
