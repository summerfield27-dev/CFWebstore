<!--- CFWebstore, version 6.50 --->

<!--- This template keeps track of the last order downloaded by reading and writing to a text file. --->

<cfparam name="attributes.lastordernumber" default="0">
<cfparam name="do" default="read"> <!--- read or write --->

<!--- Set file directory --->
<cfset TopDirectory = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
<cfset FilePath = TopDirectory & "shopping#request.slash#admin#request.slash#download#request.slash#">

<cfset lastorderfile = FilePath & "lastorder.txt">


<cfif do is "read">

	<!--- If the lastorder file does not exist, create it ---->
	<cfif not FileExists(lastorderfile)>
		<cffile
		   action="write"
		   file="#lastorderfile#"
		   output="#attributes.lastordernumber#"> 
	</cfif>

	<!--- Read content of file into variable --->
	<cffile action="READ" file="#lastorderfile#" variable="attributes.lastordernumber"> 
	
<cfelse><!--- Write --->

	<cffile action="write" file="#lastorderfile#" output="#attributes.lastordernumber#"> 
	
</cfif>

