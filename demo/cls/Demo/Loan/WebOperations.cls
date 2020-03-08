Class Demo.Loan.WebOperations Extends Ens.BusinessOperation [ ClassType = "", ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Parameter USEWEBSERVICES = "no";

XData MessageMap
{
<MapItems>
<MapItem MessageType="Demo.Loan.Msg.PrimeRateRequest">
<Method>GetPrimeRate</Method>
</MapItem>
<MapItem MessageType="Demo.Loan.Msg.CreditRatingRequest">
<Method>GetCreditRating</Method>
</MapItem>
</MapItems>
}

Method GetPrimeRate(pRequest As Demo.Loan.Msg.PrimeRateRequest, Output pResponse As Demo.Loan.Msg.PrimeRateResponse) As %Status
{
	$$$TRACE("PrimeRate requested")
	If ..#USEWEBSERVICES="yes" {
		Set tResult = ##class(Demo.WebService.FederalReserveClient).GetPrimeRate()
	} Else {
		Set tResult = 3
	}
	Set pResponse = ##class(Demo.Loan.Msg.PrimeRateResponse).%New()
	Set pResponse.PrimeRate = tResult
	$$$TRACE("value of '"_tResult_"' returned")
	Quit $$$OK
}

Method GetCreditRating(pRequest As Demo.Loan.Msg.CreditRatingRequest, Output pResponse As Demo.Loan.Msg.CreditRatingResponse) As %Status
{
	$$$TRACE("CreditRating requested for '"_pRequest.TaxID_"'")
	If ..#USEWEBSERVICES="yes" {
		Set tResult = ##class(Demo.WebService.CreditBureauClient).GetCreditRating(pRequest.TaxID)
	} Else {
		Set tResult = pRequest.TaxID#10*10
	}
	Set pResponse = ##class(Demo.Loan.Msg.CreditRatingResponse).%New()
	Set pResponse.TaxID = pRequest.TaxID
	Set pResponse.CreditRating = tResult
	$$$TRACE("value of '"_tResult_"' returned")
	Quit $$$OK
}

}
