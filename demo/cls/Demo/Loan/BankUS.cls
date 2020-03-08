Class Demo.Loan.BankUS Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Property CreditRating As %Integer;

Property PrimeRate As %Numeric;

Method OnRequest(request As Demo.Loan.Msg.Application, Output response As Demo.Loan.Msg.Approval) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		$$$TRACE("received application for "_request.Name)
		#;
		If $zcrc(request.Name,2)#5=0 {
			Set response = ##class(Demo.Loan.Msg.Approval).%New()
			Set response.BankName = "BankUS"
			Set response.IsApproved = 0
			$$$TRACE("application is denied because of bank holiday")
			Quit
		}
		#;
		Set tRequest = ##class(Demo.Loan.Msg.PrimeRateRequest).%New()
		Set tSC = ..SendRequestAsync("Demo.Loan.WebOperations",tRequest,1,"PrimeRate")
		#;
		Set tRequest = ##class(Demo.Loan.Msg.CreditRatingRequest).%New()
		Set tRequest.TaxID = request.TaxID
		Set tSC = ..SendRequestAsync("Demo.Loan.WebOperations",tRequest,1,"CreditRating")
		#;
		Set tSC = ..SetTimer("PT15S")
		#;
		Quit
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError Goto Exit
}

/// Handle a 'Response'
Method OnResponse(request As Ens.Request, ByRef response As Ens.Response, callrequest As Ens.Request, callresponse As Ens.Response, pCompletionKey As %String) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		If pCompletionKey="PrimeRate" {
			Set ..PrimeRate = callresponse.PrimeRate
		} Elseif pCompletionKey="CreditRating" {
			Set ..CreditRating = callresponse.CreditRating
		}
		Quit
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError Goto Exit
}

Method OnComplete(request As Ens.Request, ByRef response As Ens.Response) As %Status
{
	Set $ZT="Trap",tSC=$$$OK
	Do {
		Set response = ##class(Demo.Loan.Msg.Approval).%New()
		Set response.BankName = "BankUS"
		Set tIsUsCitizen=($zcvt($tr(request.Nationality,"."),"u")="USA")||($zcvt($tr(request.Nationality,"."),"u")="US")
		If ('tIsUsCitizen)||(..CreditRating<50) {
			Set response.IsApproved = 0
			$$$TRACE("application is denied")
		} Else {
			Set response.IsApproved = 1
			Set response.InterestRate = ..PrimeRate+2+(5*(1-(..CreditRating/100)))
			$$$TRACE("application is approved for "_response.InterestRate_"%")
		}
		Quit
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError Goto Exit
}

Storage Default
{
<Data name="BankUSDefaultData">
<Subscript>"BankUS"</Subscript>
<Value name="1">
<Value>CreditRating</Value>
</Value>
<Value name="2">
<Value>PrimeRate</Value>
</Value>
</Data>
<DefaultData>BankUSDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
