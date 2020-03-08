Class Demo.DICOM.Operation.File Extends Ens.BusinessOperation
{

/// This is the directory where the local files will be stored
Parameter SETTINGS = "FileStorageDirectory";

/// This is the directory where the incoming DICOM files will be stored
Property FileStorageDirectory As %String(MAXLEN = "") [ InitialExpression = "/" ];

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim tFile As EnsLib.DICOM.File
	#dim tFileName As %String
	try {
		
		#; We should only ever see DICOM Documents here
		$$$ASSERT(pRequest.%Extends("EnsLib.DICOM.Document"))
		
		#; Create a DICOM File from the DICOM document
		Set tSC=##class(EnsLib.DICOM.File).CreateFromDocument(pRequest,.tFile)
		If $$$ISERR(tSC) Quit
		
		#; Create a unique filename
		Set tFileName=..NewFilename(..FileStorageDirectory)
		
		#; Create a new file with a unique name and the dcm extension in the target directory
		Set tSC=tFile.Save(tFileName)
		
	} catch(e) {
		Set tSC=e.AsStatus()
	}
	Quit tSC
}

/// Create a new file name within the specified directory
ClassMethod NewFilename(dir) As %String [ CodeMode = expression ]
{
##class(%File).NormalizeDirectory(dir)_(##class(%FileBinaryStream).NewFileName("dcm"))
}

}
