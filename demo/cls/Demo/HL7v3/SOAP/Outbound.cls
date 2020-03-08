Class Demo.HL7v3.SOAP.Outbound Extends %SOAP.WebClient
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost/csp/ensdemo/Demo.HL7v3.TestHarness.SOAPService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HL7v3SOAPOut";

Method GetResponse(pInput As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetResponse").Invoke($this,"http://tempuri.org/Demo.HL7v3.TestHarness.SOAPService.GetResponse",.pInput)
}

}
