/// Demo utility class for DICOM routing
Class Demo.DICOM.Util.TestRoutingRule Extends Demo.DICOM.Util.AbstractRoutingRule
{

/// Determines if the specified DICOM document should be routed to the
/// named filer. The result of the evaluation is passed back in pRouteToFiler 
/// (which should be passed into this method by reference)
ClassMethod SendToTargetFiler(pDCMDocument As EnsLib.DICOM.Document, pFilerName As %String, Output pRouteToFiler As %Boolean, Output pReason As %String) As %Status
{
	#dim tSC as %Status=$$$OK
	#dim ex as %Exception.AbstractException
	
	$$$ASSERT(pDCMDocument.%Extends("EnsLib.DICOM.Document"))
	
	Try {
		
		#; Initialize return values
		Set pRouteToFiler=0
		Set pReason=""
		
		#; If Modality = CT or CR, then only send to AsyncFiler2
		If $Case(pDCMDocument.GetValueAt("DataSet.Modality"),"CR":1,"CT":1,:0) {
			If pFilerName="AsyncFiler2" {
				Set pRouteToFiler=1
			} Else {
				Set pReason=$$$FormatText($$$Text("Modality %1 not routed to filer %2."),pDCMDocument.GetValueAt("DataSet.Modality"),"AsyncFiler1")	
			}
		} Else {
			#; Otherwise send to both AsyncFiler1 and AsyncFiler2
			If (pFilerName="AsyncFiler1") Set pRouteToFiler=1
			If (pFilerName="AsyncFiler2") Set pRouteToFiler=1
		}
	
	} catch ex {
		Set tSC=ex.AsStatus()
		$$$TRACE($$$FormatText($$$Text("Error in SendToTargetFiler: %1"),ex.DisplayString()))	
	}

	Quit tSC
}

}
