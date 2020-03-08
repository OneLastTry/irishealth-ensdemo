Include Ensemble

IncludeGenerator %occInclude

/// The methods in this class are intended as an example for remediation of situations where your message classes do not have appropriate delete triggers to clean up after themselves.
/// Their operation depends on how your class definitions are constructed. They are not able to purge every conceivable class structure.
Class Demo.Util.CleanupSet Extends %RegisteredObject
{

/// Caution: this method is intended only for remediation of situations where your message classes do not have appropriate delete triggers to clean up after themselves. Its operation depends on your class definitions and is not able to purge every conceivable class structure. It is up to you to examine and test the operation of this method to verify that it is useful in your environment.
/// Return an array of all persistent or stream classes referred to as property or collection types in any of the body classes
/// identified to be purged in the date range given by pDaysToKeep, or in any of their properties' properties, etc.
/// Also include message headers and identify the range of message ids to be deleted for each class based on pDaysToKeep.
ClassMethod GetDeepPurgeSet(Output pSet, pDaysToKeep As %Integer = 7, pUseIdRange As %Boolean = 0) As %Status
{
	Kill pSet  Set SQLCODE=0, tSC=$$$OK
	#; Find the highest header ID that is lower than the given time cutoff
	Set tTopKillHdr="", tDoNotDeleteDate = $$$timeUTCHtoUTC($s($ZTimezone'<0:($H-pDaysToKeep+1)_","_($ZTimezone*60),1:($H-pDaysToKeep)_","_($ztimezone*60+86400)))
	&sql(Select Top 1 ID Into :tTopKillHdr From Ens.MessageHeader Where (TimeCreated < :tDoNotDeleteDate) Order By ID Desc)
	If SQLCODE=100 { Set tTopKillHdr="" }
	ElseIf SQLCODE { Quit $$$ERROR($$$EnsErrGeneral,"Couldn't find DaysToKeep ("_pDaysToKeep_") message header Id in GetMessagePurgeSet, sqlcode="_SQLCODE) }
	Set tSC=..GetBodiesCleanupSet(.pSet,1,tTopKillHdr,pUseIdRange)
	Set:$$$ISOK(tSC) pSet("Ens.MessageHeader")=tTopKillHdr
	Quit tSC
}

/// Caution: this method is intended only for remediation of situations where your message classes do not have appropriate delete triggers to clean up after themselves. Its operation depends on your class definitions and is not able to purge every conceivable class structure. It is up to you to examine and test the operation of this method to verify that it is useful in your environment.
/// Return an array of all persistent or stream classes used as message bodies.
/// If pIncludeProps=1, include persistent or stream classes referred to as property or collection types in any of the body classes, or in any of their properties' properties, etc.
/// Also note that no cleanup at all is possible if the message body class has a custom IDKEY because we can't depend on these to be allocated sequentially.
ClassMethod GetBodiesCleanupSet(Output pSet, pIncludeProps As %Boolean = 1, pTopKillHdr As %Integer = "", pUseIdRange As %Boolean = 0) As %Status
{
	Kill pSet  Set SQLCODE=0, tSC=$$$OK
	#; Find all the body classes referenced in the target 
	If ""=pTopKillHdr {
		#; No top header Id to kill is given - search them all (The target headers have already been purged; we're relying on the remaining ones to reference the same classes)
		&sql(Declare C1 Cursor For Select %Exact(MessageBodyClassname) Into :tBodyClass From Ens.MessageHeader Group By MessageBodyClassname)
		&sql(OPEN C1) For { &sql(FETCH C1)  Quit:SQLCODE  Continue:""=tBodyClass
			Set tCustomIDKEY=..findCustomIDKEY(tBodyClass)
			If ""'=tCustomIDKEY Set pSet("_CustomIDKEY")=1, pSet(tBodyClass)="_CustomIDKEY:"_tCustomIDKEY  Continue
			#; Find the top remaining ID of this class NOT referenced from any header (we want to delete all unreferenced ones)
			Set:'$$$IsdefObject(tRS) tRS = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set tSC=tRS.Prepare("Select Top 1 ID From "_$$$ClassSQLTable(tBodyClass)_" b Where (Select ID from Ens.MessageHeader h Where h.MessageBodyClassname = '"_tBodyClass_"' And h.MessageBodyId = b.ID) Is Null Order By b.ID Desc")
			Set:$$$ISOK(tSC) tSC=tRS.Execute()
			If $$$ISOK(tSC) && tRS.Next(.tSC) && $$$ISOK(tSC) {
				Set tTopKillId=tRS.Data("ID")
			}
			If $$$ISERR(tSC) Set tSC=$$$ERROR($$$EnsErrGeneral,"Couldn't find message body Id for class "_tBodyClass_" in GetClassCleanupSet: "_$$$StatusDisplayString(tSC))  Quit
			Set tSC1=tRS.Close()  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Quit:$$$ISERR(tSC)
			Continue:+tTopKillId'=tTopKillId ; classes with IDKEYs that are not integers can't be ordered properly
			Set tSC=..cleanupHelper(.pSet,tBodyClass,pIncludeProps,tTopKillId,pUseIdRange,"")  Quit:$$$ISERR(tSC)
		} Set tCode=SQLCODE &sql(CLOSE C1) Set:'SQLCODE SQLCODE=tCode
	} Else {
		#; A top header Id is given, meaning the highest header ID to be purged. Only search the headers lower than or equal to it
		&sql(Declare C2 Cursor For Select %Exact(MessageBodyClassname) Into :tBodyClass From Ens.MessageHeader Where ID<=:pTopKillHdr Group By MessageBodyClassname)
		&sql(OPEN C2) For { &sql(FETCH C2)  Quit:SQLCODE  Continue:""=tBodyClass
			Set tCustomIDKEY=..findCustomIDKEY(tBodyClass)
			If ""'=tCustomIDKEY Set pSet("_CustomIDKEY")=1, pSet(tBodyClass)="_CustomIDKEY:"_tCustomIDKEY  Continue
			#; Find the top remaining ID of this class referenced from a header to be purged (we want to delete that body and all earlier bodies)
			&sql(Select Top 1 MessageBodyId Into :tTopKillId From Ens.MessageHeader Where MessageBodyClassname = :tBodyClass And ID<=:pTopKillHdr Order By MessageBodyId Desc)
			; there must be one for a header being purged or we wouldn't have found the classname
			Quit:SQLCODE
			Continue:+tTopKillId'=tTopKillId ; classes with IDKEYs that are not integers can't be ordered properly

			Set tSC=..cleanupHelper(.pSet,tBodyClass,pIncludeProps,tTopKillId,pUseIdRange,"")  Quit:$$$ISERR(tSC)
		} Set tCode=SQLCODE &sql(CLOSE C2) Set:'SQLCODE SQLCODE=tCode
	}
	If SQLCODE&&(SQLCODE'=100) Set tSC1=$$$ERROR($$$EnsErrGeneral,"Couldn't find message body class and Id in GetBodiesCleanupSet, sqlcode="_SQLCODE), tSC=$$$ADDSC(tSC,tSC1)
	Quit tSC
}

/// Caution: this method is intended only for remediation of situations where your message classes do not have appropriate delete triggers to clean up after themselves. Its operation depends on your class definitions and is not able to purge every conceivable class structure. It is up to you to examine and test the operation of this method to verify that it is useful in your environment.
/// Return an array of all persistent or stream classes referred to as property or collection types in the given body classes, or in any of its properties' properties, etc.
/// If pUseIdRange is true, also annotate the array with the top ID to be killed for each class. If this ID is not supplied, this method will record the highest ID of the given class not referred to by any header.
/// Also note that no cleanup at all is possible if the message body class has a custom IDKEY because we can't depend on these to be allocated sequentially.
/// pClass may be a single classname, a comma separated list of classnames, or an array of classnames indexed either by ordinal or by name.
/// pTopKillId is a corresponding structure containing the highest ID to be killed / purged for each class. If pClass is an array indexed by classname, this ID may be supplied instead as the node value in pClass.
ClassMethod GetClassCleanupSet(Output pSet, pClass As %String, pTopKillId = 0, pUseIdRange As %Boolean = 0) As %Status
{
	Kill pSet  Set SQLCODE=0, tSC=$$$OK
	Set tKey="" For { If $D(pClass)=10 {      Set tTop="", tKey=$O(pClass(tKey),1,tTop)  Quit:""=tKey  Set tBodyClass=tKey, tTopId=$G(pTopKillId(tKey),tTop) }
					ElseIf (+pClass=pClass) {         Set tKey=tKey+1            Quit:tKey>pClass    Set tBodyClass=$G(pClass(tKey)), tTopId=$G(pTopKillId(tKey)) }
					Else { Set:""=tKey nClasses=$L(pClass,",")  Set tKey=tKey+1  Quit:tKey>nClasses  Set tBodyClass=$P(pClass,",",tKey), tTopId=$P(pTopKillId,",",tKey) }
		Set tBodyClass=$ZStrip(tBodyClass,"<>WC")  Continue:""=tBodyClass
		Set tCustomIDKEY=..findCustomIDKEY(tBodyClass)
		If ""'=tCustomIDKEY Set pSet(tBodyClass)="_CustomIDKEY:"_tCustomIDKEY, tSC=$$$ERROR($$$EnsErrGeneral,"Class "_tBodyClass_" has a custom IDKEY '"_tCustomIDKEY_"'; cannot use order to find orphaned IDs")  Quit
		If 'tTopId && pUseIdRange {
			#; Find the top remaining ID of this class NOT referenced from any header (we want to delete all unreferenced ones)
			Set:'$$$IsdefObject(tRS) tRS = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			Set tSC=tRS.Prepare("Select Top 1 ID From "_$$$ClassSQLTable(tBodyClass)_" b Where (Select ID from Ens.MessageHeader h Where h.MessageBodyClassname = '"_tBodyClass_"' And h.MessageBodyId = b.ID) Is Null Order By b.ID Desc")
			Set:$$$ISOK(tSC) tSC=tRS.Execute()
			If $$$ISOK(tSC) && tRS.Next(.tSC) && $$$ISOK(tSC) {
				Set tTopId=tRS.Data("ID")
			}
			If $$$ISERR(tSC) Set tSC=$$$ERROR($$$EnsErrGeneral,"Couldn't find message body Id for class "_tBodyClass_" in GetClassCleanupSet: "_$$$StatusDisplayString(tSC))  Quit
			Set tSC1=tRS.Close()  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Quit:$$$ISERR(tSC)
		}
		Set tSC=..cleanupHelper(.pSet,.tBodyClass,1,tTopId,pUseIdRange,"")  Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

/// Caution: this method is intended only for remediation of situations where your message classes do not have appropriate delete triggers to clean up after themselves. Its operation depends on your class definitions and is not able to purge every conceivable class structure. It is up to you to examine and test the operation of this method to verify that it is useful in your environment.
/// This method's operation is guided by 'cleanup set' array.  The methods GetDeepPurgeSet(), GetBodiesCleanupSet(), and GetClassCleanupSet() each represent a different way of constructing such a 'cleanup set'.
/// NB! After using one of those methods to construct a 'cleanup set', you or your code should examine it to remove any entries for classes that should not be purged.  For example if a message refers to a permanent patient record, you should remove the patient record class from the 'cleanup set' array before invoking this method.  Otherwise it will delete any patient records referred to by messages being purged.
/// Removes all persistent object instances of classes used as message bodies that have IDs lower than the first one used as a message body.
/// This can clean up bodies that were 'orphaned' by purging headers without the 'BodiesToo' option.
/// It also removes persistent objects referred to as property or collection types in any of the classes being cleaned, or in any of their properties' properties.
/// Note that pKeepIntegrity is ignored for a cleanup set produced by GetBodiesCleanupSet because it does not include headers to purge.
/// If possible it will do bulk deletes of each class in the set. Otherwise it will delete all the properties of each object by recursive descent.
/// Bulk ID Range delete will be used if pUseIdRange=1 and:
/// - pKeepIntegrity is false or MessageHeaders are not included (i.e. GetDeepPurgeSet was not used)
/// - the set has no node set("_hasStream")=1
/// - the set has no node set("_customIDKEY")=1
/// - No class node present has a "Top ID to purge" value
/// NB! Bulk ID Range delete only makes sense if all the child property objects in your messages are allocated and stored in sequence with the message headers themselves. This will be nearly true if all message objects are created fresh and then immediately sent as Ensemble message bodies.
/// Bulk ID Range delete might be faster or slower than recursive object property deleting, depending on your class definitions and the indices they define.
/// Also note: no cleanup at all is possible if the message body class is a stream or has a custom IDKEY because we can't depend on these to be ordered sequentially.
ClassMethod PurgeCleanupSet(ByRef pSet, Output pDeletedCount As %Integer, pKeepIntegrity As %Boolean = 0, pUseIdRange As %Boolean = 0) As %Status
{
	Quit:$D(pSet)<10 $$$ERROR($$$EnsErrGeneral,"Empty cleanup set")
	Quit:$D(pSet("Ens.MessageHeader"))&&pKeepIntegrity ..purgeDeepIntegrity(.pSet,.pDeletedCount)
	Kill pDeletedCount  Set tSC=$$$OK, pDeletedCount=0, pDeletedCount("bodies")=0, tTopKillHdr=""

	If $D(pSet("Ens.MessageHeader"),tTopKillHdr) {
		#; Loop over headers, purge bodies and then header
		If pUseIdRange {
			Set tRS=##class(%ResultSet).%New("%DynamicQuery:SQL") ; reusable RS
			Set bod="" For { Set tTopKillId="", bod=$O(pSet("_body",bod),1,tTopKillId)  Quit:""=bod
				Set:""=tTopKillId tTopKillId=$G(pSet(bod))
				Set tSC=..purgeIdRange(.pSet,.pDeletedCount,bod,tTopKillId,.tRS)  Quit:$$$ISERR(tSC)
			} Quit:$$$ISERR(tSC) tSC
		}
		&sql(DECLARE C5 CURSOR FOR
			Select ID,MessageBodyId,MessageBodyClassName Into :tID,:tBodyId,:tBodyClass From Ens.MessageHeader Where ID <= :tTopKillHdr)
		&sql(OPEN C5) For { &sql(FETCH C5)  Quit:SQLCODE
			If ""'=tBodyClass&&'pUseIdRange&&'$G(pSet(tBodyClass,"_done")) {
				//Set tObj=$zobjclassmethod(tBodyClass,"%OpenId",tID,,.tSC)  Quit:$$$ISERR(tSC)
				Set tSC=..purgePropObj(.pSet,.pDeletedCount,tBodyClass,tBodyId,0)
				Quit:($$$ISERR(tSC)&&'$$$StatusEquals(tSC,$$$DeleteObjectNotFound,$$$FileCanNotDelete,$$$NotAnInstanceError))
				Set tSC=$$$OK, pDeletedCount("bodies")=pDeletedCount("bodies")+1
			}
			Set %ROWCOUNT=0
			&sql(Delete From Ens.MessageHeader Where ID=:tID)
			Set pDeletedCount=pDeletedCount+%ROWCOUNT
		} Set tCode=SQLCODE &sql(CLOSE C5) Set:'SQLCODE SQLCODE=tCode
		Set:SQLCODE&&(SQLCODE'=100) tSC=$$$ADDSC(tSC,$$$ERROR($$$EnsErrGeneral,"Purge error at ID "_tID_"; SQLCODE = "_SQLCODE))
	} Else { ; no MessageHeader range
		#; We have no header to iterate; this is a cleanup and we must have ID ranges for the top body classes
		Set tRS=##class(%ResultSet).%New("%DynamicQuery:SQL") ; reusable RS
		Set bod="" For { Set tTopKillId="", bod=$O(pSet("_body",bod),1,tTopKillId)  Quit:""=bod
			Set:""=tTopKillId tTopKillId=$G(pSet(bod))
			If 'tTopKillId Set tSC=$$$ERROR($$$EnsErrGeneral,"Body must have a numeric value for top '"_bod_"' ID to purge, got '"_tTopKillId_"'")  Quit
			If pUseIdRange {
				Set tSC=..purgeIdRange(.pSet,.pDeletedCount,bod,tTopKillId,.tRS)  Quit:$$$ISERR(tSC)
			} Else {
				#; Loop over all bodies to be purged for this body class
				//Set tSC=..purgeSetLoop(.pSet,.pDeletedCount,bod,pUseIdRange,tTopKillId,.tRS)  Quit:$$$ISERR(tSC)		
				#; Delete objects one-by-one (until we get down to a level where we can purge by ID if pUseIdRange=1)
				Set tSC=tRS.Prepare("Select %ID From "_$$$ClassSQLTable(bod)_" Where %ID <= "_tTopKillId)
				Set:$$$ISOK(tSC) tSC=tRS.Execute()
				While $$$ISOK(tSC) && tRS.Next(.tSC) && $$$ISOK(tSC) {
					Set tID=tRS.Data("%ID")
					Set tSC=..purgePropObj(.pSet,.pDeletedCount,bod,tID,0)
					Quit:($$$ISERR(tSC)&&'$$$StatusEquals(tSC,$$$DeleteObjectNotFound,$$$FileCanNotDelete,$$$NotAnInstanceError))
					Set tSC=$$$OK, pDeletedCount("bodies",bod)=$G(pDeletedCount("bodies",bod))+1
				} Set tSC1=tRS.Close()  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			}
		}
	}
	Quit tSC
}

ClassMethod purgeDeepIntegrity(ByRef pSet, Output pDeletedCount As %Integer) As %Status [ Internal ]
{
	Set tTopKillId=$G(pSet("Ens.MessageHeader"))  Quit:'tTopKillId $$$ERROR($$$EnsErrGeneral,"Must have purge limit id for purge with KeepIntegrity and UseIdRange")
	
	&sql(DECLARE C6 CURSOR FOR
		Select ID,MessageBodyId,MessageBodyClassName Into :tID,:tBodyId,:tBodyClass From Ens.MessageHeader h
			Where (ID <= :tTopKillId)
				And 0 = ( Select Count(*) From Ens.MessageHeader
							Where (SessionId = h.SessionId)
								And (Status<>$$$eMessageStatusCompleted)
								And (Status<>$$$eMessageStatusAborted)
								And (Status<>$$$eMessageStatusError)
								And (Status<>$$$eMessageStatusDiscarded) )
		)
	&sql(OPEN C6)
	Set tSC=$$$OK  For { &sql(FETCH C6)  Quit:SQLCODE
		If ""'=tBodyClass&&'$G(pSet(tBodyClass,"_done")) {
			Set tSC=..purgePropObj(.pSet,.pDeletedCount,tBodyClass,tBodyId,0)  Quit:$$$ISERR(tSC)
			Set pDeletedCount("bodies")=pDeletedCount("bodies")+1
		}
		Set %ROWCOUNT=0
		&sql(Delete From Ens.MessageHeader Where ID=:tID)
		Set pDeletedCount=pDeletedCount+%ROWCOUNT
	} Set tCode=SQLCODE &sql(CLOSE C6) Set:'SQLCODE SQLCODE=tCode
	Quit tSC
}

ClassMethod purgePropObj(ByRef pSet, ByRef pDeletedCount, pClass As %String, pID As %String = "", pUseIdRange As %Boolean, pRS As %ResultSet) As %Status [ Internal ]
{
	Quit:'$D(pSet(pClass),tTopKillId)||$G(pSet(pClass,"_done")) $$$OK
	Set tSC=$$$OK
	If pUseIdRange&&tTopKillId {
		Quit ..purgeIdRange(.pSet,.pDeletedCount,pClass,tTopKillId,.pRS)
	}
	#; First delete the object's persistent properties
	Set tObj=$$$NULLOREF,prop=""  For { Set prop=$O(pSet(pClass,"_props",prop),1,proptype)  Quit:""=prop
		Continue:""=proptype||$G(pSet(proptype,"_done"))
		#; Open object
		Set:'$IsObject(tObj) tObj=$zobjclassmethod(pClass,"%OpenId",pID,,.tSC)  Quit:$$$ISERR(tSC)

		Set tTopKillPropId=$G(pSet(proptype))
		If ""'=$G(pSet(pClass,"_props",prop,"_collection")) {
			Set tPropObj=$property(tObj,prop)
			Set tKey="" For { Set tItemId=tPropObj.GetObjectIdNext(.tKey)  Quit:""=tKey
				Set tSC1=..purgePropObj(.pSet,.pDeletedCount,proptype,tItemId,pUseIdRange,pRS)
				Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			}
		} ElseIf $Case($E(tTopKillPropId,1,$L("_CustomIDKEY:")),"_Stream":1,"_CustomIDKEY:":1,:'(pUseIdRange&&tTopKillPropId)) {
			Set tPropObj=$property(tObj,prop)
			Set:$IsObject(tPropObj) tSC=..purgePropObj(.pSet,.pDeletedCount,proptype,tPropObj.%Id(),pUseIdRange,pRS)
		} Else { ; purge range not just one instance
			Set tSC=..purgePropObj(.pSet,.pDeletedCount,proptype,"",pUseIdRange,pRS)
		}
	} Quit:($$$ISERR(tSC)&'$$$StatusEquals(tSC,$$$DeleteObjectNotFound,$$$FileCanNotDelete,$$$NotAnInstanceError)) tSC 
	
	; Done with the properties, now do the object
	Kill tObj  Set tSC=$$$OK
	Set:""'=pID tSC=$zobjclassmethod(pClass,"%DeleteId",pID)
	If $$$ISERR(tSC) {
		Set tOK=$$$StatusEquals(tSC,$$$DeleteObjectNotFound,$$$FileCanNotDelete,$$$NotAnInstanceError) ; || ($$$StatusEquals(tSC,$$$NotAnInstanceError) && '$zobjclassmethod(aClass(pClass,"extent"),"%ExistsId",pId))
		If tOK { Set tSC=$$$OK }
		ElseIf '$G(aClass(pClass,"doneErr")) { Set aClass(pClass,"doneErr")=1  $$$LOGWARNING("Failed to purge body with BodyClassname='"_pClass_"', ID="_pID_" :"_$$$StatusDisplayString(tSC)) }
	} Else {
		Set pDeletedCount("bodies",pClass)=$G(pDeletedCount("bodies",pClass))+1
	}
	Quit tSC
}

ClassMethod purgeIdRange(ByRef pSet, Output pDeletedCount As %Integer, pClass As %String, pTopKillId As %Integer, pRS As %ResultSet) As %Status [ Internal ]
{
	Quit:'pTopKillId $$$ERROR($$$EnsErrGeneral,"Must have a numeric value for top '"_pClass_"' ID to purge, got '"_pTopKillId_"'")
	
	#; Go through the property classes of this class and delete the range for them all
	Set tSC=$$$OK
	Set chi="" For { Set tChildTopKillId="", chi=$O(pSet(pClass,"_child",chi))  Quit:""=chi
		Set tChildTopKillId=$G(pSet(chi))  Continue:'tChildTopKillId||$G(pSet(chi,"_done"))
		Set tSC=..purgeIdRange(.pSet,.pDeletedCount,chi,tChildTopKillId,.pRS)  Quit:$$$ISERR(tSC)
	}
	Quit:$$$ISERR(tSC) tSC
	Quit:$G(pSet(pClass,"_done")) $$$OK
	
	#; Now do this class and delete the range for it
	Set tSC=pRS.Prepare("Select %ID From "_$$$ClassSQLTable(pClass)_" Where %ID <= "_pTopKillId)
	Set:$$$ISOK(tSC) tSC=pRS.Execute()
	If $$$ISOK(tSC) {
		While pRS.Next(.tSC) { Quit:$$$ISERR(tSC)
			Set tID=pRS.GetData(1)
			Set tSC1=$zobjclassmethod(pClass,"%DeleteId",tID)
			If $$$ISERR(tSC1)&&'$G(pSet(pClass,"_doneErr")) {
				Set tOK=$$$StatusEquals(tSC1,$$$DeleteObjectNotFound,$$$FileCanNotDelete,$$$NotAnInstanceError) ; || ($$$StatusEquals(tSC1,$$$NotAnInstanceError) && '$zobjclassmethod(aClass(%tBodyClassname,"extent"),"%ExistsId",%tBodyId))
				If 'tOK { Set pSet(pClass,"_doneErr")=1, tSC=$$$ADDSC(tSC,tSC1)  $$$LOGWARNING("Failed to purge body "_tID_", BodyClassname='"_chi_"':"_$$$StatusDisplayString(tSC1)) }
			}
			Set pDeletedCount("bodies",pClass)=$G(pDeletedCount("bodies",pClass))+1
		}
	}
	Set tSC1=pRS.Close()  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	If $$$ISERR(tSC) Set tSC=$$$ERROR($$$EnsErrGeneral,"%DeleteID From "_pClass_" Where %ID <= "_pTopKillId_" failed: "_$$$StatusDisplayString(tSC))  Quit tSC
	Set pSet(pClass,"_done")=1
	Quit tSC
}

ClassMethod cleanupHelper(ByRef pSet, pClass As %String, pIncludeProps As %Boolean, pTopKillId As %Integer, pUseIdRange As %Boolean, pParent As %String) As %Status [ Internal ]
{
#Dim tProp As %Dictionary.CompiledProperty
	Set SQLCODE=0, tSC=$$$OK, $ZT="Trap"
	Set:""=pTopKillId pUseIdRange=0
	If ""=pParent {
		Quit:$D(pSet("_body",pClass)) $$$ERROR($$$EnsErrGeneral,"Body class '"_pSet_"' already exists in Cleanup Set")
		If $D(pSet(pClass))&&'pUseIdRange Set pSet("_body",pClass)=pTopKillId  Quit $$$OK
	} ElseIf 'pUseIdRange&&pIncludeProps {
		Quit:$D(pSet(pParent,"_child",pClass)) $$$OK
		If $D(pSet(pClass)) {
			Merge pSet(pParent,"_child")=pSet(pClass,"_child")
			Set pSet(pParent,"_child",pClass)=""
			Quit $$$OK
		}
	}
	Set tDef=##class(%Dictionary.CompiledClass).%OpenId(pClass,,.tSC)  Quit:$$$ISERR(tSC) tSC
	If tDef.ClassType'="persistent" {
		If (""=pParent)&&(tDef.ClassType="stream") {
			$$$ASSERT($zobjclassmethod(pClass,"%Extends","%Stream.Object"))
			Set tHasStream=1
			Set pSet(pClass)="_Stream"
		}
		Quit $$$OK ; ignore classes with no storage
	}
	Set:pTopKillId>$G(pSet(pClass),pTopKillId-1) pSet(pClass)=pTopKillId
	Set (tHasStream,tHasIDKEY)=0
	If pIncludeProps {
		Set propkey="" For { Set tProp=tDef.Properties.GetNext(.propkey)  Quit:""=propkey||'$IsObject(tProp)
			Continue:""=tProp.Type 
			Set tIsCollection=..isCollection(tProp)
			Continue:3=tIsCollection ; Relationship properties fend for themselves

			Set tPropType=$$$comClassKeyGet(tProp.Type,$$$cCLASSclasstype)
			Set tTableName=$$$comClassKeyGet(tProp.Type,$$$cCLASSsqltablename)
			Set tUseIdRange=pUseIdRange

			If ""'=tTableName&&tProp.Storable&&(tPropType="persistent") {
				Set tCustomIDKEY=..findCustomIDKEY(tProp.Type)
				If ""'=tCustomIDKEY {
					Set tPropTopKillId="", tUseIdRange=0, pSet(tProp.Type)="_CustomIDKEY:"_tCustomIDKEY
					Set tHasIDKEY=1
				} ElseIf pUseIdRange&&(""'=tProp.SqlFieldName) {
					#; Find the top remaining ID of the property class NOT referenced from this class (we want to delete all unreferenced ones)
					Set:'$D(tTopKillObj) tTopKillObj=$zobjclassmethod(pClass,"%OpenId",pTopKillId,,.tSC)  Quit:$$$ISERR(tSC)
					Set tPropObj=$property(tTopKillObj,tProp.Name)
					If '$IsObject(tPropObj) {
						Set tPropTopKillId=""
					} Else {
						If tIsCollection {
							Set tKey="",tPropTopKillId="" For { Set tItemId=tPropObj.GetObjectIdNext(.tKey)  Quit:""=tKey
								Set:tPropTopKillId<tItemId tPropTopKillId=tItemId
							}
						} Else {
							$$$ASSERT(tPropObj.%Extends("%Library.Persistent"))
							Set tPropTopKillId=tPropObj.%Id()
						}
					}
				} Else {
					Set tPropTopKillId=""
				}
				Set tSC=..cleanupHelper(.pSet,tProp.Type,pIncludeProps,tPropTopKillId,tUseIdRange,pClass)  Quit:$$$ISERR(tSC)
				Set pSet(pClass,"_child",tProp.Type)=""
				Set pSet(pClass,"_props",tProp.Name)=tProp.Type
				Set:tIsCollection pSet(pClass,"_props",tProp.Name,"_collection")=tProp.RuntimeType
			}
			ElseIf tPropType="stream" {
				$$$ASSERT($zobjclassmethod(tProp.Type,"%Extends","%Stream.Object"))
				Set tHasStream=1
				Set pSet(tProp.Type)="_Stream"
				Set pSet(pClass,"_props",tProp.Name)=tProp.Type
				Set:tIsCollection pSet(pClass,"_props",tProp.Name,"_collection")=tProp.RuntimeType
			}
		} ; For { propkey
	} ; If pIncludeProps
	If ""=pParent {
		Set pSet("_body",pClass)=""
	} Else {
		If pIncludeProps Merge pSet(pParent,"_child")=pSet(pClass,"_child")  Set pSet(pParent,"_child",pClass)=""
	}
Exit
	Quit tSC
Trap
	Set tSC=$$$SystemError
	Goto Exit
}

ClassMethod findCustomIDKEY(pClass As %String) As %String [ Internal ]
{
#Dim tIndex As %Dictionary.CompiledIndex
	Set tDef=##class(%Dictionary.CompiledClass).%OpenId(pClass,,.tSC)  Quit:$$$ISERR(tSC)||'$IsObject(tDef) ""
	Set tKey="" For { Set tIndex=tDef.Indices.GetNext(.tKey)  Quit:""=tKey||'$IsObject(tIndex)
		Quit:tIndex.IdKey&&'tIndex.CompilerGenerated
	}
	Quit:""'=tKey&&$IsObject(tIndex) tIndex.Name
	Quit ""
}

/// Return 0 for not collection, 1 for list, 2 for array, 3 for relationship
ClassMethod isCollection(pProp As %Dictionary.CompiledProperty) As %String [ Internal ]
{
	//Quit:""=tProp.RuntimeType||(tProp.RuntimeType=tProp.Type)||'$zobjclassmethod(tProp.RuntimeType,"%Extends","%Collection.AbstractIterator") 0
	Quit:""=pProp.Collection 0
	Quit:$zobjclassmethod(pProp.RuntimeType,"%Extends","%Library.RelationshipObject") 3
	Quit:"array"=pProp.Collection 2
	Quit 1
}

}
