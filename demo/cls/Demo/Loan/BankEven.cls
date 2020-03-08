/// Loan Approval Business Process for Bank Even.
/// Bank Even simulates a bank with unreliable service;
/// sometimes it responds quickly, other times not.
Class Demo.Loan.BankEven Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.Loan.Msg.Application' response='Demo.Loan.Msg.Approval' height='2000' width='2000' >
<context>
<property name='CreditRating' type='%Integer' />
<property name='PrimeRate' type='%Numeric' />
<property name='NameLength' type='%Integer' />
</context>
<sequence xend='550' yend='900' >
<trace value='"received application for "_request.Name' xpos='550' ypos='200' />
<assign name='Count Name Length' property='context.NameLength' value='$Length(request.Name)' action='set' xpos='550' ypos='300' />
<transform name='Initialize from Loan App' class='Demo.Loan.BankEvenLoanAppTransform' source='request' target='response' xpos='550' ypos='400' />
<call name='PrimeRate' target='Demo.Loan.WebOperations' async='0' xpos='550' ypos='500' >
<annotation>Make a synchronous request for the Prime Rate.</annotation>
<request type='Demo.Loan.Msg.PrimeRateRequest' />
<response type='Demo.Loan.Msg.PrimeRateResponse' >
<assign property='context.PrimeRate' value='callresponse.PrimeRate' action='set' />
</response>
</call>
<call name='CreditRating' target='Demo.Loan.WebOperations' async='0' xpos='550' ypos='600' >
<annotation>Make a synchronous request	for the Credit Rating.</annotation>
<request type='Demo.Loan.Msg.CreditRatingRequest' >
<assign property='callrequest.TaxID' value='request.TaxID' action='set' />
</request>
<response type='Demo.Loan.Msg.CreditRatingResponse' >
<assign property='context.CreditRating' value='callresponse.CreditRating' action='set' />
</response>
</call>
<assign name='InterestRate' property='response.InterestRate' value='context.PrimeRate+1+(2*(1-(context.CreditRating/100)))' action='set' xpos='550' ypos='700' >
<annotation>Copy InterestRate into the response object.</annotation>
</assign>
<trace value='"application is "_$s(response.IsApproved:"approved for "_response.InterestRate_"%",1:"denied")' xpos='550' ypos='800' />
</sequence>
</process>
}

Property BankName As %String [ InitialExpression = "Bank Even" ];

Parameter SETTINGS As %String = "BankName";

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Storage Default
{
<Data name="BankEvenDefaultData">
<Subscript>"BankEven"</Subscript>
<Value name="1">
<Value>BankName</Value>
</Value>
</Data>
<DefaultData>BankEvenDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
