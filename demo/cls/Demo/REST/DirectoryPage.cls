Include (EnsConstants, EnsUI, Ensemble)

/// StartProduction
Class Demo.REST.DirectoryPage Extends %CSP.UI.Portal.Template
{

Parameter DOMAIN = "ENSDEMO";

/// User needs USE permissions on the %Ens_MessageContent resource to view this page.
Parameter RESOURCE = "%Ens_MessageContent:USE";

/// Displayed name of this page.
Parameter PAGENAME = "Demo REST Directory Service";

Parameter CSSINCLUDES = "ensemble/Ensemble_Wizards.css";

/// If true, then attempt to refresh this page when its session timeout period has expired.
/// This will cause a login page to display if the current session has ended
/// and security is set to require login.
Parameter AUTOLOGOUT As BOOLEAN = 0;

/// This XML block defines the contents of the page.
XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<jsonProvider id="jpResponseInfo" OnGetTargetObject="GetResponseInfo">
<parameter id="riId" paramName="responseId"/>
</jsonProvider>
<hgroup cellVAlign="top">
<pane id="paneSelect" paneName="paneSelect"/>
<spacer width="15"/>
<pane id="paneInfo" paneName="paneInfo" width="40%" />
<pane id="paneDetails" paneName="paneDetails"/>
</hgroup>
<hgroup>
<spacer width="15"/>
<vgroup>
<text name="txSession" id="txSession" label="Session ID" labelClass="labelRequired"
          title="View the Trace diagram for the REST service request and response." />
<text name="txURL" id="txURL" label="URL sent" labelClass="labelRequired" size="210" 
          title="The text of the REST service URL submitted to the server." />
<textarea name="txRawResponse" id="txRawResponse" label="Raw Response JSON" labelClass="labelRequired" height="100" width="400"
          title="The full REST / JSON response received from the server." />
</vgroup>
</hgroup>
</pane>
}

XData paneSelect [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen" >
<vgroup id="mainPanel" cellAlign="center" groupClass="" enclosingClass="menuPanel"  valign="top">
<form name="fmSelect" id="fmSelect" layout="vertical" cellStyle="padding: 2px 10px; font-size:0.8em;">
<radioSet required="true" readOnly="false" hidden="false" value=""
  name="rsPersonEmployee" id="rsPersonEmployee" label="Record Type" 
  labelClass="labelRequired"  enclosingStyle="padding-bottom:4px;" 
  title="Which type of directory record to work with"
  valueList="Person,Employee" displayList="Person,Employee" originalValue="Person"
  onclick="zenPage.changeType('rsPersonEmployee');"
	/>
<hgroup>
<radioSet required="true" readOnly="false" hidden="false" value=""
  name="rsNameSSN" id="rsNameSSN" label="Retrieval Key Field" 
  labelClass="labelRequired"  enclosingStyle="padding-bottom:4px;" 
  title="Which key field to use to identify directory records"
  valueList="Name,SSN" displayList="Name,SSN" originalValue="Name"
  onclick="zenPage.changeType('rsNameSSN');"
	/>
<spacer width="10" />
<text name="txKeyVal" id="txKeyVal" label="Key Value" labelClass="labelRequired" size="21" 
          title="Enter a key value to use in identifying which directory records to work with. May contain wildcards * and ?." />
</hgroup>
<hgroup>
<radioSet required="true" readOnly="false" hidden="false" value=""
  name="rsField" id="rsField" label="Retrieve Field(s)" 
  labelClass="labelRequired"  enclosingStyle="padding-bottom:4px;" 
  title="Which field value to retrieve"
  valueList="All,Single" displayList="All,Single" originalValue="All"
  onclick="zenPage.changeType('rsField');"
	/>
<spacer width="10" />
<text name="txField" id="txField" label="Field Name" labelClass="labelRequired" size="21" hidden="true"
          title="Enter a field name to retrieve the value of (case insensitive)." />
</hgroup>
<button controlClass="commandButton" id="btnRetrieve" caption="Retrieve" onclick="zenPage.retrieveRec();"
		title="Retrieve directory records matching the above retrieval criteria" />
</form>
</vgroup>
</pane>
}

XData paneInfo [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<label name="txValue" id="txValue" label="Retrieved Value" labelClass="labelRequired" controlClass="labelRequired"
          title="Value retrieved for a single-record, single-field query." />
<html id="htmlInfo" OnDrawContent="DrawInfoTable" />
</pane>
}

XData paneDetails [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane>
<form name="fmDetails" id="fmDetails" layout="vertical" cellStyle="padding: 2px 10px; font-size:0.8em;">
<html id="htmlDetails" OnDrawContent="DrawDetailsTable" />
<hgroup>
<button controlClass="commandButton" id="btnUpdate" caption="Update" onclick="zenPage.updateRec();"
		title="Update the current directory record using the above field values" />
<button controlClass="commandButton" id="btnDelete" caption="Delete" onclick="zenPage.deleteRec();"
		title="Delete the current directory record" />
<button controlClass="commandButton" id="btnCreate" caption="Create" onclick="zenPage.createRec();"
		title="Create a new directory record using the above field values" />
</hgroup>
</form>
</pane>
}

Method DrawInfoTable(pID As %String) As %Status
{
 &html<<table id="infoTable" border="1" style="cursor:default;visibility:hidden;" title="Click a row to select">
	<thead>
		<tr>
			<th id="infoKey">Key</th>
			<th id="infoVal">Value</th>
		</tr>
 	</thead>
 	<tbody id="infoBody">
 	</tbody>
	</table>

	<table id="recordsTable" border="1" style="cursor:default;visibility:hidden;" title="Click a row to select">
	<thead>
		<tr>
			<th id="recordsName">Name</th>
			<th id="recordsSSN">SSN</th>
		</tr>
	</thead>
	<tbody id="recordsBody">
	</tbody>
	</table>>
	Quit $$$OK
}

Method DrawDetailsTable(pID As %String) As %Status
{
 &html<<table id="detailTable" border="1">
	<thead>
		<tr>
			<th id="detailProp">Property</th>
			<th id="detailVal">Value</th>
		</tr>
	</thead>
	<tbody id="detailBody">
	</tbody>
	</table>>
	Quit $$$OK
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	zen('rsPersonEmployee').setValue('Person');
	zen('rsNameSSN').setValue('Name');
	zen('rsField').setValue('All');
}

ClientMethod retrieveRec() [ Language = javascript ]
{
	var type = zen('rsPersonEmployee').getValue();
	var key = zen('rsNameSSN').getValue();
	var val = zen('txKeyVal').getValue();
	var field = zen('txField').getValue();
	if ('All' == zen('rsField').getValue()) field='*';

	if ('' == val) { alert($$$Text('You must enter a key value. You may use wildcards * and ?.')); return }
	if ('' == field) { alert($$$Text('You must enter a field value or select "All".')); return }

	var result = zenPage.DoRetrieve(type,key,val,field);
	var parm = zen('riId');
	var ids = result.split('|');
	var id = parseInt(ids[1]);
	if (id > 0) {
		parm.value = id;
		/*zenPage.currRespId = id;
		zenPage.currType = type;
		zenPage.currKey = key;
		zenPage.currKeyVal = val;
		zenpage.currField = field;*/
	} else {
		parm.value = '';
		var err = result;
		if (err && ('' != err)) alert(err);
	}
	zenPage.refresh();
}

ClientMethod updateRec() [ Language = javascript ]
{
	var key = zenPage.findKey();
	if ('' == key) return;
	var keyval = key.split('=');
	var obj = zenPage.getDetailObj();
	if (!obj) return;
	var type = zen('rsPersonEmployee').getValue();
	var result = zenPage.DoUpdate(type,keyval[0],keyval[1],obj);
	var parm = zen('riId');
	var ids = result.split('|');
	var id = parseInt(ids[1]);
	var updid = parseInt(ids[0]);
	if (updid > 0) {
		parm.value = id;
		zenPage.refresh();
		alert('record '+updid+' updated');
	} else {
		parm.value = '';
		var err = result;
		if (err && ('' != err)) alert(err);
	}
}

ClientMethod deleteRec() [ Language = javascript ]
{
	var key = zenPage.findKey();
	if ('' == key) return;
	var keyval = key.split('=');
	var result = zenPage.DoDelete(keyval[0],keyval[1]);
	var parm = zen('riId');
	var ids = result.split('|');
	var id = parseInt(ids[1]);
	var count = parseInt(ids[0]);
	if (count > 0) {
		if (count == 1) { alert('one record deleted'); }
		else { alert(count + ' RECORDS DELETED'); }
		parm.value = id;
		zenPage.refresh();
	} else {
		parm.value = '';
		var err = result;
		if (err && ('' != err)) alert(err);
	}
}

ClientMethod createRec() [ Language = javascript ]
{
	var key = zenPage.findKey();
	if ('' == key) return;
	var keyval = key.split('=');
	var obj = zenPage.getDetailObj()
	if (!obj) return;
	var type = zen('rsPersonEmployee').getValue();
	// An Employee is a Person, but setting one of these properties for a Person object will cause Property error
	if ((type = "Person") && ((obj.Company) || (obj.Title) || (obj.Salary) || (obj.Notes) || (obj.Picture))){
		type = "Employee"
	}
	var result = zenPage.DoCreate(type,keyval[0],keyval[1],obj);
	var parm = zen('riId');
	var ids = result.split('|');
	var id = parseInt(ids[1]);
	var newid = parseInt(ids[0]);
	if (newid > 0) {
		parm.value = id;
		zenPage.refresh();
		alert('Create succeeded, new id=' + newid);
	} else {
		parm.value = '';
		var err = result;
		if (err && ('' != err)) alert(err);
	}
}

ClientMethod getDetailObj() [ Language = javascript ]
{
	var obj = new zenProxy();
	var dbod = self.document.getElementById('detailTable').children[1];
	var numProps = 0;
	for (var rownum in dbod.rows) {
		var row=dbod.rows[rownum];
		if (!row.cells)continue;
		var prop = row.cells[0].textContent;
		var val = row.cells[1].children[0].value;
		obj[prop] = val;
		numProps = numProps + 1;
	}
	if (numProps > 0) return obj;
	alert('No directory record selected');
	return null;
}

ClientMethod findKey() [ Language = javascript ]
{
	var dbod = self.document.getElementById('detailTable').children[1];
	if (dbod.rows.length===0) {
		alert('No record to modify.');
		return '';	
	}
	var name = '';
	for (var rownum in dbod.rows) {
		var row=dbod.rows[rownum];
		if (!row.cells) continue;
		var prop = row.cells[0].textContent;
		if (prop.toLowerCase() == 'ssn') {
			var ssn = row.cells[1].children[0].value;
			if ('' != ssn) return 'ssn='+ssn;
		}
		if (prop.toLowerCase() == 'name') {
			name = row.cells[1].children[0].value;
			if (name != '') return 'name='+name;
		}
	}
	alert('Can\'t find key in current directory record');
	return '';
}

ClassMethod DoRetrieve(type As %String, key As %String, val As %String, field As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).CreateBusinessService("EnsLib.Testing.Service",.tService)  Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)
	Set tTestRequest = ##class(EnsLib.Testing.Request).%New()  $$$ASSERT($IsObject(tTestRequest))
	Set tTestRequest.Target = "Demo.REST.DirectoryOperation"
	Set tTestRequest.SyncCall = 1
	Set tRequest=##class(Demo.REST.DirectoryRequest).%New()
	Set tRequest.Command = "GET"
	// An Employee is a Person, but if don't look in Employee data, will get Property error for these properties
	Set:$Case(field,"Company":1,"Title":1,"Salary":1,"Notes":1,"Picture":1,:0) type = "Employee"
	Set tRequest.Type = $ZConvert(type,"L")
	Set tRequest.Key = $ZConvert(key,"L")
	Set tRequest.KeyValue = val
	Set tRequest.Field = $S("*"=field:"",1:field)
	Set tTestRequest.Request = tRequest
	Set tSC = tService.ProcessInput(tTestRequest,.tResponse)
	Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)

	#; display response
	Quit $S($$$IsdefObject(tResponse):1_"|"_tResponse.%Id(),1:"No Response from Demo.REST.DirectoryOperation GET")
}

ClassMethod DoUpdate(type As %String, key As %String, val As %String, obj As %ZEN.proxyObject) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).CreateBusinessService("EnsLib.Testing.Service",.tService)  Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)
	Set tTestRequest = ##class(EnsLib.Testing.Request).%New()  $$$ASSERT($IsObject(tTestRequest))
	Set tTestRequest.Target = "Demo.REST.DirectoryOperation"
	Set tTestRequest.SyncCall = 1
	Set tRequest=##class(Demo.REST.DirectoryRequest).%New()
	Set tRequest.Command = "POST"
	Set tRequest.Type = $ZConvert(type,"L")
	Set tRequest.Key = $ZConvert(key,"L")
	Set tRequest.KeyValue = val
	Set tSC=##class(Ens.Util.JSON).ObjectToJSONStream(obj,tRequest.Body)
	If $$$ISOK(tSC) {
		Set tTestRequest.Request = tRequest
		Set tSC = tService.ProcessInput(tTestRequest,.tResponse)
	}
	Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)

	#; display response
	Quit $S($$$IsdefObject(tResponse):tResponse.Value_"|"_tResponse.%Id(),1:"No Response from Demo.REST.DirectoryOperation POST")
}

ClassMethod DoDelete(key As %String, val As %String) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).CreateBusinessService("EnsLib.Testing.Service",.tService)  Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)
	Set tTestRequest = ##class(EnsLib.Testing.Request).%New()  $$$ASSERT($IsObject(tTestRequest))
	Set tTestRequest.Target = "Demo.REST.DirectoryOperation"
	Set tTestRequest.SyncCall = 1
	Set tRequest=##class(Demo.REST.DirectoryRequest).%New()
	Set tRequest.Command = "DELETE"
	Set tRequest.Type = "person"
	Set tRequest.Key = $ZConvert(key,"L")
	Set tRequest.KeyValue = val
	Set tTestRequest.Request = tRequest
	Set tSC = tService.ProcessInput(tTestRequest,.tResponse)
	Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)

	#; display response
	Quit $S($$$IsdefObject(tResponse):tResponse.Value_"|"_tResponse.%Id(),1:"No Response from Demo.REST.DirectoryOperation DELETE")
}

ClassMethod DoCreate(type As %String, key As %String, keyvalue As %String, obj As %ZEN.proxyObject) As %ZEN.Datatype.string [ ZenMethod ]
{
	Set tSC = ##class(Ens.Director).CreateBusinessService("EnsLib.Testing.Service",.tService)  Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)
	Set tTestRequest = ##class(EnsLib.Testing.Request).%New()  $$$ASSERT($IsObject(tTestRequest))
	Set tTestRequest.Target = "Demo.REST.DirectoryOperation"
	Set tTestRequest.SyncCall = 1
	Set tRequest=##class(Demo.REST.DirectoryRequest).%New()
	Set tRequest.Command = "PUT"
	Set tRequest.Type = $ZConvert(type,"L")
	Set tRequest.Key = key
	Set tRequest.KeyValue = keyvalue
	Set tSC=##class(Ens.Util.JSON).ObjectToJSONStream(obj,tRequest.Body)
	If $$$ISOK(tSC) {
		Set tTestRequest.Request = tRequest
		Set tSC = tService.ProcessInput(tTestRequest,.tResponse)
	}
	Quit:$$$ISERR(tSC) $$$StatusDisplayString(tSC)

	#; display response
	Quit $S($$$IsdefObject(tResponse):tResponse.Value_"|"_tResponse.%Id(),1:"No Response from Demo.REST.DirectoryOperation PUT")
}

ClientMethod refresh() [ Language = javascript ]
{
	var json = this.getComponentById('jpResponseInfo');
	json.reloadContents();
	var resp = json.getContentObject();
	var ctl;
	ctl = zen('txURL');
	ctl.setValue(resp ? resp.RequestURL : '');

	ctl = zen('txRawResponse');
	ctl.setValue(resp ? resp.RawResponse : '');

	var ctl=zen('txValue')
	ctl.setValue(resp ? resp.Value : '');

	var records = '';
	var rows = '';
	var i = 0;
	if (resp) {
		var showing = this.getComponentById('rsField').getValue();
		for (var prop in resp.Properties) {
			i = i + 1;
			if (showing == "All") {
				var val = resp.Properties[prop];
				rows = rows+'<tr onclick="zenPage.propClick(\''+prop+'\');"><td>'+prop+'</td><td>'+val+'</td></tr>';
			} else {
				var parts = resp.Properties[prop].split(':');
				var key = parts[0];
				parts[0] = null;
				rows = rows+'<tr onclick="zenPage.propClick(\''+prop+'\');"><td>'+key+'</td><td>'+parts.join(':')+'</td></tr>';
			}
		}

		for (var num in resp.Records) {
			var rec = resp.Records[num];
			records = records+'<tr onclick="zenPage.recClick(\''+num+'\');"><td>'+rec.Name+'</td><td>'+rec.SSN+'</td></tr>';
		}
	}
	ctl.setHidden(rows != '' || records != '');
	self.document.getElementById('infoTable').style.visibility = (rows == '') ? "hidden" : "visible";
	self.document.getElementById('recordsTable').style.visibility = (records == '') ? "hidden" : "visible";

	var bod = self.document.getElementById('infoTable').children[1];
	zenPage.setInnerHTML(bod,rows);

	var bod2 = self.document.getElementById('recordsTable').children[1];
	zenPage.setInnerHTML(bod2, records);

	var sctl = zen('txSession');
	sctl.setValue(resp ? resp.SessionId : '');
	//Set ..%GetComponentById("lblSessionId").value = "<b>"_$$$Text("Session Id:")_"</b> "_tSessionId_" &nbsp;&nbsp;<a href=""#"" class=""ribbonSortOption"" style=""font-size:10pt"" onClick=""zenPage.launchPopupWindow(zenLink('EnsPortal.VisualTrace.zen?SESSIONID="_tSessionId_"'),'Trace','status=no,scrollbars=auto,resizable=yes,top=200,left=200,width=1000,height=800');"" title="""_$$$Text("Display the Visual Trace diagram for this REST service invocation")_""">"_$$$Text("Visual Trace")_"</a>"

	var dbod = self.document.getElementById('detailTable').children[1];
	zenPage.setInnerHTML(dbod,'');
}

/// Allow innerHTML value to be edited even in IE
ClientMethod setInnerHTML(body, html) [ Language = javascript ]
{
	var temp = document.createElement('div');
	temp.innerHTML = '<table><tbody>' + html + '</tbody></table>';
	body.parentNode.replaceChild(temp.firstChild.firstChild, body);
}

ClientMethod propClick(prop) [ Language = javascript ]
{
	var json = this.getComponentById('jpResponseInfo');
	var resp = json.getContentObject();
	var rows='';
	if (parseInt(prop) == prop) {
		var parts = resp.Properties[prop].split(':');
		var key = parts[0];
		var vals;
		vals = key.split('=');
		rows = rows+'<tr><td>'+vals[0]+'</td><td><input type="text" value=\''+vals[1]+'\'/></td></tr>';
		vals = parts[1].split('=');
		rows = rows+'<tr><td>'+vals[0]+'</td><td><input type="text" value=\''+vals[1]+'\'/></td></tr>';
	}
	else {
		var val;
		val = resp.Properties[prop];
		rows = rows+'<tr><td>'+prop+'</td><td><input type="text" value=\''+val+'\'/></td></tr>';
	}
	var bod = self.document.getElementById('detailTable').children[1];
	zenPage.setInnerHTML(bod,rows);
}

ClientMethod recClick(num) [ Language = javascript ]
{
	var json = this.getComponentById('jpResponseInfo');
	var resp = json.getContentObject();
	var rows='';
	var rec = resp.Records[num];
	for (var prop in rec) {
		if ('_' == prop[0]) continue;
		rows = rows+'<tr><td>'+prop+'</td><td><input type="text" value=\''+rec[prop]+'\'/></td></tr>';
	}
	var bod = self.document.getElementById('detailTable').children[1];
	zenPage.setInnerHTML(bod,rows);
}

ClassMethod GetResponseInfo(ByRef pParameters, Output pObj) As %Status
{
	Set tSC=$$$OK, pObj=$$$NULLOREF
	try {
		Set tResponseId = $G(pParameters("responseId"))
		If tResponseId {
			Set pObj=##class(Demo.REST.DirectoryResponse).%OpenId(tResponseId,,.tSC)  Quit:$$$ISERR(tSC)
		}
	} catch {
		Set tSC = $$$SystemError
	}
	Quit tSC
}

/// What to do when the user selects a new radio button value.
ClientMethod changeType(id) [ Language = javascript ]
{
	var ctl = zen(id);
	var val = ctl.getValue();
	if (id == 'rsField') {
		var tx = zen('txField');
		tx.setHidden((val=='All') ? 1 : 0);
	}
}

/// Get the (localized) title string for the page.
Method %OnGetTitle() As %String
{
	Quit ..%OnGetPageName()
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String
{
	Set txt = $$$Text(..#PAGENAME)
	Quit txt
}

/// Decorate the page.
Method %OnAfterCreatePage() As %Status
{
	Do ##super()
	
	Set tSC = $$$OK
	
	Quit tSC
}

}
