Class Demo.FloodMonitor.GeneratedBusinessProcess Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process request="Demo.FloodMonitor.WaterLevelRequest" response="Demo.FloodMonitor.WaterLevelResponse">
<sequence>
<call name="CallBusinessOperation1" target="Demo.FloodMonitor.BusinessOperation" async="1">
<request type="Demo.FloodMonitor.WaterLevelRequest">
<assign property="callrequest.Location" value="request.Location"/>
<assign property="callrequest.WaterLevel" value="request.WaterLevel"/>
</request>
<response type="Demo.FloodMonitor.WaterLevelResponse">
<assign property="response.IsTooHigh" value="callresponse.IsTooHigh"/>
</response>
</call>
<sync calls="CallBusinessOperation1"/>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
