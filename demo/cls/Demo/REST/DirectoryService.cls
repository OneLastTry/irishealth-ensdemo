/// This is a sample REST service implementing a directory of Person and Employee records. Not every Person is an Employee.
/// The CRUD (Create,Retrieve,Update,Delete) interface is implemented via the REST/HTTP commands PUT,GET,POST,and DELETE respectively.
/// Records of interest may be retrieved via type and key fields "name" and "ssn".  Wildcards containing * and ? are supported.
/// The resulting HTTP body of a successful GET query may be a partially or fully populated JSON object, depending on the field requested, or a JSON array of such JSON objects if a wildcard was used.
/// Example REST URLs:
/// GET /directory/employee/name/Q*/salary
/// GET /directory/employee/name/Quentin, Fred A.
/// GET /directory/employee/ssn/123-45-6789/*
Class Demo.REST.DirectoryService Extends EnsLib.REST.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:personType" Method="PUT" Call="createPerson"/>
<Route Url="/:personType/:keyfield/:keyval/:getfield" Method="GET" Call="retrievePerson"/>
<Route Url="/:personType/:keyfield/:keyval" Method="GET" Call="retrievePerson"/>
<Route Url="/:personType/:keyfield/:keyval" Method="POST" Call="updatePerson"/>
<Route Url="/:personType/:keyfield/:keyval" Method="DELETE" Call="deletePerson"/>
</Routes>
}

Parameter EnsServicePrefix = "|directory";

/// Create or replace
Method createPerson(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pPersonType As %String) As %Status
{
	Set tType=$ZConvert(pPersonType,"L")  Quit:$Case(tType,"employee":0, "person":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory type "_..#EnsServicePrefix_"/"_tType_"/ not supported.")
	Set $E(tType)=$ZConvert($E(tType),"U")
	Set tNS=$Namespace

	Set tSC=..JSONStreamToObject(pInput,.tProxy) Quit:$$$ISERR(tSC) tSC
	Do tProxy.%CopyToArray(.tRec)
	ZNSpace "SAMPLES"
	try {
		Set tObj=$classmethod("Sample."_tType,"%New")  Quit:$$$ISERR(tSC)
		Set tSC=..updateObject(tObj,.tRec)  Quit:$$$ISERR(tSC)
		Set tSC=tObj.%Save()  Quit:$$$ISERR(tSC)
		Set tID=tObj.%Id()
		Kill tRS
		ZNSpace tNS
		Do pOutput.Write(tID)
	} catch {
		Kill tRS
		ZNSpace tNS
		Set tSC=$$$SystemError
	}
	Kill tRS
	ZNSpace tNS

	// return 201 if successfully created
	Do:$$$ISOK(tSC) pOutput.SetAttribute("ResponseCode","201 Created")
	Quit tSC
}

/// Retrieve
Method retrievePerson(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pPersonType As %String, pKeyField As %String, pKeyVal As %String, pGetField As %String = "") As %Status
{
	Set tType=$ZConvert(pPersonType,"L")  Quit:$Case(tType,"employee":0, "person":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory type "_..#EnsServicePrefix_"/"_tType_"/ not supported.")
	Set $E(tType)=$ZConvert($E(tType),"U")
	Set tKeyIn=pKeyField, tKey=$ZConvert(tKeyIn,"L")  Quit:$Case(tKey,"name":0, "ssn":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory key "_..#EnsServicePrefix_"/"_tType_"/"_tKey_" not supported.")
	Set tKeyVal=$Replace($ZConvert(pKeyVal,"I","URL"),"'","''")
	Set tField=pGetField  Set:""=tField tField="*"  Quit:tField["," $$$ERROR($$$EnsErrGeneral,"Commas not allowed in selection field; found: .../"_tField)
	Set tNS=$Namespace

	Set tKeyWild=$Translate(pKeyVal,"*?","%_")
	Do:tKeyWild'=pKeyVal pOutput.Write("[")
	ZNSpace "SAMPLES"
	try {
		Set tSel=$S("*"=tField:"ID",1:tField)
		Set tSQL="SELECT "_tSel_$S("*"=tField||(tKey=tSel):"", 1:","_tKey)_$Case("ID",tKey:"",tSel:"",:",ID")_" FROM Sample."_tType_" WHERE "_tKey_" LIKE '"_tKeyWild_"'"
		Set tRS=##class(%ResultSet).%New()
		Set tSC=tRS.Prepare(tSQL)  Quit:$$$ISERR(tSC)
		Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC)
		Set tFirst=1
		Set tOut=##class(%IO.StringStream).%New()
		While tRS.Next(.tSC) && $$$ISOK(tSC) {
			#; first normalize the case of the key and sel property names
			If tFirst {
				Set k="" For { Set k=$O(tRS.Data(k))  Quit:""=k
					If $ZConvert(k,"L")=$Zconvert(tSel,"L") Set tSelN=k
					If $ZConvert(k,"L")=$Zconvert(tKey,"L") Set tKeyN=k
				}
			}
			If $Case(tSelN, "Company":1, "Notes":1, "Home":1, "Office":1, :0) {
				Set tVal=tRS.Data("ID")
				Set tObj=$classmethod("Sample."_tType,"%OpenId",tVal,,.tSC)  Quit:$$$ISERR(tSC)
				Set tVal=$property(tObj,tSelN)
				Set tSelX = $Case(tSelN, "Home":"Addr", "Office":"Addr", :tSelN)
				Set tVal=$Case(tSelX, "Company":tVal.Name, "Notes":tVal.Read(), "Addr":tVal.Street_", "_tVal.City_" "_tVal.State_" "_tVal.Zip, :tVal)
			} Else {
				Set tVal=tRS.Data(tSelN)
			}
			If "*"=tField {
				Set tObj=$classmethod("Sample."_tType,"%OpenId",tVal,,.tSC)  Quit:$$$ISERR(tSC)
				Set tProxyObj=..buildProxyObj(tObj)
				Do tOut.Write($S(tFirst:"",1:","))
				Set tSC=..ObjectToJSONStream(tProxyObj,.tOut)
			} Else {
				Set:tKeyN'=tSelN tKeyFound=tRS.Data(tKeyN)
				Do tOut.Write($S(tFirst:"",1:",")_"{"_$S(tKeyN=tSelN:"",1:""""_tKeyIn_""":"""_tKeyFound_""", ")_""""_tSel_""":"""_tVal_"""}"_$C(13,10))
			}
			Set tFirst=0
			ZNSpace tNS
			Do tOut.Rewind()  Set tSC1=pOutput.Write(tOut.Read())  Do tOut.Clear()  Set:$$$ISOK(tSC) tSC=tSC1  Quit:$$$ISERR(tSC)
			ZNSpace "SAMPLES"
		} Quit:$$$ISERR(tSC)
		Do:tKeyWild'=tKeyVal pOutput.Write("]"_$C(13,10))
	} catch {
		Kill tRS
		ZNSpace tNS
		Set tSC=$$$SystemError
	}
	Kill tRS
	ZNSpace tNS
	Do:$$$ISOK(tSC) pOutput.SetAttribute("Content-Type","application/json")
	Quit tSC
}

/// Update: For given service, replaces primary Person or Person with given name
Method updatePerson(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pPersonType As %String, pKeyField As %String, pKeyVal As %String) As %Status
{
	Set tType=$ZConvert(pPersonType,"L")  Quit:$Case(tType,"employee":0, "person":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory type "_..#EnsServicePrefix_"/"_tType_"/ not supported.")
	Set $E(tType)=$ZConvert($E(tType),"U")
	Set tKeyIn=pKeyField, tKey=$ZConvert(tKeyIn,"L")  Quit:$Case(tKey,"name":0, "ssn":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory key "_..#EnsServicePrefix_"/"_tType_"/"_tKey_" not supported.")
	Set tKeyVal=$Replace($ZConvert(pKeyVal,"I","URL"),"'","''")
	Set tNS=$Namespace

	Set tSC=..JSONStreamToObject(pInput,.tProxy) Quit:$$$ISERR(tSC) tSC
	Do tProxy.%CopyToArray(.tRec)
	ZNSpace "SAMPLES"
	try {
		Set tSQL="SELECT ID FROM Sample."_tType_" WHERE "_tKey_" = '"_tKeyVal_"'"
		Set tRS=##class(%ResultSet).%New()
		Set tSC=tRS.Prepare(tSQL)  Quit:$$$ISERR(tSC)
		Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC)
		If 'tRS.Next(.tSC) || $$$ISERR(tSC) Set:$$$ISOK(tSC) tSC=$$$ERROR($$$EnsErrGeneral,"No "_tType_" record found with key field "_tKey_" = '"_tKeyVal_"'")  Quit

		Set tID=tRS.Data("ID")
		If +tID'=tID Set tSC=$$$ERROR($$$EnsErrGeneral,"No "_tType_" ID found for key field "_tKey_" = '"_tKeyVal_"'")  Quit
		Kill tRS

		Set tObj=$classmethod("Sample."_tType,"%OpenId",tID,,.tSC)  Quit:$$$ISERR(tSC)
		Set tSC=..updateObject(tObj,.tRec,tKey,tKeyVal)  Quit:$$$ISERR(tSC)
		Set tSC=$method(tObj,"%Save")  Quit:$$$ISERR(tSC)

		Kill tRS
		ZNSpace tNS
		Do pOutput.Write(tID)
	} catch {
		Kill tRS
		ZNSpace tNS
		Set tSC=$$$SystemError
	}
	Kill tRS
	ZNSpace tNS
	Do:$$$ISOK(tSC) pOutput.SetAttribute("Content-Type","application/json")
	Quit tSC
}

Method deletePerson(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pPersonType As %String, pKeyField As %String, pKeyVal As %String) As %Status
{
	Set tType=$ZConvert(pPersonType,"L")  Quit:$Case(tType,"employee":0, "person":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory type "_..#EnsServicePrefix_"/"_tType_"/ not supported.")
	Set $E(tType)=$ZConvert($E(tType),"U")
	Set tKeyIn=pKeyField, tKey=$ZConvert(tKeyIn,"L")  Quit:$Case(tKey,"name":0, "ssn":0, :1) $$$ERROR($$$EnsErrGeneral,"Directory key "_..#EnsServicePrefix_"/"_tType_"/"_tKey_" not supported.")
	Set tKeyVal=$Replace($ZConvert(pKeyVal,"I","URL"),"'","''")
	Set tNS=$Namespace

	ZNSpace "SAMPLES"
	try {
		Set tSQL="DELETE FROM Sample."_tType_" WHERE "_tKey_" = '"_tKeyVal_"'"
		Set tRS=##class(%ResultSet).%New()
		Set tSC=tRS.Prepare(tSQL)  Quit:$$$ISERR(tSC)
		Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC)
		Set tRowCount=tRS.%ROWCOUNT
		Kill tRS
		ZNSpace tNS
		Do pOutput.Write(tRowCount)
	} catch {
		Kill tRS
		ZNSpace tNS
		Set tSC=$$$SystemError
	}
	Kill tRS
	ZNSpace tNS

	// return 204 if successfully deleted
	Do:$$$ISOK(tSC) pOutput.SetAttribute("ResponseCode","204 No Content")
	Quit tSC
}

ClassMethod updateObject(pObj As %RegisteredObject, ByRef pArray, pKeyField As %String = "", pKeyVal = "xxx") As %Status [ Internal ]
{
	Set tSC=$$$OK, tDOB=0, tAge=0, tHasKey=0, tKFU=$ZCVT(pKeyVal,"U")
	Set prop="" For { Set tVal="" Set prop=$O(pArray(prop),1,tVal)  Quit:""=prop  Set propU=$ZConvert(prop,"U")
		If propU=pKeyField && (tKFU'=tVal) Set tSC=$$$ERROR($$$EnsErrGeneral,"Attempt to assign key value "_pKeyField_" ='"_tVal_"' where existing value = '"_pKeyVal_"'")  Quit
		Set:$Case(propU,"SSN":""'=tVal,"NAME":""'=tVal,:0) tHasKey=tHasKey+1
		Set:0=tAge&&("AGE"=propU) tAge=tVal
		Continue:$Case(propU,"ID":1,"AGE":1,:("_"=$E(prop)))
		If propU="COMPANY" {
			If ""=tVal {
				Set tCo=$$$NULLOREF
			} Else {
				&sql()
				Set tSQL="SELECT ID FROM Sample.Company WHERE Name = '"_tVal_"'"
				Set tRS=##class(%ResultSet).%New()
				Set tSC=tRS.Prepare(tSQL)  Quit:$$$ISERR(tSC)
				Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC)
				If 'tRS.Next(.tSC) || $$$ISERR(tSC) Set:$$$ISOK(tSC) tSC=$$$ERROR($$$EnsErrGeneral,"No company found named '"_tVal_"'")  Quit
				Set tCoID=tRS.Data("ID")
				Set tCo=##class(Sample.Company).%OpenId(tCoID)
				If '$IsObject(tCo) Set tSC=$$$ERROR($$$EnsErrGeneral,"Couldn't open Company object '"_tVal_"' with ID="_tCoID)  Quit
			}
			Set pObj.Company=tCo
			Kill tCo
		} ElseIf propU="SPOUSE" {
			If ""=tVal {
				Set tSpouse=$$$NULLOREF
			} Else {
				&sql()
				Set tSQL="SELECT ID FROM Sample.Person WHERE Name = '"_tVal_"'"
				Set tRS=##class(%ResultSet).%New()
				Set tSC=tRS.Prepare(tSQL)  Quit:$$$ISERR(tSC)
				Set tSC=tRS.Execute()  Quit:$$$ISERR(tSC)
				If 'tRS.Next(.tSC) || $$$ISERR(tSC) Set:$$$ISOK(tSC) tSC=$$$ERROR($$$EnsErrGeneral,"No spouse person found named '"_tVal_"'")  Quit
				Set tSpouseID=tRS.Data("ID")
				Set tSpouse=##class(Sample.Person).%OpenId(tSpouseID)
				If '$IsObject(tSpouse) Set tSC=$$$ERROR($$$EnsErrGeneral,"Couldn't open spouse Person object '"_tVal_"' with ID="_tSpouseID)  Quit
			}
			Set pObj.Spouse=tSpouse
			Kill tSpouse
		} ElseIf propU="NOTES" {
			Set tStream=$property(pObj,prop)
			Do tStream.Clear()
			Set tSC=tStream.Write(tVal)
		} ElseIf prop["." {
			Set tChild=$property(pObj,$P(prop,"."))
			If $IsObject(tChild) Set $property(tChild,$P(prop,".",2))=tVal
		} Else {
			Set:0=tDOB&&("DOB"=propU) tDOB=1, tVal=$P($ZDTH(tVal,3),",")
			Set $property(pObj,prop)=tVal
		}
	}
	Quit:""=pKeyField&&(tHasKey<2) $$$ERROR($$$EnsErrGeneral,"Can't create object unless Name and SSN fields have values")
	Set:tAge&&(0=tDOB) pObj.DOB=($P($H,",")-(tAge*365))
	Quit tSC
}

/// Normalize the Person or Employee info by copying its properties to a proxy object in a selective way
ClassMethod buildProxyObj(pObj As %Persistent) [ Internal ]
{
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.ID=pObj.%Id()
	Set tProxy.Name=pObj.Name
	Set tProxy.Age=pObj.Age
	Set tProxy.DOB=$ZDateTime(pObj.DOB,3)
	Set tProxy.SSN=pObj.SSN
	Set tProxy.FavoriteColors=pObj.FavoriteColors
	Set tProxy.Spouse=pObj.Spouse.Name
	Set tProxy.Home=..buildProxyAddr(pObj.Home)
	Set tProxy.Office=..buildProxyAddr(pObj.Office)
	If pObj.%IsA("Sample.Employee") {
		Set tProxy.Company=pObj.Company.Name
		Set tProxy.Notes=$S($IsObject(pObj.Notes):pObj.Notes.Read(),1:"")
	}
	Quit tProxy
}

ClassMethod buildProxyAddr(pObj As %SerialObject) [ Internal ]
{
	Set tProxy = ##class(%ZEN.proxyObject).%New()
	Set tProxy.Street=pObj.Street
	Set tProxy.City=pObj.City
	Set tProxy.State=pObj.State
	Set tProxy.Zip=pObj.Zip
	Quit tProxy
}

/// Control the type and content of error returned to the REST caller
ClassMethod OnErrorStream(pStatus As %Status)
{
 	Set tStream = ##class(%GlobalBinaryStream).%New()  $$$ASSERT($IsObject(tStream))
	Do tStream.Write($ZConvert($$$StatusDisplayString(pStatus)_$C(13,10),"O","UTF8"))
	Set tStream.Attributes("Content-Type")=" text/plain; charset=""UTF-8"""
	Set tStream.Attributes("ResponseCode")="500 Internal Server Error"
 	Quit tStream
}

}
