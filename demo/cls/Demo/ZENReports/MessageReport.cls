/// Demo.ZENReports.MessageReport
Class Demo.ZENReports.MessageReport Extends %ZEN.Report.reportPage
{

/// Class name of application this report belongs to.
Parameter APPLICATION;

/// Specifies the default display mode used for this report if
/// the URL parameter, <var>$MODE</var>, is not present.
Parameter DEFAULTMODE As STRING [ Constraint = ",html,tohtml,toxslfo,pdf,xml,xslfo,excel,toexcel,ps,pdfprint,xlsx", Flags = ENUM ] = "pdf";

/// This is the optional XML namespace used for the report.
Parameter REPORTXMLNAMESPACE;

Property Units As %ZEN.Datatype.string(VALUELIST = ",DAYS,HOURS", ZENURL = "UNITS") [ InitialExpression = "DAYS" ];

Property Value As %ZEN.Datatype.float(ZENURL = "VALUE") [ InitialExpression = "-1" ];

/// This XML defines the logical contents of this report.
XData ReportDefinition [ XMLNamespace = "http://www.intersystems.com/zen/report/definition" ]
{
<report xmlns="http://www.intersystems.com/zen/report/definition"
 name="MyReport" runonce="true">
 <group name="RunReport">
 <attribute name="TimeStamp" expression="$ZDT($H)"/>
 </group>
<group name="Sources" OnCreateResultSet="GetMessages">
<group name="Source">
<attribute name="SourceCount" field="SourceCount"/>
<attribute name="MessageSource" field="SourceConfigName"/>
</group>
</group>
</report>
}

/// This XML defines the display for this report.
/// This is used to generate the XSLT stylesheets for both HTML and XSL-FO.
XData ReportDisplay [ XMLNamespace = "http://www.intersystems.com/zen/report/display" ]
{
<report xmlns="http://www.intersystems.com/zen/report/display"
 name="MyReport">
<!-- Optional Init element inserts custom XSLT instructions at the top level of the generated XSLT stylesheet. -->
<init ></init>
<!-- Optional Document element specifies page layout and style characteristics. -->
<document width="8.5in" height="11in" marginLeft="1.25in" marginRight="1.25in" marginTop="1.0in" marginBottom="1.0in" footerHeight="1.0in"  ></document>
<!-- Optional Pageheader element. -->
<pageheader >
</pageheader>
<!-- Optional Pagefooter element. Does not apply in HTML output. -->
<pagefooter >
<item special="page-count"/>
</pagefooter>
<!-- Required Body element. -->
<body>
<header>
<p class="banner1">Message Sources and Their Count</p>
<fo><line pattern="empty"/><line pattern="empty"/></fo>
<table orient="row" align="center">
<item field="RunReport/@TimeStamp">
<caption value="Report Time Stamp:"/>
</item>
</table>
<line pattern="empty"/>

</header>
<!-- add display definition of the report here. -->
<group name="Sources">
<table group="Source" class="table2">
<item field="@SourceCount" width="2in">
<caption value="Count"/>
</item>
<item field="@MessageSource" width="5in">
<caption value="Source"/>
</item>
</table>
</group>
</body>
</report>
}

Method GetMessages(ByRef pSC, ByRef tParams)
{
	set statement=##class(%SQL.Statement).%New() 
	If ..Units="DAYS" {
		Set sql = "select count(*) As SourceCount, SourceConfigName from Ens.MessageHeader where timecreated>DATEADD('day',"_..Value_",GETUTCDATE()) and timecreated<GETUTCDATE() group by SourceConfigName"
	} Elseif ..Units="HOURS" {
		Set sql = "select count(*) As SourceCount, SourceConfigName from Ens.MessageHeader where timecreated>DATEADD('hour',"_..Value_",GETUTCDATE()) and timecreated<GETUTCDATE() group by SourceConfigName"

	} Else {
		Set pSC=$$$ERROR($$$GeneralError,"Units property was not valid")
		Quit ""
	}
	Set pSC=statement.%Prepare(sql)
	Set statement.%SelectMode=2
	If $$$ISERR(pSC) Quit ""
	If $D(tParams) {
		Set rs=statement.%Execute(tParams)
	} else {
		Set rs=statement.%Execute()
	}
   	Quit rs
}

}
