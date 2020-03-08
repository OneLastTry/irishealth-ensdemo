Class Demo.Loan.FindRateProduction Extends Ens.Production [ ClassType = "", ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Demo.Loan.FindRateProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Demo.Loan.BankMetrics" Category="" ClassName="Demo.Loan.BankMetrics" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateTerminalService" Category="" ClassName="Demo.Loan.FindRateTerminalService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="BusinessPartner">Old School Bank</Setting>
  </Item>
  <Item Name="My Terminal Output" Category="" ClassName="Demo.Loan.FindRateTerminalOperation" PoolSize="1" Enabled="true" Foreground="true" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="BusinessPartner">Old School Bank</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateFileService" Category="" ClassName="Demo.Loan.FindRateFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\loan\in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.application</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\Practice\loan\inarchive</Setting>
    <Setting Target="Host" Name="BusinessPartner">LoanTech Corporation</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateFileOperation" Category="" ClassName="Demo.Loan.FindRateFileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Practice\loan\out</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
    <Setting Target="Host" Name="BusinessPartner">LoanTech Corporation</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateEMailService" Category="" ClassName="Demo.Loan.FindRateEMailService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="POP3Server">test.mymailserver.net</Setting>
    <Setting Target="Adapter" Name="Credentials">POP3GetEmailTest</Setting>
    <Setting Target="Host" Name="BusinessPartner">Store Front Loans</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateEMailOperation" Category="" ClassName="Demo.Loan.FindRateEMailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="Credentials">SMTPSendEmailTest</Setting>
    <Setting Target="Adapter" Name="From">loan@FindRate.com</Setting>
    <Setting Target="Adapter" Name="SMTPServer">1.2.3.4</Setting>
    <Setting Target="Host" Name="BusinessPartner">Store Front Loans</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateTCPService" Category="" ClassName="Demo.Loan.FindRateTCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">1</Setting>
    <Setting Target="Adapter" Name="Port">1234</Setting>
    <Setting Target="Adapter" Name="StayConnected">60</Setting>
    <Setting Target="Host" Name="BusinessPartner">LoanQuick, Inc.</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateTCPOperation" Category="" ClassName="Demo.Loan.FindRateTCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Adapter" Name="IPAddress">!</Setting>
    <Setting Target="Adapter" Name="Port">4321</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">15</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="ConnectTimeout">5</Setting>
    <Setting Target="Adapter" Name="ReadTimeout">60</Setting>
    <Setting Target="Host" Name="BusinessPartner">LoanQuick, Inc.</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateCSPService" Category="" ClassName="Demo.Loan.FindRateCSPService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="BusinessPartner">My Loans, Inc.</Setting>
  </Item>
  <Item Name="Demo.Loan.WebOperations" Category="" ClassName="Demo.Loan.WebOperations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">10</Setting>
    <Setting Target="Host" Name="BusinessPartner">My Loans, Inc.</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateDecisionProcessCustom" Category="" ClassName="Demo.Loan.FindRateDecisionProcessCustom" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateDecisionProcessBPL" Category="" ClassName="Demo.Loan.FindRateDecisionProcessBPL" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.Loan.BankSoprano" Category="" ClassName="Demo.Loan.BankSoprano" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.Loan.BankManana" Category="" ClassName="Demo.Loan.BankManana" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.Loan.BankUS" Category="" ClassName="Demo.Loan.BankUS" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateMSMQService" Category="" ClassName="Demo.Loan.FindRateMSMQService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
    <Setting Target="Adapter" Name="CreateQueueIfNeeded">0</Setting>
    <Setting Target="Adapter" Name="QueueLabel">FindRate MSMQ Request Service</Setting>
    <Setting Target="Adapter" Name="QueuePathName">.\private$\FindRate_Request</Setting>
    <Setting Target="Host" Name="BusinessPartner">State Bank</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateMQSeriesService" Category="" ClassName="Demo.Loan.FindRateMQSeriesService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="QueueManager">QM_testperson</Setting>
    <Setting Target="Adapter" Name="Channel">S_testperson/TCP/127.0.0.1(1414)</Setting>
    <Setting Target="Adapter" Name="QueueName">default</Setting>
    <Setting Target="Adapter" Name="QueueOptions">MQOO_INPUT_AS_Q_DEF</Setting>
    <Setting Target="Host" Name="BusinessPartner">Carriers Bank</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateMSMQOperation" Category="" ClassName="Demo.Loan.FindRateMSMQOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Adapter" Name="QueueLabel">Find Rate MSMQ Service Response</Setting>
    <Setting Target="Adapter" Name="QueuePathName">.\private$\FindRate_Response</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="BusinessPartner">State Bank</Setting>
  </Item>
  <Item Name="Demo.Loan.FindRateMQSeriesOperation" Category="" ClassName="Demo.Loan.FindRateMQSeriesOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="RetryInterval">5</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Adapter" Name="QueueManager">QM_testperson</Setting>
    <Setting Target="Adapter" Name="Channel">S_testperson/TCP/127.0.0.1(1414)</Setting>
    <Setting Target="Adapter" Name="QueueName">postcard</Setting>
    <Setting Target="Adapter" Name="QueueOptions">MQOO_OUTPUT</Setting>
    <Setting Target="Host" Name="BusinessPartner">Carriers Bank</Setting>
  </Item>
  <Item Name="Demo.Loan.BankEven" Category="" ClassName="Demo.Loan.BankEven" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
</Production>
}

ClassMethod Test()
{
	Set tSC=..TestStart()
	If 'tSC Do $system.Status.DisplayError(tSC) Quit

	Set tSC=##class(Ens.Director).CreateBusinessService("Demo.Loan.FindRateTerminalService",.tBusinessService)
	If $$$ISERR(tSC) Do $system.OBJ.DisplayError(tSC) Quit
	For {
		Read !,"amount:name:taxid:nationality>",tInput,! Quit:tInput=""
		Set tSC=tBusinessService.ProcessInput(##class(Ens.StringContainer).%New(tInput),.tOutput)
		If 'tSC Do $system.Status.DisplayError(tSC) Continue
		;Write !,tOutput.StringValue
	}
	Set tBusinessService = $$$NULLOREF

	Do ..Stop()
	Quit
}

ClassMethod SendRandomData(pMode As %String = "term", pCount As %Integer = 1, pDelay As %Integer = 10) As %Status
{
	Set tSC=..TestStart() Quit:$$$ISERR(tSC)

	If pMode="term" {
		Set tSC=##class(Ens.Director).CreateBusinessService("Demo.Loan.FindRateTerminalService",.tBS)  Quit:$$$ISERR(tSC)
	} Else { Set tSC=$$$OK }
	For tI=1:1:pCount {
		If tI>1 Hang $random(pDelay+1)

		Set tInput=..RandomRequest()
		Set tMode=pMode If tMode="all" Set tMode=$case($r(4), 0:"term", 1:"file", 2:"tcp", 3:"mail")
		Write !,"Request #",tI,": ",tInput," sent by ",tMode,!

		If tMode="term" {
			If '$Data(tBS) Set tSC=##class(Ens.Director).CreateBusinessService("Demo.Loan.FindRateTerminalService",.tBS)  Quit:$$$ISERR(tSC)
			Set tSC=tBS.ProcessInput(##class(Ens.StringContainer).%New(tInput),.tOutput)  Quit:$$$ISERR(tSC)
			Continue
		} Else { Kill tBS }
		If tMode="file" Do $zf(-1,"echo "_tInput_">C:\Practice\loan\in\random_"_$tr($zdt($H,8)," :","_")_".application") continue
		If tMode="tcp"  Do ..SendTCP(tInput,1234) Continue
		If tMode="mail" Do ..SendMail(tInput,$g(^MyEmailAddress)) continue
		If tMode="msmq" Do ..SendMSMQ(tInput,".\private$\FindRate_Request") Continue
		If tMode="mqseries" Do ..SendMQSeries(tInput,"postcard") Continue
	}
	If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
}

ClassMethod RandomRequest() As %String
{
	Set tAmount=($r(1000)+1)*1000
	Set tName=##class(%PopulateUtils).Name()
	Set tTaxID=##class(%PopulateUtils).SSN()
	Set tNationality=$p("USA,USA,UK",",",$r(3)+1)
	Quit tAmount_":"_tName_":"_tTaxID_":"_tNationality
}

ClassMethod SendMail(pApplication, pFrom)
{
	Set tSMTP=##class(%Net.SMTP).%New()
	Set tSMTP.smtpserver="192.9.200.1"
	Set tMail=##class(%Net.MailMessage).%New()
	Set tMail.Charset="iso-8859-1"
	Set tMail.From=$g(pFrom)
	Set tMail.Subject="LoanApplication:"_$g(pApplication,"100000:mo_mail:123456789:USA")
	Do tMail.To.Insert("testjsl@intersys.com")
	Do tMail.TextData.Write("The body is not used for the application purposes.")
	Set tSC=tSMTP.Send(tMail) If 'tSC Do $system.OBJ.DisplayError(tSC) Quit
	Write "Loan application is sent successfully.",!
	Quit
}

ClassMethod SendMSMQ(pApplication, pQueue)
{
	#; send message through MSMQ
	Set qinfo=##class(Activate.MSMQ.MSMQQueueInfo).%New()
	If qinfo=$$$NULLOREF Write "Failed to create MSMQQueueInfo",! Quit
	Set qinfo.PathName=pQueue
	Set qpub=qinfo.Open(2, 0)
	Set msg=##class(Activate.MSMQ.MSMQMessage).%New()
	Set msg.Label="Loan application:"_pApplication
	Set msg.Body="The body is not used for the application purposes"
	Do msg.Send(qpub)
	Do qpub.Close()
	#; read 2 message back from MSMQ
	Set qinfo=##class(Activate.MSMQ.MSMQQueueInfo).%New()
	If qinfo=$$$NULLOREF Write "Failed to create MSMQQueueInfo",! Quit
	Set qinfo.PathName=$p(pQueue,"_",1)_"_Response"
	;
	Set qpub=qinfo.Open(1, 0)
	Set msg=qpub.Receive(,,,10000)
	Write !,msg.Body,!
	;
	Set qpub=qinfo.Open(1, 0)
	Set msg=qpub.Receive(,,,10000)
	Write msg.Body,!
	Do qpub.Close()
	Quit
}

ClassMethod SendMQSeries(pApplication, pQueue)
{
	#; send message through MQ Series
	Set base=##class(EnsLib.MQSeries.Base).%New()
	Set tSC=base.Initialize("QM_dave","S_davem/TCP/127.0.0.1(1414)")
	Set tSC=base.OpenQueue(pQueue,"MQOO_OUTPUT")
	
	#; Construct a message to send
	Set msg=base.CreateMessage(.tSC)
	
	Set msg.Body="Loan application:"_pApplication_$c(13,10)_"The body is not used for the application purposes"
	
	Do base.SendMessage(msg)
	
	Do base.CloseQueue()
	Set base=""
	
	Quit
}

ClassMethod SendTCP(pApplication, pPort As %Integer = 1234)
{
	Set tDevice="|TCP|"_pPort
	Open tDevice:("127.0.0.1":pPort:"ST"):2
	If $Test=0 Write "can not open TCP device '"_tDevice_"'" Quit
	;
	Use tDevice
	Set pApplication=$g(pApplication,"100000:mo_tcp:123456789:USA")
	;
	Write pApplication_$C(13,10),*-3
	;
	Read tOutput
	;
	Close tDevice
	Write tOutput
	Quit
}

}
