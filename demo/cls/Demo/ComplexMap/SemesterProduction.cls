Class Demo.ComplexMap.SemesterProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.ComplexMap.SemesterProduction" LogGeneralTraceEvents="false">
  <Description>Sample Production to illustrate the use of Complex Maps. NOTE: The source file, ComplexMap_Semester_Data.txt, as well as sample output files, should be located in [install_dir]/dev/ComplexMap/.</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Semester_Data_FileService" Category="" ClassName="EnsLib.RecordMap.Service.ComplexBatchFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ComplexMap">Demo.ComplexMap.Semester.SemesterData</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Semester_Data_Router</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\in\</Setting>
    <Setting Target="Adapter" Name="FileSpec">ComplexMap_Semester_Data*.txt</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
  </Item>
  <Item Name="Semester_Data_Router" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">Demo.ComplexMap.Rule.SemesterBatchRouting</Setting>
  </Item>
  <Item Name="Semester_Data_FileOperation" Category="" ClassName="EnsLib.RecordMap.Operation.ComplexBatchFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ComplexMap">Demo.ComplexMap.Semester.SemesterData</Setting>
    <Setting Target="Host" Name="Filename">Semester_Data_Passthrough_%Q.txt</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out\</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
  </Item>
  <Item Name="Semester_Summary_FileOperation" Category="" ClassName="EnsLib.RecordMap.Operation.ComplexBatchFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out\</Setting>
    <Setting Target="Host" Name="ComplexMap">Demo.ComplexMap.Summary.SemesterSummary</Setting>
    <Setting Target="Host" Name="Filename">Semester_Summary_%Q.txt</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
  </Item>
  <Item Name="Semester_FixedClassBatch_FileOperation" Category="" ClassName="EnsLib.RecordMap.Operation.ComplexBatchFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Write out fixed width batches containing classes." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ComplexMap">Demo.ComplexMap.SemesterFixed.ClassMap</Setting>
    <Setting Target="Host" Name="Filename">Semester_FixedClass_%Q.txt</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\out\</Setting>
  </Item>
  <Item Name="Semester_FixedStudentBatch_FileOperation" Category="" ClassName="EnsLib.RecordMap.Operation.ComplexBatchFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="Write out fixed width batches containing students." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ComplexMap">Demo.ComplexMap.SemesterFixed.StudentMap</Setting>
    <Setting Target="Host" Name="Filename">Semester_FixedStudent_%Q.txt</Setting>
    <Setting Target="Adapter" Name="Charset">UTF-8</Setting>
    <Setting Target="Adapter" Name="FilePath">c:\Practice\out\</Setting>
  </Item>
  <Item Name="Semester_FixedStudent_BatchCreator" Category="" ClassName="Demo.ComplexMap.SemesterFixed.StudentBatchProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BatchOperation">Semester_FixedStudentBatch_FileOperation</Setting>
  </Item>
</Production>
}

}
