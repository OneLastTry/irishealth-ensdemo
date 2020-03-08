Class Demo.HL7v3.Transformation.QUPAIN101103 Extends Ens.DataTransform [ DependsOn = Demo.HL7v3.Message ]
{

ClassMethod Transform(source As Demo.HL7v3.Message, ByRef target As Demo.HL7v3.Message) As %Status
{
	Set $ZTrap = "TransformET"

	// Get a QUPAIN101103 template as a stream
	Set tQUPAIN101103Template = ##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1) _ "||QUPAIN101103").Data

	// Get a stream of XSL from the XSL XDataBlock contained in this class
	Set tXSL = ##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1) _ "||XSL").Data

	// Create an XPATH Document instance from the input stream of XML
	Set tStatus	= ##class(%XML.XPATH.Document).CreateFromStream(source.Content, .tDocument)

	// Get receiving device's name, upper-case it, and bind to XSL parameter
	Set tStatus	= tDocument.EvaluateExpression("//QUPA_IN101103/receiver/device/name/given", "text()", .tResults)
	Set tParams("receivingDeviceName") = "'" _ $ZConvert(tResults.GetAt(1).Value, "U") _ "'"

	// Get sending device's name, upper-case it, and bind to XSL parameter
	Set tStatus	= tDocument.EvaluateExpression("//QUPA_IN101103/sender/device/name/given", "text()", .tResults)
	Set tParams("sendingDeviceName") = "'" _ $ZConvert(tResults.GetAt(1).Value, "U") _ "'"

	// Transform the source according to the XSL
	Set target	= ##class(Demo.HL7v3.Message).%New()
	Set tStatus	= ##class(%XML.XSLT.Transformer).TransformStream(tQUPAIN101103Template, tXSL, target.Content, , .tParams)
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

XData QUPAIN101103
{
<QUPA_IN101103>
	<id extension="1001" root="2.16.528.1.1007.3.2.2.233"/>
	<creationTime value="20040719140000"/>
	<versionCode code="12345"/>
	<interactionId extension="QUPA_IN101103" root="2.16.840.1.113883"/>
	<processingCode code="P"/>
	<processingModeCode code="T"/>
	<acceptAckCode code="ER"/>
	<receiver>
		<telecom use="WP" value="tel:+34372324874"/>
		<device>
			<id extension="000900478" root="2.16.528.1.1007.3.2"/>
			<name use="L">
				<given> </given>
			</name>
		</device>
	</receiver>
	<sender>
		<telecom use="WP" value="tel:+34307236354"/>
		<device>
			<!-- sending application, ID of sending system -->
			<id extension="1" root="2.16.528.1.1007.3.2"/>
			<name use="L">
				<given> </given>
			</name>
		</device>
	</sender>
	<ControlActProcess moodCode="EVN">
		<effectiveTime value="20040719135956"/>
		<authorOrPerformer typeCode="AUT">
			<participant>
				<AssignedPerson>
					<id extension="000120450" root="2.16.528.1.1007.3.1"/>
					<Organization>
						<id extension="00304845" root="2.16.528.1.1007.3.2"/>
					</Organization>
				</AssignedPerson>
			</participant>
		</authorOrPerformer>
		<reasonOf>
			<justifiedDetectedIssue>
				<code code="QNAT" codeSystem="2.16.840.1.113883.2.4.5.4" codeSystemName="ActCode"/>
				<targetOf>
					<source moodCode="DEF">
						<code code="EMAUTH" codeSystem="2.16.840.1.113883.2.4.5.4" codeSystemName="ActCode"/>
					</source>
				</targetOf>
			</justifiedDetectedIssue>
		</reasonOf>
		<queryByParameter>
			<queryId extension="5523264" root="2.16.528.1.1007.3.2.400893.15"/>
			<statusCode code="new"/>
			<person.addr>
				<value>
					<postalCode>5735 EP</postalCode>
				</value>
				<semanticsText>Person.addr</semanticsText>
			</person.addr>
			<person.birthTime>
				<value>
					<center value="19750103"/>
				</value>
				<semanticsText>Person.birthTime</semanticsText>
			</person.birthTime>
		</queryByParameter>
	</ControlActProcess>
</QUPA_IN101103>
}

XData XSL
{
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="1.0">  
  
<xsl:param name="receivingDeviceName"/>
<xsl:param name="sendingDeviceName"/>

<xsl:output method="xml" indent="yes"/>
 
<xsl:template match="node()" priority="0"/>

<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="//QUPA_IN101103/receiver/device/name/given/text()">
     <xsl:value-of select="$receivingDeviceName"/>
</xsl:template>  

<xsl:template match="//QUPA_IN101103/sender/device/name/given/text()">
     <xsl:value-of select="$sendingDeviceName"/>
</xsl:template>  

</xsl:stylesheet>
}

}
