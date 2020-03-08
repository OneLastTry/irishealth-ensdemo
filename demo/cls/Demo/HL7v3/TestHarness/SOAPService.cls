Class Demo.HL7v3.TestHarness.SOAPService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "HL7v3ResponseService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Method GetResponse(pInput As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	Set $ZTrap = "GetResponseET"

	&sql(
		Select	ID Into :tResponseModeID
		From	Demo_HL7v3_TestHarness.ResponseMode
		Where	Active = 1
	)
	Set tResponseModeID	= $Case(SQLCODE, 0:tResponseModeID, :"automated")
	Set tResponse		= $Case(tResponseModeID, "automated":..GetAutomatedResponse(pInput), "interactive":..GetInteractiveResponse(pInput), :"<errorResponse>Unknown response mode:  " _ tResponseModeID _ "</errorResponse>")

	Quit tResponse

GetResponseET
	Set $ZTrap = ""

	Set tResponse = ##class(%GlobalCharacterStream).%New()
	Do tResponse.Write("<errorResponse>An error has occurred in GetReponse():  " _ $ZError _ "</errorResponse>")
	Do tResponse.Rewind()

	Set tID = $Increment(^Demo.HL7v3.TestHarness.Errors("GetResponse"))
	Set ^Demo.HL7v3.TestHarness.Errors("GetResponse", tID) = $ZDateTime($Horolog, 3) _ "|" _ $ZError
	
	Quit tResponse
}

Method GetInteractiveResponse(pInput As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "GetInteractiveResponseET"
	
	// Get request message name (root element)
	Do pInput.Rewind()
	Set tStatus	= ##class(%XML.XPATH.Document).CreateFromStream(pInput, .tDocument)
	Set tStatus	= tDocument.EvaluateExpression("/*", "name()", .tResults)
	
	If (tResults.Count() > 0) Set tRoot = tResults.GetAt(1).Value
	Else  Set tRoot = "<errorNoRootElement>"
	
	// Save in the queue
	Set tQueue = ##class(Demo.HL7v3.TestHarness.MessageQueue).%New()
	Do tQueue.Request.CopyFrom(pInput)
	Set tQueue.RequestName	= tRoot
	Set tStatus				= tQueue.%Save()
	Set tQueuedMessageID	= tQueue.%Id()
	Kill tQueue
	
	// Enter wait loop
	Set tBegin = $ZHorolog
	Do {
		&sql(
			Select	ID
			From	Demo_HL7v3_TestHarness.MessageQueue
			Where	ID = :tQueuedMessageID
			And		Status = 'queued'
		)
		
		If (($ZHorolog - tBegin) >= 300) Quit

		Hang .5
	} While (SQLCODE = 0)
	
	// Out of loop, so we can delete from queue and return response
	If SQLCODE {
		Set tMessage	= ##class(Demo.HL7v3.TestHarness.MessageQueue).%OpenId(tQueuedMessageID)
		Set tResponse	= tMessage.Response
		Set tStatus		= ##class(Demo.HL7v3.TestHarness.MessageGenerator).ProcessStream(.tResponse)
	}
	Else {
		Set tResponse = ##class(%GlobalCharacterStream).%New()
		Do tResponse.Write("<errorResponse>Response not received within a 5-minute timout period</errorResponse>")
	}

	// Remove message from queue
	&sql(
		Delete
		From	Demo_HL7v3_TestHarness.MessageQueue
		Where	ID = :tQueuedMessageID
	)

	Do tResponse.Rewind()
	
	Quit tResponse

GetInteractiveResponseET
	Set $ZTrap = ""

	Set tResponse = ##class(%GlobalCharacterStream).%New()
	Do tResponse.Write("<errorResponse>An error has occurred in GetInteractiveResponse():  " _ $ZError _ "</errorResponse>")
	Do tResponse.Rewind()

	Set tID = $Increment(^Demo.HL7v3.TestHarness.Errors("GetInteractiveResponse"))
	Set ^Demo.HL7v3.TestHarness.Errors("GetInteractiveResponse", tID) = $ZDateTime($Horolog, 3) _ "|" _ $ZError
	
	Quit tResponse
}

Method GetAutomatedResponse(pInput As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap		= "GetAutomatedResponseET"
	Set tFoundMatch	= 0
	
	Do pInput.Rewind()
	Set tStatus = ##class(%XML.XPATH.Document).CreateFromStream(pInput, .tDocument)

	// Iterate through potential XPATH matches
	&sql(
		Declare	XPATH Cursor For
		Select	ID, XPathContext, XPathExpression, XPathValue
		Into	:tResponseMapID, :tXPathContext, :tXPathExpression, :tXPathValue
		From	Demo_HL7v3_TestHarness.ResponseMap
	)
	&sql( Open XPATH )
	&sql( Fetch XPATH )
	While 'SQLCODE {
		Set tStatus = tDocument.EvaluateExpression(tXPathContext, tXPathExpression, .tResults)
	
		// Make sure we've got something to process
		If ($Get(tResults) '= "") && ($IsObject(tResults) = 1) && (tResults.Count() > 0) {
			If (tXPathValue = tResults.GetAt(1).Value) {
				Set tFoundMatch = 1
				
				Quit
			}
	
			&sql( Fetch XPATH )
		}	
		&sql( Close XPATH )
	}
	
	If (tFoundMatch = 1) {
		Set tResponse	= ##class(Demo.HL7v3.TestHarness.ResponseMap).%OpenId(tResponseMapID).Response.Message
		Set tStatus		= ##class(Demo.HL7v3.TestHarness.MessageGenerator).ProcessStream(.tResponse)

		Quit tResponse
	}
	Else {
		Set tResponse = ##class(%GlobalCharacterStream).%New()
		Do tResponse.Write("<defaultResponse>Failed to match specific response</defaultResponse>")
		Do tResponse.Rewind()

		Quit tResponse
	}
	
	Quit

GetAutomatedResponseET
	Set $ZTrap = ""

	Set tResponse = ##class(%GlobalCharacterStream).%New()
	Do tResponse.Write("<errorResponse>An error has occurred in GetAutomatedReponse():  " _ $ZError _ "</errorResponse>")
	Do tResponse.Rewind()

	Set tID = $Increment(^Demo.HL7v3.TestHarness.Errors("GetAutomatedResponse"))
	Set ^Demo.HL7v3.TestHarness.Errors("GetAutomatedResponse", tID) = $ZDateTime($Horolog, 3) _ "|" _ $ZError

	Quit tResponse
}

}
