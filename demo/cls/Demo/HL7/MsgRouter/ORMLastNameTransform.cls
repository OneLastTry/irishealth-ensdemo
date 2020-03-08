Class Demo.HL7.MsgRouter.ORMLastNameTransform Extends Ens.DataTransformDTL [ ClassType = "", DependsOn = EnsLib.HL7.Message, ProcedureBlock ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='Demo.HL7.MsgRouter.Schema:ORM_O01' targetDocType='2.3.1:ORM_O01' create='new' language='objectscript' >
<assign value='source.{MSH}' property='target.{MSH}' action='set'  />
<assign value='source.{NTE(1)}' property='target.{NTE(1)}' action='set'  />
<assign value='source.{ORCgrp(1)}' property='target.{ORCgrp(1)}' action='set'  />
<assign value='source.{PIDgrp.PID}' property='target.{PIDgrp.PID}' action='set'  />
<assign value='"NEWNAME"' property='target.{PIDgrp.PID:5.1}' action='set'  />
</transform>
}

}
