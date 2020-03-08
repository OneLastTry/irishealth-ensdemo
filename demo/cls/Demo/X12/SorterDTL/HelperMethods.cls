Include Ensemble

/// This class consists of a number of helper methods which are used in the X12 Interchange and Group Sorting demos.
/// The purpose of these methods is to keep the DTL's in the demos as clean looking as possible so that the important
/// details can be more easily visible. 
Class Demo.X12.SorterDTL.HelperMethods
{

/// Takes in an X12 Group <var>oldGroup</var> and returns a new Group with an identical 
/// GS segment and the same schema category. 
ClassMethod CreateNewGroupFromOld(oldGroup As EnsLib.EDI.X12.Document) As EnsLib.EDI.X12.Document
{
	Set tGroup = ##class(EnsLib.EDI.X12.Document).%New($LB("",oldGroup.Separators))
	Do tGroup.PokeDocType(oldGroup.DocType)
	Set tGS = oldGroup.GetSegmentAt("GS").%ConstructClone()
	Set tSC=tGroup.AppendSegment(tGS)
	Set tDataElementSeparator=$E(oldGroup.Separators,1)
	Set tPlaceholder=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(oldGroup.Separators,1,3)_"TransactionSetDocsRef"_tDataElementSeparator_2_tDataElementSeparator))
	Set tSC=tGroup.AppendSegment(tPlaceholder)
	Set tSC = tGroup.AddEndSegment()
	Quit tGroup
}

/// Takes in an X12 Interchange <var>oldInterchange</var> and returns a new Interchange with an identical
/// ISA segment (and TA1 segment, if relevant) and the same schema category. 
ClassMethod CreateNewInterchangeFromOld(oldInterchange As EnsLib.EDI.X12.Document) As EnsLib.EDI.X12.Document
{
	Set tInterchange = ##class(EnsLib.EDI.X12.Document).%New($LB("",oldInterchange.Separators))
	Do tInterchange.PokeDocType(oldInterchange.DocType)
	Set tISA = oldInterchange.GetSegmentAt("ISA").%ConstructClone()
	Set tSC=tInterchange.AppendSegment(tISA)
	Set tTA1 = oldInterchange.GetSegmentAt("TA1")
	If $IsObject(tTA1) {
		Set tTA1 = tTA1.%ConstructClone()
		Set tSC=tInterchange.AppendSegment(tTA1)
	}
	Set tDataElementSeparator=$E(oldInterchange.Separators,1)
	Set tPlaceholder=##class(EnsLib.EDI.X12.Segment).%New($LB("",1,"",$E(oldInterchange.Separators,1,3)_"GroupDocsRef"_tDataElementSeparator_(2+$IsObject(tTA1))_tDataElementSeparator))
	Set tSC=tInterchange.AppendSegment(tPlaceholder)
	Set tSC = tInterchange.AddEndSegment()
	Quit tInterchange
}

/// Takes in an X12 Interchange or Group <var>oldParent</var> and creates from it a new Interchange or Group
/// in the Output variable <var>newParent</var>. Returns a status code.
ClassMethod CreateNewParentFromOld(oldParent As EnsLib.EDI.X12.Document, Output newParent As EnsLib.EDI.X12.Document) As %Status
{
	Set tSC = $$$OK
	If "Interchange"=oldParent.Name {
		Set newParent = ..CreateNewInterchangeFromOld(oldParent)
	} Elseif "Group"=oldParent.Name {
		Set newParent = ..CreateNewGroupFromOld(oldParent)
	} Else {
		Quit $$$ERROR($$$EnsErrGeneral,"Parent document must be Group or Interchange, not a "_oldParent.Name_".")
	}
	Quit tSC
}

/// Adds a child X12 document <var>pChild</var>, (a Transaction Set or a Group) as the child of a Group or Interchange
/// <var>pParent</var>'s DocsRef segment.  <var>pDocsRefSeg</var> is the segment name for the DocsRef segment
/// ("TransactionSetDocsRef" for a Group or "GroupDocsRef" for an Interchange).  Returns a status code.   
ClassMethod AddChildToDocsRef(pChild As EnsLib.EDI.X12.Document, pParent As EnsLib.EDI.X12.Document, pDocsRefSeg As %String) As %Status
{
	Set tSC = $$$OK
	Set tSC = pParent.BuildMap()  Quit:$$$ISERR(tSC) tSC
 	Set index = pParent.GetSegmentIndex(pDocsRefSeg,.tSC) Quit:$$$ISERR(tSC) tSC
  	Set tSC = pParent.AddChild(index,pChild)  Quit:$$$ISERR(tSC) tSC
  	Set tSC = pParent.SetValueAt(1+pParent.GetValueAt((index+1)_":1"),(index+1)_":1")  Quit:$$$ISERR(tSC) tSC
  	Set tSC = pParent.%Save()
  	Quit tSC
}

ClassMethod SaveChanges(pDoc As EnsLib.EDI.X12.Document) As %Status
{
	Set tSC = $$$OK
	Set tSC = pDoc.BuildMap()  Quit:$$$ISERR(tSC) tSC
	Set tSC = pDoc.%Save()
	Quit tSC
}

/// Adds a child X12 document <var>pChild</var> as the child of the appropriate Group or Interchange document(s). 
/// <var>Parent1Array</var> is the array containing X12 documents of the docType that serves as a direct parent to <var>pChild</var>.
/// This means that if <var>pChild</var> is a Transaction Set, then <var>Parent1Array</var> should be an array of Groups,
/// but if <var>pChild</var> is a Group, then <var>Parent1Array</var> should be an array of Interchanges.
/// If relevant, <var>Parent2Array</var> is an array containing X12 documents of the docType that serves as a parent to the parent
/// of <var>pChild</var>.  This means that if <var>pChild</var> is a Transaction Set document, the <var>Parent2Array</var> should
/// be an array of Interchangess, but will otherwise be empty. 
/// <var>key1</var> determines which parent document in <var>Parent1Array</var>, <var>pChild</var> should be a child of. 
/// If no existing parent document is a match, a new parent document based on <var>pOldParent1</var> is created.  In the demos,
/// <var>pOldParent1</var> is the parent document to the original (non-transformed) document.
/// If relevant, <var>key2</var> determines which parent document in <var>Parent2Array</var>, the newly determined parent of 
/// <var>pChild</var> should be a child of.  This parent of the parent may also be created if no document in <var>Parent2Array</var>
/// already matches <var>key2</var>.  Returns status code.
ClassMethod FindParents(pChild As EnsLib.EDI.X12.Document, pOldParent1 As EnsLib.EDI.X12.Document, Parent1Array As %ArrayOfObjects, Parent2Array As %ArrayOfObjects, key1 As %String = "", key2 As %String = "") As %Status
{
	Set tSC = $$$OK
	If (""=key1)||(""=Parent1Array) {
		Quit $$$ERROR($$$EnsErrGeneral,"Both key and array of parents needed to find the parent for this child document")
	}
	Set parent1 = Parent1Array.GetAt(key1)
	If $$$NULLOREF = parent1 {
		Set tSC = ..CreateNewParentFromOld(pOldParent1, .parent1) Quit:$$$ISERR(tSC) tSC
		Set tSC = Parent1Array.SetAt(parent1,key1) Quit:$$$ISERR(tSC) tSC
		If ""'=key2 {
			Set tSC = ..FindParents(parent1,pOldParent1.Parent,Parent2Array,,key2)
		}
	}
	Quit:'$IsObject(parent1) $$$ERROR($$$EnsErrGeneral,"Parent document not found")
	Quit:(parent1.Name'="Interchange")&&(parent1.Name'="Group") $$$ERROR($$$EnsErrGeneral,"Parent document must be Group or Interchange, not a "_parent1.Name_".")
	Quit ..AddChildToDocsRef(pChild,parent1,$Case(parent1.Name,"Interchange":"GroupDocsRef","Group":"TransactionSetDocsRef",:""))
}

}
