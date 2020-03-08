Class Demo.HL7v3.TestHarness.HL7v3SOAPInProxy Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost/csp/ensdemo/Demo.HL7v3.Service.SOAPIn.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 0;

/// This is the name of the Service
Parameter SERVICENAME = "HL7v3SOAPIn";

Method SendMessage(pInput As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SendMessage").Invoke($this,"http://tempuri.org/Demo.HL7v3.Service.SOAPIn.SendMessage",.pInput)
}

}
