/// This class defines the initial definitions of the dashboards for the ENSDEMO namespace.
/// When this class is compiled (or recompiled), DeepSee copies the dashboard definitions out of
/// this class. Then the dashboards are available in the DeepSee User Portal and Folder Manager.
/// They are also listed in Studio as .DFI items, in the Other folder in the Workspace window.
/// <p>These dashboards display data only when specific productions are running; see the dashboard
/// descriptions.
/// <p>This class also defines some sample links for the DeepSee User Portal.
Class Demo.Dashboard.DashboardsEtc Extends %DeepSee.UserLibrary.Container
{

/// It is convenient to list items here in the same order in which Studio 
/// lists them, and to precede each with a comment that gives its full name.
XData Contents [ XMLNamespace = "http://www.intersystems.com/deepsee/library" ]
{
<items>

<!-- Dashboard with Charts.dashboard -->
<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Dashboard with Charts" folderName="" title="" description="This sample dashboard displays random sales information based on the Demo.Dashboard.SalesMetrics class." keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;,src:&apos;covers/8211681_s.jpg&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;,style:&apos;font-weight: bold;font-variant: small-caps;left:21.875px;left:21.875px;width:95px;&apos;},image: {style:&apos;display: none;&apos;,src:&apos;deepsee/ds2_dashboard_44.png&apos;,imageStyle:&apos;width:64px;height:64px;&apos;},subtitle: {},footer: {text:&apos;Requires Dashboard production&apos;}}" scheme="" worklistCount="0" snapTo="false" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" companyName="Demo" companyLogo="" companyStyle="">
  <widget name="pieChartTotalSales" type="pivot" subtype="areaChart" subtypeClass="lineChart" title="Area Line Chart: Recent Sales Figures" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="0" width="525" height="395" sidebarContent="At left you will find information about recent sales revenues from various fruits. For details and past results, call your regional sales manager. Meanwhile, at right you will find information about number of units sold of each type of fruit. At far right is a bar chart showing both values for each product sold." showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="3" rowSpanL="5" showToolbar="true" theme="">
    <control name="" action="refresh" target="*" targetProperty="" location="widget" type="timer" controlClass="" timeout="5" label="Refresh" title="Refresh this chart" value="" text="" readOnly="false" valueList="" displayList="" activeWhen=""></control>
    <dataProperty name="" label="" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="XgridLines">1</property>
    <property name="YgridLines">1</property>
    <property name="analyzer">1</property>
    <property name="chartToggle">chart</property>
    <property name="excel">1</property>
    <property name="labels">1</property>
    <property name="legendPos">none</property>
    <property name="print">1</property>
  </widget>
  <widget name="pieChart3D" type="pivot" subtype="pieChart3D" subtypeClass="pieChart" title="3D Pie Chart: Number of Units Sold" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="522" width="420" height="394" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="3" colSpanL="4" rowSpanL="5" showToolbar="true" theme="">
    <dataProperty name="" label="Total Units" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Units" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="chartToggle">chart</property>
    <property name="excel">1</property>
    <property name="labels">0</property>
    <property name="legendPos">right</property>
    <property name="print">1</property>
  </widget>
  <widget name="barChartSalesUnits" type="pivot" subtype="columnChartStacked" subtypeClass="barChart" title="Stacked Column Chart: Sales and Units" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="401" left="0" width="369" height="394" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="7" colSpanL="3" rowSpanL="5" showToolbar="true" theme="">
    <dataProperty name="" label="Sales Figures" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="" label="Units Sold" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Units" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="XgridLines">1</property>
    <property name="YgridLines">1</property>
    <property name="chartToggle">chart</property>
    <property name="excel">1</property>
    <property name="labels">1</property>
    <property name="legendPos">bottom</property>
    <property name="print">1</property>
  </widget>
</dashboard>

<!-- Dashboard with Meters.dashboard -->
<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Dashboard with Meters" folderName="" title="" description="This sample dashboard displays random sales information based on the Demo.Dashboard.SalesMetrics class." keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background-color:white;top:71.875px;left:28.125px;left:28.125px;width:85px;height:90px;&apos;,src:&apos;covers/11259257_s.jpg&apos;,imageStyle:&apos;width:85px;height:90px;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;,style:&apos;color:green;font-family:verdana;left:21.875px;left:21.875px;width:97.5px;&apos;},image: {style:&apos;display: none;top:106.25px;left:3.125px;left:3.125px;width:87.5px;height:87.5px;&apos;,imageStyle:&apos;width:87.5px;height:87.5px;&apos;},footer: {text:&apos;Requires Dashboard production&apos;}}" scheme="" worklistCount="0" snapTo="false" snapGrid="true" gridRows="2" gridCols="3" canResize="true" canModify="true" showTitleBar="true" companyName="Demo" companyLogo="" companyStyle="">
  <widget name="speedometer" type="meter" subtype="speedometer" subtypeClass="" title="Speedometer" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="0" width="229" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <control name="" action="refresh" target="*" targetProperty="" location="widget" type="timer" controlClass="" timeout="5" label="Refresh" title="Refresh the meter display" value="" text="" readOnly="false" valueList="" displayList="" activeWhen=""></control>
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="fuelGauge" type="meter" subtype="fuelGauge" subtypeClass="" title="Fuel Gauge" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="228" width="198" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="2" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="text" type="meter" subtype="textMeter" subtypeClass="" title="Text Meter" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="425" width="208" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="1" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <dataProperty name="" label="$auto" width="" align="" subtype="textMeter" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="News" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override="{height:67,width:268,dataBinding:&apos;Sales&apos;,label:&apos;$auto&apos;,value:&apos;44&apos;,_type:&apos;textMeter&apos;}"></dataProperty>
  </widget>
  <widget name="trafficLight" type="meter" subtype="trafficLight" subtypeClass="" title="Traffic Light" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="221" left="0" width="196" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="1" homeColL="0" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="highRangeColor">green</property>
    <property name="lowRangeColor">red</property>
  </widget>
  <widget name="lightBar" type="meter" subtype="lightBar" subtypeClass="" title="Light Bar" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="221" left="195" width="196" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="1" homeColL="1" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="smiley" type="meter" subtype="smiley" subtypeClass="" title="Smiley" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="221" left="390" width="243" height="222" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="1" homeColL="2" colSpanL="1" rowSpanL="1" showToolbar="true" theme="">
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
</dashboard>

<!-- Links/Ensemble Monitor.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="Ensemble Monitor" folderName="Links" title="" description="Ensemble Monitor Page (see performance across all namespaces)" keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;,style:&apos;color:rgb(224, 0, 0);font-family:lucida sans unicode;font-size:22px;padding:7px;top:15px;&apos;},image: {style:&apos;top:84.375px;left:25px;left:25px;width:92.5px;height:90px;&apos;,src:&apos;covers/14865209_s.jpg&apos;,imageStyle:&apos;width:92.5px;height:90px;&apos;},footer: {text:&apos;$owner&apos;,style:&apos;display: none;&apos;}}" href="/csp/sys/%25CSP.UI.Portal.EnsembleMonitor.zen">
</link>

<!-- Links/Event Log ENSDEMO.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="Event Log ENSDEMO" folderName="Links" title="" description="Event Log Page in ENSDEMO namespace" keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background-color:white;opacity:0.79;&apos;,src:&apos;covers/11008485_s.jpg&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;Event Log&apos;,style:&apos;font-weight: bold;color:rgb(255, 255, 255);font-size:31px;padding:0px;top:59.375px;&apos;},image: {style:&apos;display: none;&apos;},footer: {text:&apos;ENSDEMO&apos;,style:&apos;color:rgb(0, 0, 0);background-color:rgb(190, 226, 250);&apos;}}" href="/csp/ensdemo/EnsPortal.EventLog.zen?$NAMESPACE=ENSDEMO&amp;$NAMESPACE=ENSDEMO">
</link>

<!-- Links/InterSystems Documentation.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="InterSystems Documentation" folderName="Links" title="" description="Access DOCBOOK application (if available)" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;},image: {style:&apos;top:59.375px;width:140px;height:135px;&apos;,src:&apos;covers/book_128.gif&apos;,imageStyle:&apos;width:140px;height:135px;&apos;},footer: {text:&apos;$owner&apos;}}" href="/csp/docbook/DocBook.UI.HomePageZen.cls">
</link>

<!-- Links/InterSystems Web Site.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="InterSystems Web Site" folderName="Links" title="" description="" keywords="" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2013-01-30T22:49:09.292Z" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;,style:&apos;font-weight: bold;font-variant: small-caps;color:rgb(0, 75, 152);font-size:18px;&apos;},image: {style:&apos;top:68.75px;left:9.375px;left:9.375px;width:120px;height:115px;&apos;,src:&apos;covers/world_128.gif&apos;,imageStyle:&apos;width:120px;height:115px;&apos;},footer: {text:&apos;$owner&apos;}}" href="http://www.intersystems.com">
</link>

<!-- Links/Queues ENSDEMO.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="Queues ENSDEMO" folderName="Links" title="" description="Queues Page in ENSDEMO namespace" keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2013-02-15T16:07:36.688Z" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;Queues&apos;,style:&apos;color:rgb(0, 75, 152);font-family:courier new;font-size:26px;&apos;},image: {style:&apos;left:18.75px;left:18.75px;width:102.5px;height:102.5px;&apos;,src:&apos;covers/8891476_s.jpg&apos;,imageStyle:&apos;width:102.5px;height:102.5px;&apos;},footer: {text:&apos;ENSDEMO&apos;,style:&apos;color:rgb(0, 0, 0);background-color:rgb(190, 226, 250);&apos;}}" href="/csp/ensdemo/EnsPortal.Queues.zen">
</link>

<!-- Links/Production Configuration ENSDEMO.link -->
<link xmlns="http://www.intersystems.com/deepsee/library" name="Production Configuration ENSDEMO" folderName="Links" title="" description="Production Configuration Page in ENSDEMO namespace" keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="2013-02-14T18:23:57.985Z" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background:white;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;Production Configuration&apos;,style:&apos;font-weight: bold;color:rgb(38, 62, 86);&apos;},image: {style:&apos;width:135px;height:120px;&apos;,src:&apos;covers/14458232_s.jpg&apos;,imageStyle:&apos;width:135px;height:120px;&apos;},footer: {text:&apos;ENSDEMO&apos;,style:&apos;color:rgb(0, 0, 0);background-color:rgb(190, 226, 250);&apos;}}" href="/csp/ensdemo/EnsPortal.ProductionConfig.zen">
</link>

<!-- Loan Dashboard.dashboard -->
<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Loan Dashboard" folderName="" title="" description="This sample dashboard uses Demo.Loan.FindRateProduction." keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background-color:white;opacity:1;&apos;,imageStyle:&apos;width:134px;&apos;},header: {text:&apos;$type&apos;,style:&apos;text-align: center;&apos;},title: {text:&apos;$title&apos;,style:&apos;text-align: center;font-weight: bold;padding:2px;&apos;},image: {style:&apos;top:62.5px;left:37.5px;left:37.5px;width:67.5px;height:87.5px;&apos;,src:&apos;covers/10001316_s.jpg&apos;,imageStyle:&apos;width:67.5px;height:87.5px;&apos;},footer: {text:&apos;Requires FindRateProduction&apos;,style:&apos;background-color:rgb(0, 0, 224);&apos;}}" scheme="" worklistCount="0" snapTo="true" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" companyName="Demo" companyLogo="" companyStyle="">
  <widget name="speedometer" type="meter" subtype="speedometer" subtypeClass="" title="Loan Statistics" dataSource="Demo.Loan.FindRateProduction/Demo.Loan.BankMetrics.metric" dataLink="" drillDownDataSource="" top="16" left="15" width="936" height="528" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="5" rowSpanL="5" showToolbar="true" theme="">
    <control name="" action="applyFilter" target="*" targetProperty="" location="widget" type="timer" controlClass="" timeout="5" label="" title="" value="" text="" readOnly="false" valueList="" displayList="" activeWhen=""></control>
    <dataProperty name="" label="Loan Requests" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="LoansRequested" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="" label="Approval Notifications" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="LoansApproved" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="format">#,#</property>
    <property name="highRangeColor">green</property>
    <property name="labelStyle"></property>
  </widget>
</dashboard>

<!-- Sales Dashboard.dashboard -->
<dashboard xmlns="http://www.intersystems.com/deepsee/library" name="Sales Dashboard" folderName="" title="" description="This sample dashboard displays random sales information based on the Demo.Dashboard.SalesMetrics class." keywords="Ensemble" owner="" shared="true" public="true" locked="false" resource="" timeCreated="" createdBy="" category="Sample Category" bookCover="{background: {style:&apos;background-color:white;top:9.375px;&apos;,src:&apos;covers/14790293_s.jpg&apos;,imageStyle:&apos;width:134px;height:190px;&apos;},header: {text:&apos;$type&apos;},title: {text:&apos;$title&apos;,style:&apos;text-align: left;font-variant: small-caps;color:rgb(224, 0, 0);padding:6px;border-radius:16px 16px 16px 16px;top:9.375px;width:105px;&apos;},image: {style:&apos;display: none;&apos;,src:&apos;deepsee/ds2_dashboard_44.png&apos;,imageStyle:&apos;width:64px;height:64px;&apos;},subtitle: {style:&apos;display: none;&apos;},footer: {text:&apos;Requires Dashboard production&apos;}}" scheme="" worklistCount="0" snapTo="false" snapGrid="true" gridRows="10" gridCols="10" canResize="true" canModify="true" showTitleBar="true" companyName="Demo" companyLogo="" companyStyle="">
  <widget name="lineChartSales" type="pivot" subtype="lineChartMarkers" subtypeClass="lineChart" title="Recent Sales by Product: Amounts" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="0" width="381" height="296" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="0" colSpanL="3" rowSpanL="4" showToolbar="true" theme="">
    <control name="" action="refresh" target="*" targetProperty="" location="widget" type="timer" controlClass="" timeout="5" label="Refresh" title="Refresh this chart" value="" text="" readOnly="false" valueList="" displayList="" activeWhen=""></control>
    <dataProperty name="" label="Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="XgridLines">0</property>
    <property name="YgridLines">0</property>
    <property name="chartToggle">none</property>
    <property name="labels">1</property>
    <property name="legendPos">none</property>
  </widget>
  <widget name="speedometerSales" type="meter" subtype="speedometer" subtypeClass="" title="Total Sales and Units Sold" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="296" left="0" width="382" height="240" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="4" homeColL="0" colSpanL="4" rowSpanL="3" showToolbar="true" theme="">
    <dataProperty name="" label="Total Sales" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="TotalSales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="" label="Total Units" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="TotalUnits" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="format">#,#</property>
    <property name="highRangeColor">red</property>
    <property name="labelStyle"></property>
    <property name="lowRangeColor">red</property>
  </widget>
  <widget name="lightbarBacklog" type="meter" subtype="lightBar" subtypeClass="" title="Backlog" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="300" left="774" width="174" height="236" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="4" homeColL="4" colSpanL="2" rowSpanL="3" showToolbar="true" theme="">
    <dataProperty name="" label="" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="Backlog" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="barChartSalesUnits" type="pivot" subtype="barChart" subtypeClass="barChart" title="Recent Sales and Units Sold" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="947" width="351" height="536" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="3" colSpanL="3" rowSpanL="4" showToolbar="true" theme="">
    <dataProperty name="" label="Sales" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <dataProperty name="" label="Units" width="" align="" subtype="" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="Units" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
  </widget>
  <widget name="pieChartSales" type="pivot" subtype="donutChart3D" subtypeClass="pieChart" title="Recent Sales" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="16" left="1350" width="421" height="337" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="5" homeColL="6" colSpanL="4" rowSpanL="5" showToolbar="true" theme="">
    <dataProperty name="" label="Recent Sales" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="labels">1</property>
    <property name="legendPos">none</property>
  </widget>
  <widget name="pieChartSales" type="pivot" subtype="donutChart3D" subtypeClass="pieChart" title="Recent Sales by Product: Proportions" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" top="0" left="381" width="393" height="536" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="0" homeColL="6" colSpanL="4" rowSpanL="5" showToolbar="true" theme="">
    <dataProperty name="" label="" width="" align="" subtype="" style="" display="" format="" showAs="" valueColumn="false" summary="" summaryValue="" dataValue="Sales" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override=""></dataProperty>
    <property name="XgridLines">0</property>
    <property name="YgridLines">0</property>
    <property name="chartToggle">none</property>
    <property name="labelStyle"></property>
    <property name="labels">1</property>
    <property name="legendPos">none</property>
    <property name="showPercentage">1</property>
  </widget>
  <widget name="Widget7" type="meter" subtype="textMeter" subtypeClass="" title="News" dataSource="Demo.Dashboard.Production/SalesMetrics.metric" dataLink="" drillDownDataSource="" width="200" height="200" sidebarContent="" showSidebar="false" sidebarWidth="" maximized="false" homeRowL="7" homeColL="0" colSpanL="6" rowSpanL="3" showToolbar="true" theme="">
    <dataProperty name="" label="$auto" width="" align="" subtype="textMeter" style="" display="value" format="" showAs="value" valueColumn="false" summary="" summaryValue="" dataValue="News" targetValue="" thresholdLower="" thresholdUpper="" rangeLower="" rangeUpper="" baseValue="" override="{height:123,width:494,disabled:true,label:&apos;$auto&apos;,_type:&apos;textMeter&apos;}"></dataProperty>
  </widget>
</dashboard>

</items>
}

}
