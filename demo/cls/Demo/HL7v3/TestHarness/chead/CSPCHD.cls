/// Created from: http://localhost/csp/ensdemo/Demo.HL7v3.Service.SOAPIn.cls?wsdl
Class Demo.HL7v3.TestHarness.chead.CSPCHD Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.intersystems.com/SOAPheaders";

Parameter XMLNAME = "CSPCHD";

Parameter XMLSEQUENCE = 1;

Property id As %String(MAXLEN = "", XMLNAME = "id") [ Required ];

}
