Include Ensemble

/// Utility class for DICOM async routing
/// Extend this class and implement method <method>SendToTargetFiler</method> to define routing rules for the async dispatcher 
Class Demo.DICOM.Util.AbstractRoutingRule
{

Parameter DOMAIN = "ENSDEMO";

/// Determines if the specified DICOM document should be routed to the
/// named filer. The result of the evaluation is passed back in pRouteToFiler 
/// (which should be passed into this method by reference)
ClassMethod SendToTargetFiler(pDCMDocument As EnsLib.DICOM.Document, pFilerName As %String, Output pRouteToFiler As %Boolean, Output pReason As %String) As %Status
{
	#; SubclassResponsibility
	Quit $$$OK
}

}
