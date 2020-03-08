Include %occInclude

Class Demo.HL7v3.TestHarness.MessageGenerator Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddLog(Text As %String = "Default")
{
 Set i = $Increment(^CacheTempVerwHL7($job))
 set ^CacheTempVerwHL7($job,i)=Text
}

/// 2 parameters FileIn en FileOut <br>
/// Calls ProcessStream <br>
/// Used for test.
ClassMethod ProcessFile(FileInput As %String, FileOutput As %String, params As %List = "") As %Status
{
 q:(FileInput="")||(FileOutput="") $$$ERROR($$$GeneralError,"Input and/or output file name empty!")
 k ^CacheTempVerwHL7($job)
 If ('##class(%File).Exists(FileInput)) {
	 s tekst="File "_FileInput_" does not exist"
	 d ..AddLog(tekst)
	 quit $$$ERROR($$$GeneralError,tekst)
 }
 Set fstream=##class(%FileCharacterStream).%New()
 set fstream.Filename=FileInput
 s status=..ProcessStream(.fstream, params)
 if (status) {
	 d fstream.Rewind()
     s dev=FileOutput
	 o dev:("wns")
	 u dev
	 d fstream.OutputToDevice()
     close dev
     use 0
     s fstream=""
  	 } 
 s fstream=""
 quit $$$OK
}

/// Main entry point -- passes a stream by reference and returns it modified
/// (that is, parameters identified by #( )# delimiters will be replaced
/// by the result of the code they contain, usually a random generator, for
/// instance, one of the methods of %PopulateUtils)
/// TODO: pass parameters to this method
ClassMethod ProcessStream(ByRef stream As %Stream.Object, params As %List = "") As %Status
{
  d stream.Rewind()
  s resultStream=stream.%ConstructClone(1,.cloner)
  d resultStream.Rewind()
  s sw=0,verwerk=0,tussen="",len=15000
  while (len=15000)
  {
  	s buffer=stream.Read(.len), out=""
  	for i=1:1:len {
	  s char=$e(buffer,i)
	  // start parsing here
	  // 
	  if (char=")") {
		  if (sw=1) && (verwerk=1) {
			  s verwerk=-1
			  continue
		  }
		  if (sw=1) && (verwerk=-1) {
			  s tussen=tussen_char
	          continue
		  }
	  }
	  if (verwerk=1) {
		  // build command
		  s tussen=tussen_char
	      continue
	  }
	  if (char="#") {
		 if (verwerk=-1) {
			  s verwerk=0
			  s sw=0,result=""
			  s ontvang=..ProcessParameter(tussen,.result,params)
			  s out=out_result
			  s tussen=""
			  continue
		  }
		  if (sw=0) {
			  s sw=1
			  continue
		  }
	  }
	  if (char="(") {
		  if (sw=1) && (verwerk=0) {
			  s verwerk=1
			  continue
		  }
	  }
	  if (sw=0) { s out=out_char}
    }
    d resultStream.Write(out)
  }
 s stat=stream.Rewind() q:stat'=$$$OK stat
 q stream.CopyFrom(resultStream)
}

ClassMethod ProcessParameter(Source As %String, ByRef Target As %String, params As %List = "") As %Integer [ PublicList = temp ]
{
	i ($e(Source,1,5)="param")
	{
		s index=+$e(Source,7,$l(Source)-1)
		s Target=$lg(params,index,"")
		q 1
	}
 if ($e(Source,1,1)="#") || ($e(Source,1,1)="$") {
 // execute method with xecute
   Set $ZTRAP="Trapexecute"
   s uitvoer="s temp="_Source
   XECUTE uitvoer
   // copy result of xecute into Target
   s Target=temp
   quit 1
Trapexecute ;
 s Target=""
 Set $ZTRAP=""
 d ..AddLog($ZE_"#("_Source_")#")
 quit 0
 }
 else {
 // execute method of %Library.PopulateUtils
 Set $ZTRAP="Trapmethod"
 s Target=$zobjclassmethod("%Library.PopulateUtils",Source)
 s $ZTRAP=""
 quit 1
Trapmethod ;
 s Target=""
 Set $ZTRAP=""
 d ..AddLog($ZE_"#("_Source_")#")
 quit 0
 } // end else
}

/// Show the error log generated in the last execution of ProcessStream <br>
/// This is stored in global <b>^CacheTempVerwHL7</b>. 
ClassMethod ShowLog()
{
 s x=""
 for  {
	 s x=$o(^CacheTempVerwHL7($job,x))
	 q:x=""
	 w !,^CacheTempVerwHL7($job,x)
 }
}

ClassMethod Test()
{
	s msg=##class(%Dictionary.CompiledXData).%OpenId("Demo.HL7v3.TestHarness.MessageTemplates||QUPAIN101103").Data
	s params=$lb("foobarbaz")
	d ..ProcessStream(.msg, params)
	d msg.OutputToDevice()
}

}
