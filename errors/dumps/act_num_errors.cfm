<!--- CFWebstore, version 6.50 --->

<cfscript>
/**
* Returns TRUE if the string is a valid CF UUID.
* 
* @param str 	 String to be checked. (Required)
* @return Returns a boolean. 
* @author Jason Ellison (jgedev@hotmail.com) 
* @version 1, November 24, 2003 
*/
function IsCFUUID(str) {  	
 return REFindNoCase("^[0-9A-F]{8}[0-9A-F]{4}[0-9A-F]{4}[0-9A-F]{16}$", str);
}
</cfscript>

<cfscript>
TopDirectory = GetDirectoryFromPath(ExpandPath(Request.StorePath));
variables.thisFolder=TopDirectory & "errors#request.slash#dumps#request.slash#";
</cfscript>

<!--- 
pull the files 
--->
<cfdirectory
	directory="#variables.thisFolder#"
    Name="error_list"
    Sort="dateLastModified DESC">

<cfset variables.FileCount=error_list.RecordCount>
	
<!--- Remove any directories or the main file from the count --->
<cfloop query="error_list">
	<cfif Len(Name) LT 32 OR NOT IsCFUUID(Left(Name, 32))>
		<cfset variables.FileCount = variables.FileCount - 1>
	</cfif>
</cfloop>