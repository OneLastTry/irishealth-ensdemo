/// BPL business process responsible for getting a weather report and providing the results
/// in the appropriate language and temperature scale for the locale.
Class Demo.ZenService.Bproc.WeatherReport Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StringRequest' response='Demo.ZenService.Msg.WeatherReportResponse' height='2000' width='2000' >
<context>
<property name='Location' type='%String' >
</property>
<property name='OperationReport' type='Demo.ZenService.Msg.WeatherOperationResponse' >
</property>
<property name='TempScale' type='%Library.String' >
</property>
<property name='OutputTemp' type='%String' >
</property>
<property name='Language' type='%Library.String' >
</property>
</context>
<sequence xend='200' yend='850' >
<assign name="Store Location" property="context.Location" value="request.StringValue" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[Assign the StringValue from the request to the business process context property called Location.]]></annotation>
</assign>
<call name='Get Weather Report' target='Get Weather Report' async='0' xpos='200' ypos='350' >
<annotation>Make a synchronous call to the business operation Get Weather Report, sending it the context property Location and placing the response in the context property OperationReport.</annotation>
<request type='Ens.StringRequest' >
<assign property="callrequest.StringValue" value="context.Location" action="set" />
</request>
<response type='Demo.ZenService.Msg.WeatherOperationResponse' >
<assign property="context.OperationReport" value="callresponse" action="set" />
</response>
</call>
<sequence name='Convert Temp' xpos='200' ypos='450' xend='200' yend='800' >
<annotation>Invoke the TempScale rule. Depending on location the temperature should be reported in Fahrenheit or Celsius. Store the result in the context property TempScale. </annotation>
<rule name='Temp Scale' rule='TempScale'  resultLocation='context.TempScale' xpos='200' ypos='250' >
<annotation>Invoke the TempScale rule. If the Location is US or USA then the temperature scale is F; otherwise it is C. Put the result in the context property TempScale. </annotation>
</rule>
<if name='Convert?' condition='context.TempScale="F"' xpos='200' ypos='350' xend='200' yend='700' >
<annotation>Test whether the context property TempScale is F. If so, do the conversion to Fahrenheit. </annotation>
<true>
<call name='Convert Min Temp' target='Convert Temperature' async='0' xpos='335' ypos='500' >
<annotation>Call the Convert Temperature business operation to convert the day&#39;s minimum temperature from Celsius to Fahrenheit. Put the result in the context property OperationReport.</annotation>
<request type='Demo.ZenService.Msg.ConvertTempRequest' >
<assign property="callrequest.Direction" value="&quot;CToF&quot;" action="set" />
<assign property="callrequest.InputTemp" value="context.OperationReport.MinTemperature" action="set" />
</request>
<response type='Demo.ZenService.Msg.ConvertTempResponse' >
<assign property="context.OperationReport.MinTemperature" value="callresponse.OutputTemp" action="set" />
</response>
</call>
<call name='Convert Max Temp' target='Convert Temperature' async='0' xpos='335' ypos='600' >
<annotation>Call the Convert Temperature business operation to convert the day&#39;s maximum temperature from Celsius to Fahrenheit. Put the result in the context property OperationReport.</annotation>
<request type='Demo.ZenService.Msg.ConvertTempRequest' >
<assign property="callrequest.Direction" value="&quot;CToF&quot;" action="set" />
<assign property="callrequest.InputTemp" value="context.OperationReport.MaxTemperature" action="set" />
</request>
<response type='Demo.ZenService.Msg.ConvertTempResponse' >
<assign property="context.OutputTemp" value="callresponse.OutputTemp" action="set" />
<assign property="context.OperationReport.MaxTemperature" value="callresponse.OutputTemp" action="set" />
</response>
</call>
</true>
</if>
</sequence>
<sequence name='Translate' xpos='200' ypos='550' xend='200' yend='700' >
<annotation>Invoke the LanguageFromLocation rule which maps a country name to the language spoken there. If the language is other than English, translate the weather report.</annotation>
<rule name='Language?' rule='LanguageFromLocation'  resultLocation='context.Language' xpos='200' ypos='250' >
<annotation>Invoke the LanguageFromLocation rule to map the location to English, French, Spanish, Italian, orGerman. The result goes in the context property Language.</annotation>
</rule>
<if name='English?' condition='context.Language="English"' xpos='200' ypos='350' xend='200' yend='600' >
<annotation>If the language is not English then translate the weather response text from English into the language we got from the rule.</annotation>
<false>
<call name='Translate' target='Get Translation' async='0' xpos='335' ypos='500' >
<annotation>Do the translation and put the result into the context property OperationReport.</annotation>
<request type='Demo.ZenService.Msg.TranslationRequest' >
<assign property="callrequest.FromLanguage" value="&quot;English&quot;" action="set" />
<assign property="callrequest.TextToTranslate" value="context.OperationReport.Forecast" action="set" />
<assign property="callrequest.ToLanguage" value="context.Language" action="set" />
</request>
<response type='Demo.ZenService.Msg.TranslationResponse' >
<assign property="context.OperationReport.Forecast" value="callresponse.TranslatedText" action="set" />
</response>
</call>
</false>
</if>
</sequence>
<transform name='Transform Response' class='Demo.ZenService.Dtl.OperationToResponseReport' source='context.OperationReport' target='response' xpos='200' ypos='650' >
<annotation>Begin transforming the context property OperationReport into the response object required by the business service that invoked this business process.</annotation>
</transform>
<code name='Add Scale' xpos='200' ypos='750' >
<annotation>Complete the creation of the response object required by the business service by invoking code to place the TempScale value in the object.</annotation>
<![CDATA[ set response.TempScale = context.TempScale]]>
</code>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
