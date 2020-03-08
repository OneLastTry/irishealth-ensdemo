Class Demo.HL7v3.Transformation.MFMTIN002101 Extends Ens.DataTransform [ DependsOn = Demo.HL7v3.Message ]
{

ClassMethod Transform(source As Demo.HL7v3.Message, ByRef target As Demo.HL7v3.Message) As %Status
{
	Set $ZTrap = "TransformET"

	// Get a MFMTIN002101 template as a stream
	Set tMFMTIN002101Template = ##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1) _ "||MFMTIN002101").Data

	// Get a stream of XSL from the XSL XDataBlock contained in this class
	Set tXSL = ##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1) _ "||XSL").Data

	// Create an XPATH Document instance from the input stream of XML
	Set tStatus	= ##class(%XML.XPATH.Document).CreateFromStream(source.Content, .tDocument)

	// Get patient's first name, upper-case it, and bind to XSL parameter
	Set tStatus	= tDocument.EvaluateExpression("//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/given", "text()", .tResults)
	Set tParams("patientNameGiven") = "'" _ $ZConvert(tResults.GetAt(1).Value, "U") _ "'"
				
	// Get patient's name prefix, upper-case it, and bind to XSL parameter
	Set tStatus	= tDocument.EvaluateExpression("//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/prefix[@qualifier='VV']", "text()", .tResults)
	Set tParams("patientNamePrefix") = "'" _ $ZConvert(tResults.GetAt(1).Value, "U") _ "'"

	// Get patient's last name, upper-case it, and bind to XSL parameter
	Set tStatus	= tDocument.EvaluateExpression("//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/family", "text()", .tResults)
	Set tParams("patientNameFamily") = "'" _ $ZConvert(tResults.GetAt(1).Value, "U") _ "'"

	// Transform the source according to the XSL
	Set target	= ##class(Demo.HL7v3.Message).%New()
	Set tStatus	= ##class(%XML.XSLT.Transformer).TransformStream(tMFMTIN002101Template, tXSL, target.Content, , .tParams)
	If $$$ISERR(tStatus) ZTrap "XSLT"

	// Copy over name and doctype, then rewind
	Set target.Name		= source.Name
	Set target.DocType	= source.DocType
	Do target.Content.Rewind()

	Quit $$$OK

TransformET
	Set $ZTrap = ""
	
	Quit $$$ERROR($$$GeneralError, "An error has occurred in Transform():  " _ $ZError)
}

XData MFMTIN002101
{
<MFMT_IN002101>
<!-- Transport Wrapper 
  --> 
  <id extension="9223372036854775800" root="2.16.528.1.1007.3.2.700222.1" /> 
  <creationTime value="2006-01-01 12:00:00PM" /> 
  <versionCode code="12345" /> 
  <interactionId extension="MFMT_IN002101" root="2.16.840.1.113883.1.6" /> 
  <processingCode code="ER" /> 
  <processingModeCode code="T" /> 
  <acceptAckCode code="ER" /> 
<receiver>
<device>
<!-- receiving application, ID of receiving system 
  --> 
  <id extension="000700856" root="2.16.528.1.1007.3.2" /> 
<name use="L">
  <given>Heathcare System XYZ</given> 
  </name>
<agencyFor classCode="AGNT">
<representedOrganization classCode="ORG" determinerCode="INSTANCE">
  <id extension="00100100" root="2.16.528.1.1007.3.3" /> 
<name use="L">
  <given>Organization XYZ</given> 
  </name>
  </representedOrganization>
  </agencyFor>
  </device>
  </receiver>
<sender>
  <telecom use="WP" value="tel:+31307236354" /> 
<device>
<!-- sending application, ID of sending system 
  --> 
  <id extension="000700222" root="2.16.528.1.1007.3.2" /> 
<name use="L">
  <given>ABC-HIS Goodhope Hospital</given> 
  </name>
<agencyFor classCode="AGNT">
<representedOrganization classCode="ORG" determinerCode="INSTANCE">
  <id extension="00600862" root="2.16.528.1.1007.3.3" /> 
<name use="L">
  <given>Goodhope Hospital</given> 
  </name>
  </representedOrganization>
  </agencyFor>
  </device>
  </sender>
<!-- Control Act Wrapper 
  --> 
<ControlActProcess moodCode="EVN">
  <effectiveTime value="20040417" /> 
<authorOrPerformer typeCode="AUT">
<participant>
<AssignedPerson>
  <id extension="000120450" root="2.16.528.1.1007.3.1" /> 
<Organization>
  <id extension="00988137" root="2.16.528.1.1007.3.3" /> 
  </Organization>
  </AssignedPerson>
  </participant>
  </authorOrPerformer>
<overseer typeCode="RESP">
<AssignedPerson>
  <id extension="000120450" root="2.16.528.1.1007.3.1" /> 
<Organization>
  <id extension="00988137" root="2.16.528.1.1007.3.3" /> 
  </Organization>
  </AssignedPerson>
  </overseer>
<subject>
<!-- payload 
  --> 
<registrationProcess classCode="REG" moodCode="RQO">
  <code code="722933" codeSystem="2.16.840.1.113883.2.4.15.4" codeSystemName="ActRegistryCodeNL" displayName="Voorschrift" /> 
  <statusCode code="active" codeSystem="2.16.840.1.113883.5.14" /> 
<effectiveTime>
  <low value="20040417" /> 
  </effectiveTime>
<subject2 typeCode="SUBJ">
<ActReference classCode="SBADM" moodCode="RQO">
  <id extension="9223372036854775800" root="2.16.528.1.1007.3.2.400416.16" /> 
  <statusCode code="active" /> 
<recordTarget>
<patient>
  <id extension="000197245" root="2.16.840.1.113883.2.4.6.3" /> 
  <statusCode code="" /> 
<Person>
<name use="L">
  <given>Tom</given> 
  <prefix qualifier="VV">de</prefix> 
  <family>Santis</family> 
  </name>
  </Person>
<Organization>
  <id extension="00123456" root="2.16.528.1.1007.3.3" /> 
  </Organization>
  </patient>
  </recordTarget>
<authorOrPerformer typeCode="AUT">
  <time value="20040417151000" /> 
<assignedEntity>
  <id extension="0000120450" root="2.16.528.1.1007.3.1" /> 
<assignedPerson>
  <name /> 
<LocatedEntity>
  <Place /> 
  </LocatedEntity>
  </assignedPerson>
<Organization>
  <id extension="00988137" root="2.16.528.1.1007.3.3" /> 
  </Organization>
  </assignedEntity>
  </authorOrPerformer>
<overseer typeCode="RESP">
<assignedEntity>
  <id extension="000120450" root="2.16.528.1.1007.3.1" /> 
  <code code="01.015" codeSystem="2.16.840.1.113883.2.4.15.111" codeSystemName="RoleCode" displayName="GP" /> 
<assignedPerson>
  <name /> 
<LocatedEntity>
  <Place /> 
  </LocatedEntity>
  </assignedPerson>
<Organization>
  <id extension="00988137" root="2.16.528.1.1007.3.3" /> 
  </Organization>
  </assignedEntity>
  </overseer>
  </ActReference>
  </subject2>
  </registrationProcess>
  </subject>
  </ControlActProcess>
  </MFMT_IN002101>
}

XData XSL
{
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="1.0">  
  
<xsl:param name="patientNameGiven"/>
<xsl:param name="patientNamePrefix"/>
<xsl:param name="patientNameFamily"/>

<xsl:output method="xml" indent="yes"/>
 
<xsl:template match="node()" priority="0"/>

<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/given/text()">
     <xsl:value-of select="$patientNameGiven"/>
</xsl:template>  

<xsl:template match="//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/prefix[@qualifier='VV']/text()">
     <xsl:value-of select="$patientNamePrefix"/>
</xsl:template>  

<xsl:template match="//MFMT_IN002101/ControlActProcess/subject/registrationProcess/subject2/ActReference/recordTarget/patient/Person/name/family/text()">
     <xsl:value-of select="$patientNameFamily"/>
</xsl:template>  

</xsl:stylesheet>
}

}
