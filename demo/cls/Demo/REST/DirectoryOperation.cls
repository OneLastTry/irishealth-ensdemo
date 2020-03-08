/// This business operation accepts a request for Person or Employee directory services. The request specifies the action to be taken and any additional parameters needed.
/// Then the remote REST service is invoked using the appropriate HTTP command, URL, and JSON formatted payload.  The REST HTTP response is then parsed and the values are returned in a response object.
/// This demonstrates automatically and manually constructing and sending a JSON payload, and retrieving and parsing a JSON object or collection response.
/// It also demonstrates use of the four CRUD operations in the RESTful HTTP context: Create/PUT, Retrieve/GET, Update/POST, and Delete/DELETE.
Class Demo.REST.DirectoryOperation Extends EnsLib.REST.Operation
{

Method OnMessage(pRequest As Demo.REST.DirectoryRequest, Output pResponse As Demo.REST.DirectoryResponse) As %Status
{
	try {
		If (pRequest.Type="") || (pRequest.Key="") || (pRequest.KeyValue="") {
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Fields Type, Key and KeyValue are mandatory")
			Quit
		}
		Set tCmd=$ZConvert(pRequest.Command,"U")
		If tCmd = "GET" {
			Set tURL=..Adapter.URL_"/"_pRequest.Type_"/"_pRequest.Key_"/"_$$$URLENCODE(pRequest.KeyValue)_$S(""=pRequest.Field:"",1:"/"_pRequest.Field)
			Set tSC=..Adapter.GetURL(tURL,.tHttpResponse)
			Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
			Set tSC1 = pRequest.NewResponse(.pResponse)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Set pResponse.SessionId=..%RequestHeader.SessionId
			Set pResponse.RequestURL="Get "_tURL
			Quit:$$$ISERR(tSC)
			If $$$IsdefObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size {
				For i=0:1:31 { Continue:$Case(i,9:1,10:1,13:1,:0)  Set tArr($I(tArr))=$C(i), tArr($I(tArr))="" } ; strip control chars from raw stream copy
				Do ##class(%IO.MetaCharacterStream).%New(tHttpResponse.Data).CopyReplaceArray(pResponse.RawResponse,,,,,,,"IO",.tSC,.tArr)
				If pRequest.KeyValue=$TR(pRequest.KeyValue,"*?") {
					Set tSC=..JSONStreamToObject(tHttpResponse.Data,.tProxy)  Quit:$$$ISERR(tSC)
					Do tProxy.%CopyToArray(.tRec)
					If $Case(pRequest.Field, "":1, "*":1, :0) {
						Do ..getPersonProps(.tRec,pResponse.Properties)
						$$$TRACE("Got "_pResponse.Properties.Count()_" property records")
					} Else {
						$$$ASSERT($G(tRec(pRequest.Key))=pRequest.KeyValue)
						Kill tRec(pRequest.Key)
						Set tVal=$G(tRec(pRequest.Field),$C(0))
						Kill tRec(pRequest.Field)
						$$$ASSERT(tVal'=$C(0)&&'$D(tRec)) ; should not have returned any other fields
						Set pResponse.Value=tVal
						$$$TRACE("Got "_pRequest.Field_" = "_tVal_" for key "_pRequest.Key)
					}
				} Else {
					Set tSC=..JSONStreamToObjectArray(tHttpResponse.Data,.tProxyArray)  Quit:$$$ISERR(tSC)
					For i=1:1:tProxyArray { Set tProxy=tProxyArray(i)
						Kill tRec
						Do tProxy.%CopyToArray(.tRec)
						If $Case(pRequest.Field, "":1, "*":1, :0) {
							Set rec=##class(%ArrayOfDataTypes).%New()
							Do ..getPersonProps(.tRec,rec)
							Do pResponse.Records.SetAt(rec,i)
						} Else {
							Set tVal=$G(tRec(pRequest.Field),$C(0))
							Kill tRec(pRequest.Field)
							$$$ASSERT(tVal'=$C(0)) ; should not have returned other fields
							Do pResponse.Properties.SetAt(pRequest.Key_"="_$S($ZCVT(pRequest.Field,"L")=$ZCVT(pRequest.Key,"L"):tVal,1:tRec(pRequest.Key))_" : "_pRequest.Field_"="_tVal,i)
						}
					}
					$$$TRACE("Got "_tProxyArray_" records")
				}
			} Else { /* Set tSC=$$$ERROR($$$EnsErrGeneral,"No response data")  Quit */ }
		} ElseIf tCmd = "POST" {
			Set tURL=..Adapter.URL_"/"_pRequest.Type_"/"_pRequest.Key_"/"_$$$URLENCODE(pRequest.KeyValue)
			Set tSC=..Adapter.PostURL(tURL,.tHttpResponse,"",pRequest.Body)
			Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
			Set tSC1=pRequest.NewResponse(.pResponse)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Set pResponse.SessionId=..%RequestHeader.SessionId
			Set pResponse.RequestURL="Post "_tURL
			If $IsObject(tHttpResponse) {
				Do pResponse.RawResponse.CopyFrom(tHttpResponse.Data)  Do tHttpResponse.Data.Rewind()
				Set pResponse.Value=tHttpResponse.Data.Read() ; count
			}
			
		} ElseIf tCmd = "DELETE" {
			Set tURL=..Adapter.URL_"/"_pRequest.Type_"/"_pRequest.Key_"/"_$$$URLENCODE(pRequest.KeyValue)_$S(""=pRequest.Field:"",1:"/"_pRequest.Field)
			Set tSC=..Adapter.DeleteURL(tURL,.tHttpResponse)
			Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
			Set tSC1=pRequest.NewResponse(.pResponse) Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1) 
			Quit:$$$ISERR(tSC)
			Set pResponse.SessionId=..%RequestHeader.SessionId
			Set pResponse.RequestURL="Delete "_tURL
			Do pResponse.RawResponse.CopyFrom(tHttpResponse.Data)  Do tHttpResponse.Data.Rewind()
			Set pResponse.Value=tHttpResponse.Data.Read() ; count

		} ElseIf tCmd = "PUT" {
			Set tURL=..Adapter.URL_"/"_pRequest.Type
			Set tSC=..Adapter.PutURL(tURL,.tHttpResponse,"",pRequest.Body)
			Set:$$$ISERR(tSC)&&$IsObject(tHttpResponse)&&$IsObject(tHttpResponse.Data)&&tHttpResponse.Data.Size tSC=$$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(tSC)_":"_tHttpResponse.Data.Read())
			Set tSC1=pRequest.NewResponse(.pResponse)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Quit:$$$ISERR(tSC)
			Set pResponse.SessionId=..%RequestHeader.SessionId
			Set pResponse.RequestURL="Put "_tURL
			Do pResponse.RawResponse.CopyFrom(tHttpResponse.Data)  Do tHttpResponse.Data.Rewind()
			Set pResponse.Value=tHttpResponse.Data.Read() ; ID
		} Else {
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Command "_pRequest.Command_" not implemented")
		}
	} catch {
		Set tSC=$$$SystemError
	}
	Quit tSC
}

/// copy Person properties from COS array to %ArrayOfDataTypes object, handling various data types appropriately
Method getPersonProps(pArray, pCollectionObj)
{
	Set k="" For { Set k=$O(pArray(k),1,val)  Quit:""=k
		If '$IsObject(val) {
			Do pCollectionObj.SetAt($S($L(val)<=50:val,1:$E(val,1,47)_"..."),k) ; truncate strings longer than 50 chars
		} ElseIf $Case(k,"Spouse":1,"Company":1,:0) {
			Do pCollectionObj.SetAt(val.Name,k) ; don't drill in to nested Spouse and Company objects, just keep their name
		} ElseIf val.%Extends("%Library.ListOfDataTypes") || val.%Extends("%Library.ListOfObjects") {
			Set val2="" For j=1:1:val.Count() { Set val2=val2_","_val.GetAt(j) } ; concatenate lists of values into a single string (i.e. FavoriteColors)
			Do pCollectionObj.SetAt($E(val2,2,*),k)
		} ElseIf val.%Extends("%ZEN.proxyObject") {
			Kill tRec2  Do val.%CopyToArray(.tRec2)
			Set j="" For { Set j=$O(tRec2(j),1,val2)  Quit:""=j
				Do pCollectionObj.SetAt(val2,k_"."_j) ; unroll nested proxy object properties using a dot in the property name
			}
		} Else {
			Do pCollectionObj.SetAt(val,k) ; just store the oref string
		}
	}
}

}
