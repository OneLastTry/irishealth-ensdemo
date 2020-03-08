Class Demo.HL7.MsgRouter.ADTLastNameTransform Extends Ens.DataTransformDTL [ ClassType = "", DependsOn = EnsLib.HL7.Message, ProcedureBlock ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='Demo.HL7.MsgRouter.Schema:ADT_A01' targetDocType='2.3.1:ADT_A01' create='new' language='objectscript' >
<assign value='source.{MSH}' property='target.{MSH}' action='set'  />
<assign value='"ADT"' property='target.{MSH:9.1}' action='set'  />
<assign value='"A01"' property='target.{MSH:9.2}' action='set'  />
<assign value='"TEST"' property='target.{MSH:ReceivingApplication}' action='set'  />
<assign value='source.{EVN}' property='target.{EVN}' action='set'  />
<assign value='source.{PID}' property='target.{PID}' action='set'  />
<assign value='"NEWNAME"' property='target.{PID:5.1}' action='set'  />
<assign value='source.{PD1}' property='target.{PD1}' action='set'  />
<assign value='source.{NK1(1)}' property='target.{NK1(1)}' action='set'  />
<assign value='source.{PV1}' property='target.{PV1}' action='set'  />
<assign value='source.{PV2}' property='target.{PV2}' action='set'  />
<assign value='source.{DB1(1)}' property='target.{DB1(1)}' action='set'  />
<assign value='source.{OBX(1)}' property='target.{OBX(1)}' action='set'  />
<assign value='source.{AL1(1)}' property='target.{AL1(1)}' action='set'  />
<assign value='source.{DG1(1)}' property='target.{DG1(1)}' action='set'  />
<assign value='source.{DRG}' property='target.{DRG}' action='set'  />
<assign value='source.{PR1grp(1)}' property='target.{PR1grp(1)}' action='set'  />
<assign value='source.{GT1(1)}' property='target.{GT1(1)}' action='set'  />
<assign value='source.{IN1grp(1)}' property='target.{IN1grp(1)}' action='set'  />
<assign value='source.{ACC}' property='target.{ACC}' action='set'  />
<assign value='source.{UB1}' property='target.{UB1}' action='set'  />
<assign value='source.{UB2}' property='target.{UB2}' action='set'  />
</transform>
}

}
