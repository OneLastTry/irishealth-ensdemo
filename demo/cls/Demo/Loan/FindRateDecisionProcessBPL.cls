/// Loan Approval Business Process for Find Rate.
/// This process passes on a Loan Application to 
/// 3 other bank and finds the best available rate.
Class Demo.Loan.FindRateDecisionProcessBPL Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Parameter DOMAIN = "EnsDemo";

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.Loan.Msg.Application' height='2000' width='2635' >
<context>
<property name='BankName' type='%String' ><parameters><parameter name='MAXLEN' value=''/></parameters></property>
<property name='IsApproved' type='%Boolean' />
<property name='InterestRate' type='%Numeric' />
<property name='TheResults' type='Demo.Loan.Msg.Approval' collection='list' />
<property name='Iterator' type='%String' />
<property name='ThisResult' type='Demo.Loan.Msg.Approval' />
</context>
<sequence xend='550' yend='1450' >
<trace value='"received application for "_request.Name' xpos='550' ypos='200' />
<call name='BankUS' target='Demo.Loan.BankUS' async='1' xpos='550' ypos='300' >
<annotation>Send an asynchronous request to Bank US.</annotation>
<request type='Demo.Loan.Msg.Application' >
<assign property='callrequest' value='request' action='set' />
</request>
<response type='Demo.Loan.Msg.Approval' >
<assign property='context.TheResults' value='callresponse' action='append' />
</response>
</call>
<call name='BankSoprano' target='Demo.Loan.BankSoprano' async='1' xpos='550' ypos='400' >
<annotation>Send an asynchronous request to Bank Soprano.</annotation>
<request type='Demo.Loan.Msg.Application' >
<assign property='callrequest' value='request' action='set' />
</request>
<response type='Demo.Loan.Msg.Approval' >
<assign property='context.TheResults' value='callresponse' action='append' />
</response>
</call>
<call name='BankManana' target='Demo.Loan.BankManana' async='1' xpos='550' ypos='500' >
<annotation>Send an asynchronous request to Bank Manana.</annotation>
<request type='Demo.Loan.Msg.Application' >
<assign property='callrequest' value='request' action='set' />
</request>
<response type='Demo.Loan.Msg.Approval' >
<assign property='context.TheResults' value='callresponse' action='append' />
</response>
</call>
<call name='BankEven' target='Demo.Loan.BankEven' async='1' xpos='550' ypos='600' >
<annotation>Send an asynchronous request to Bank Even.</annotation>
<request type='Demo.Loan.Msg.Application' >
<assign property='callrequest' value='request' action='set' />
</request>
<response type='Demo.Loan.Msg.Approval' >
<assign property='context.TheResults' value='callresponse' action='append' />
</response>
</call>
<sync name='Wait for Banks' calls='BankUS,BankSoprano,BankManana,BankEven' timeout='5' type='all' xpos='550' ypos='700' >
<annotation>Wait for the response from the banks. Wait for up to 5 seconds.</annotation>
</sync>
<trace value='"sync complete"' xpos='550' ypos='800' />
<foreach name='Loop through Results' property='context.TheResults' key='context.Iterator' xpos='550' ypos='900' xend='550' yend='1200' >
<annotation>Loop over the results received from the banks.
Drill into this shape to see the details of the loop.
</annotation>
<assign name='ThisResult' property='context.ThisResult' value='context.TheResults.GetAt(context.Iterator)' action='set' xpos='550' ypos='200' />
<trace value='"processing reply from "_context.ThisResult.BankName' xpos='550' ypos='300' />
<if name='Approved?' condition='context.ThisResult.IsApproved' xpos='550' ypos='400' xend='550' yend='1100' >
<annotation>Were we approved by this bank?</annotation>
<true>
<if name='BetterRate?' condition='(&apos;context.IsApproved)||(context.InterestRate&gt;context.ThisResult.InterestRate)' xpos='685' ypos='550' xend='685' yend='1000' >
<annotation>Is this a better rate?
Compare rate with current best rate.</annotation>
<true>
<assign name='BankName' property='context.BankName' value='context.ThisResult.BankName' action='set' xpos='820' ypos='700' >
<annotation>This is the best rate so far;
Copy the details into the context object.</annotation>
</assign>
<assign name='IsApproved' property='context.IsApproved' value='context.ThisResult.IsApproved' action='set' xpos='820' ypos='800' />
<assign name='InterestRate' property='context.InterestRate' value='context.ThisResult.InterestRate' action='set' xpos='820' ypos='900' />
</true>
</if>
</true>
</if>
</foreach>
<switch name='Response' xpos='550' ypos='1000' xend='550' yend='1250' >
<annotation>Determine which type of response was requested.</annotation>
<case condition='request.BusinessOperationType="mail"' name='Mail' >
<call name='SendApproval' target='Demo.Loan.FindRateEMailOperation' async='1' xpos='685' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<case condition='request.BusinessOperationType="file"' name='File' >
<call name='SendApproval' target='Demo.Loan.FindRateFileOperation' async='1' xpos='955' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<case condition='request.BusinessOperationType="term"' name='Terminal' >
<call name='SendApproval' target='My Terminal Output' async='1' xpos='1225' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<case condition='request.BusinessOperationType="tcp"' name='TCP' >
<call name='SendApproval' target='Demo.Loan.FindRateTCPOperation' async='1' xpos='1495' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<case condition='request.BusinessOperationType="msmq"' name='MSMQ' >
<call name='SendApproval' target='Demo.Loan.FindRateMSMQOperation' async='1' xpos='1765' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<case condition='request.BusinessOperationType="mqseries"' name='MQSeries' >
<call name='SendApproval' target='Demo.Loan.FindRateMQSeriesOperation' async='1' xpos='2035' ypos='1150' >
<request type='Demo.Loan.Msg.SendReply' >
<assign property='callrequest.Text' value='process.GetText(context)' action='set' />
<assign property='callrequest.Destination' value='request.Destination' action='set' />
</request>
</call>
</case>
<default/>
</switch>
<trace value='"application is "_$s(context.IsApproved:"approved for "_context.InterestRate_"% by "_context.BankName,1:"denied")' xpos='550' ypos='1350' />
</sequence>
</process>
}

/// 2 modes: Queue, InProc
Parameter INVOCATION = "Queue";

Method GetText(context As Ens.BP.Context) As %String
{
	Set tSessionId=..%SessionId
	&sql(Select MessageBodyId into :tRecordNum from Ens.MessageHeader where ID=:tSessionId)
	If $Get(tRecordNum)="" set tRecordNum ="??"
	
	If context.IsApproved {
		Set tText = $$FormatMessage^%occMessages(,"EnsDemo","FindRateContext1","Your loan application with record number %1 was approved.",tRecordNum)_$c(13,10)
		Set tText = tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateContext2","The lowest interest rate available is at %1 percent offered by %2.",context.InterestRate,context.BankName)_$c(13,10)
	} Else {
		Set tText = $$FormatMessage^%occMessages(,"EnsDemo","FindRateIsDenied","Your loan application was denied.",tRecordNum)_$c(13,10)
	}
	Set tText=tText_$$FormatMessage^%occMessages(,"EnsDemo","FindRateThankyou","Thank you for applying with FindRate.")_$c(13,10)
	Quit $ZCVT(tText,"O","HTML")
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
