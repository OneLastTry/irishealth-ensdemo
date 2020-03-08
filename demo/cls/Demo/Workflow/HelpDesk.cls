Class Demo.Workflow.HelpDesk Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' height='2000' width='2000' request='Demo.Workflow.ProblemReport' response='Ens.Response' >
<context>
<property name='Resolved' type='%Boolean' initialexpression='0' />
<property name='DevelopmentAction' type='%String' />
<property name='TestingAction' type='%String' />
</context>
<sequence xpos='500' ypos='100' xend='500' yend='300' >
<while 
name='while' xpos='500' ypos='200' xend='504' yend='1190' condition='context.Resolved=0' >
<annotation>Work on this problem until it is resolved.
(Click on the loop icon to see details of this while loop.)</annotation>
<call name='Notify Development' xpos='500' ypos='200' target='Demo-Development' async='1' >
<annotation>Send the problem report to 
Development for review.</annotation>
<request type='EnsLib.Workflow.TaskRequest' >
<assign property='callrequest.%Actions' value='"Corrected,Ignored"' action='set' />
<assign property='callrequest.%Subject' value='"Problem reported by " _ request.ReportedBy' action='set' />
<assign property='callrequest.%Message' value='request.Problem' action='set' />
<assign property='callrequest.%FormFields' value='"Comments"' action='set' />
</request>
<response type='EnsLib.Workflow.TaskResponse' >
<assign property='context.DevelopmentAction' value='callresponse.%Action' action='set' />
</response>
</call>
<sync name='WaitForDevelopment' xpos='500' ypos='300' calls='Notify Development' type='all' />
<if name='Fixed?' xpos='500' ypos='400' xend='504' yend='1090' condition='context.DevelopmentAction="Corrected"' >
<annotation>If Development fixed the problem, test it.</annotation>
<true>
<call name='Notify Testing' xpos='629' ypos='543' target='Demo-Testing' async='1' >
<annotation>Send the problem 
 to Testing for
confirmation.</annotation>
<request type='EnsLib.Workflow.TaskRequest' >
<assign property='callrequest.%Actions' value='"Corrected,Retest"' action='set' />
<assign property='callrequest.%Subject' value='"Test this problem from " _ request.ReportedBy' action='set' />
<assign property='callrequest.%Message' value='request.Problem' action='set' />
</request>
<response type='EnsLib.Workflow.TaskResponse' >
<assign property='context.TestingAction' value='callresponse.%Action' action='set' />
</response>
</call>
<sync name='WaitForTesting' xpos='629' ypos='643' calls='Notify Testing' type='all' />
<if name='Corrected?' xpos='629' ypos='743' xend='629' yend='996' condition='context.TestingAction="Corrected"' >
<annotation>Has the problem been corrected?</annotation>
<true>
<assign name='Resolved' xpos='756' ypos='876' property='context.Resolved' value='1' action='set' />
</true>
</if>
</true>
<false>
<assign name='Not a problem' xpos='370' ypos='543' property='context.Resolved' value='1' action='set' />
</false>
</if>
</while>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
