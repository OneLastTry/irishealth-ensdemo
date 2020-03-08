/// Loan Approval Business Process for Bank Soprano.
/// Bank Soprano simulates a bank with great service but
/// somewhat high interest rates.
Class Demo.Loan.BankSoprano Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process request="Demo.Loan.Msg.Application" response="Demo.Loan.Msg.Approval">
	
	<context>
		<property name="CreditRating" type="%Integer"/>
		<property name="PrimeRate" type="%Numeric"/>
	</context>
	
	<sequence>

	<trace value='"received application for "_request.Name'/>
	
	<assign name='Init Response' property="response.BankName" value='"BankSoprano"'>
	<annotation><![CDATA[Initialize the response object.]]></annotation>
	</assign>
	
	<call name="PrimeRate" target="Demo.Loan.WebOperations" async="1">
	<annotation><![CDATA[Send an asynchronous request for the Prime Rate.]]></annotation>
	<request type="Demo.Loan.Msg.PrimeRateRequest"/>
	<response type="Demo.Loan.Msg.PrimeRateResponse">
	<assign property="context.PrimeRate" value="callresponse.PrimeRate"/>
	</response>
	</call>

	<call name="CreditRating" target="Demo.Loan.WebOperations" async="1">
	<annotation><![CDATA[Send an asynchronous request for the Credit Rating.]]></annotation>
	<request type="Demo.Loan.Msg.CreditRatingRequest">
	<assign property="callrequest.TaxID" value='request.TaxID'/>
	</request>
	<response type="Demo.Loan.Msg.CreditRatingResponse">
	<assign property="context.CreditRating" value="callresponse.CreditRating"/>
	</response>
	</call>

	<sync name='Wait' calls="PrimeRate,CreditRating" type="all" timeout="10">
	<annotation><![CDATA[Wait for the response from the async requests.
Wait for up to 10 seconds.]]></annotation>
	</sync>

	<switch name='Approved?'>
	<case name='No PrimeRate' condition='context.PrimeRate=""'>
		<assign name='Not Approved' property="response.IsApproved" value="0"/>
	</case>
	<case name='No Credit' condition='context.CreditRating=""'>
		<assign name='Not Approved' property="response.IsApproved" value="0"/>
	</case>
	<default name='Approved' >
	<assign name='Approved' property="response.IsApproved" value="1"/>
	<assign name='InterestRate' property="response.InterestRate" value="context.PrimeRate+10+(99*(1-(context.CreditRating/100)))">
		<annotation><![CDATA[Copy InterestRate into response object.]]></annotation>
	</assign>
	</default>
	</switch>

	<delay name='Delay' duration="&quot;PT&quot;_(2+($zcrc(request.Name,4)#5))_&quot;S&quot;">
		<annotation><![CDATA[Wait for a random duration.]]></annotation>
	</delay>
	
	<trace value='"application is "_$s(response.IsApproved:"approved for "_response.InterestRate_"%",1:"denied")'/>

	</sequence>
</process>
}

Storage Default
{
<Data name="BankSopranoDefaultData">
<Subscript>"BankSoprano"</Subscript>
<Value name="1">
<Value>CreditRating</Value>
</Value>
<Value name="2">
<Value>PrimeRate</Value>
</Value>
</Data>
<DefaultData>BankSopranoDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
