Class Demo.RecordMapBatch.Transform Extends Ens.DataTransformDTL [ DependsOn = (Demo.RecordMapBatch.Map.TrainDataIn.BatchIn, Demo.RecordMapBatch.Map.TrainDataOut.BatchOut) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.RecordMapBatch.Map.TrainDataIn.BatchIn' targetClass='Demo.RecordMapBatch.Map.TrainDataOut.BatchOut' create='new' language='objectscript' >
<assign value='950000' property='$ZSTORAGE' action='set' >
<annotation>Do this to avoid running into &lt;STORE&gt; errors when processing large batches.</annotation>
</assign>
<assign value='source.%Source' property='target.%Source' action='set' />
<assign value='0' property='count' action='set' />
<foreach property='source.Records()' key='k1' >
<annotation>Loop through the records in the batch</annotation>
<if condition='source.Records.(k1).InformationType = "Arrived"' >
<true>
<assign value='count + 1' property='count' action='set' />
<assign value='source.Records.(k1).Trip' property='target.Records.(count).TrainID' action='set' />
<assign value='..If($E(source.Records.(k1).PlatformKey,*) ="N","North","South")' property='target.Records.(count).Direction' action='set' />
<assign value='..ConvertDateTime(source.Records.(k1).Time,"%#m/%#d/%Y %#I:%M:%S %#P","%q(4)")' property='tTime' action='set' />
<assign value='..Piece(tTime,",",1)' property='target.Records.(count).Date' action='set' />
<assign value='..Piece(tTime,",",2)' property='target.Records.(count).Time' action='set' />
<code>
<![CDATA[ Set tStation = $Case($E(source.Records.GetAt(k1).PlatformKey,2,*-1),"ALE":"Alewife","AND":"Andrew","ASH":"Ashmont","BRA":"Braintree","BRO":"Broadway","CEN":"Central Square","MGH":"Charles/MGH","DAV":"Davis","DTC":"Downtown Crossing","FIE":"Fields Corner","HAR":"Harvard Square","JFK":"JFK/UMass","KEN":"Kendall","NQU":"North Quincy","PRK":"Park Street","POR":"Porter Square","QUA":"Quincy Adams","QUC":"Quincy Center","SAV":"Savin Hill","SHA":"Shawmut","SOU":"South Station","WOL":"Wollaston",:$E(source.Records.GetAt(k1).PlatformKey,2,*-1))]]></code>
<assign value='tStation' property='target.Records.(count).Station' action='set' />
<code>
<annotation>Remove the current records from memory to reduce the memory used by this process.</annotation>
<![CDATA[ Do source.Records.%UnSwizzleAt(k1)
 Do target.Records.GetAt(count).%Save(0)
 Do target.Records.%UnSwizzleAt(count)]]></code>
</true>
</if>
</foreach>
</transform>
}

}
