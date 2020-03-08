/// Business operation responsible for converting temperature bewteen Celsius and Fahrenheit.
Class Demo.ZenService.Boper.ConvertTemp Extends Ens.BusinessOperation [ ProcedureBlock ]
{

/// Use our own simple adapter since this business operation does not call outside Ensemble
Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

/// Accept an incoming Demo.ZenService.Msg.ConvertTempRequest which contains properties Direction and InputTemp.
/// Direction may have a case-sensitive value of "CToF" (Celsius to Fahrenheit) or "FToC" (Fahrenheit to Celsius).
/// Convert the incoming InputTemp in the indicated Direction and store the result in the outgoing
/// Demo.ZenService.Msg.ConvertTempResponse which contains an OutputTemp property to hold the result.
Method Convert(pRequest As Demo.ZenService.Msg.ConvertTempRequest, Output pResponse As Demo.ZenService.Msg.ConvertTempResponse) As %Status
{
	// Call a method on this business operation (just an example; usually you would call outside Ensemble)
	set response = ..ConvertTemp(pRequest.Direction,pRequest.InputTemp)

	// Instantiate the response message object
	set pResponse = ##class(Demo.ZenService.Msg.ConvertTempResponse).%New()
	
	// Assign the response to the response message property
	set pResponse.OutputTemp = response

	Quit $$$OK
}

/// Convert a temperature from Celsius to Fahrenheit (direction="CToF") or 
/// Fahrenheit to Centigrade (direction="FToC"). The dir argument
/// gives the direction to convert in ("CToF" or "FToC") and the
/// temp argument gives the temperature value.
Method ConvertTemp(dir As %String, temp As %Integer)
{
	If (dir = "CToF") {
		Quit ..CToF(temp)
	}
	ElseIf (dir = "FToC") {
		Quit ..FToC(temp)
	}
	Else {
		Quit temp
	}
}

Method CToF(input As %Integer) As %Integer
{
	quit (input*1.8)+32
}

Method FToC(input As %Integer) As %Integer
{
	quit (input-32)/1.8
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.ZenService.Msg.ConvertTempRequest"> 
		<Method>Convert</Method>
	</MapItem>
</MapItems>
}

}
