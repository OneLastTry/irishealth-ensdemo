Class Demo.HL7.MsgRouter.EmailAlertTransform Extends Ens.DataTransformDTL [ DependsOn = Ens.AlertRequest ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.AlertRequest' targetClass='Ens.AlertRequest' create='new' language='objectscript' >
<assign value='source.SourceConfigName' property='target.SourceConfigName' action='set'  />
<assign value='source.AlertText' property='target.AlertText' action='set'  />
<assign value='..Lookup("AlertTable",source.SourceConfigName)' property='target.AlertDestination' action='set'  />
</transform>
}

}
