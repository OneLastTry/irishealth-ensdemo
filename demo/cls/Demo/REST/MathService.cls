/// Simple REST Service in Ensemble  
/// 
/// It is a Math service with a RESTful interface returning JSON:		/sum/2/3  =>  { "Sum" : 5 }
/// 
/// There are two ways to call this REST interface. You can test both ways using a Browser: 
/// 
/// 1) Calling the adapter port directly
/// 
/// 		http://IP:AdapterPort/sum/2/3
/// 
/// 2) Or using the CSP Gateway mechanism. In order for this way to work, a web application has to be created first.
/// 	   For example, create a new web app with the following minimum parameters:  
/// 		Web App Name = /rest
/// 		Namespace = yourNamespace
/// 		Dispatch class = EnsLib.REST.Service
/// 
/// 		http://IP:WebServerPort/rest/servicename/sum/2/3
/// 
Class Demo.REST.MathService Extends EnsLib.REST.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Parameter EnsServicePrefix = "|sum";

XData UrlMap
{
<Routes>
<Route Url="/:number1/:number2" Method="GET" Call="Sum"/>
</Routes>
}

/// 
/// This method returns the sum of pnumber1 and pnumber2
/// 
ClassMethod Sum(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pnumber1 As %Integer, pnumber2 As %Integer) As %Status
{
	set status = $$$OK
	try{
 		// Do whatever you need to do and get back an object
 		set result = pnumber1 + pnumber2
 		set tProxy = ##class(%ZEN.proxyObject).%New()
 		set tProxy.Sum = result
 		
 		// You could just write the output manually or use helper methods like ..ObjectToJSONStream() to generate JSON
 		do pOutput.SetAttribute("Content-Type","application/json")
 		do pOutput.Write("[")
 		
 		Set tOut=##class(%IO.StringStream).%New()
 		do ..ObjectToJSONStream(tProxy,.tOut)	
 		
 		do tOut.Rewind()
 		do pOutput.Write( tOut.Read() )
 		do pOutput.Write("]"_$C(13,10))
 		
	} catch (e) {
		set status = e.AsStatus()
	}
      quit status
}

}
