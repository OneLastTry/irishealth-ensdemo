/// 
Class Demo.ComplexMap.Rule.SemesterBatchRouting Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.ComplexMap.SemesterProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="source" value="Semester_Data_FileService"></constraint>
<constraint name="msgClass" value="Demo.ComplexMap.Semester.Batch"></constraint>
<when condition="1">
<send transform="" target="Semester_Data_FileOperation"></send>
<send transform="Demo.ComplexMap.Transform.SemesterBatchToSemesterSummaryBatch" target="Semester_Summary_FileOperation"></send>
<send transform="Demo.ComplexMap.Transform.SemesterBatchToFixedClassBatch" target="Semester_FixedClassBatch_FileOperation"></send>
<send transform="Demo.ComplexMap.Transform.SemesterBatchToFixedStudentBatch" target="Semester_FixedStudentBatch_FileOperation"></send>
<send transform="" target="Semester_FixedStudent_BatchCreator"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
