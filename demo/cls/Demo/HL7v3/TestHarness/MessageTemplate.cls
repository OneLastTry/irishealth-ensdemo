Class Demo.HL7v3.TestHarness.MessageTemplate Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Relationship RequestMaps As Demo.HL7v3.TestHarness.RequestMap [ Cardinality = many, Inverse = Request ];

Relationship ResponseMaps As Demo.HL7v3.TestHarness.ResponseMap [ Cardinality = many, Inverse = Response ];

Property Name As %String;

Property Type As %String;

Property Message As %GlobalCharacterStream;

Index NameIndex On Name [ Unique ];

Index TypeIndex On Type;

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
 <prefix qualifier="VV">de </prefix>
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

Storage Default
{
<Data name="MessageTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^Demo.HL7v37C9.MessageTempl601D</DataLocation>
<DefaultData>MessageTemplateDefaultData</DefaultData>
<IdLocation>^Demo.HL7v37C9.MessageTempl601D</IdLocation>
<IndexLocation>^Demo.HL7v37C9.MessageTempl601I</IndexLocation>
<StreamLocation>^Demo.HL7v37C9.MessageTempl601S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
