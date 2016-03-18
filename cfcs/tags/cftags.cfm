<!--- CFWebstore, version 6.50 --->

<!--- Developed for use with CFWebstore e-commerce (www.cfwebstore.com) --->
<!--- Requires CFMX 6 or higher --->
<cffunction name="Q_of_Q" access="public" returntype="query" output="No">

  <cfargument name="SQLString" type="string" required="yes">
  <cfargument name="parentQuery" type="query" required="yes">
  
  <cfset var RecordSet = ''>
  
  <cfquery name="RecordSet" dbtype="query">
	#preserveSingleQuotes(SQLString)#
 </cfquery>
 
 <cfreturn RecordSet>

</cffunction>

<cffunction name="UPD_QUERY" access="public" output="No">

  <cfargument name="SQLString" type="string" required="yes">
  <cfargument name="Datasource" type="string" default="#Request.DS#">
  <cfargument name="username" type="string" default="#Request.DSuser#">
  <cfargument name="password" type="string" default="#Request.DSpass#">
  
  <cfset var RecordSet = ''>
    
  <cfquery name="RecordSet" datasource="#arguments.Datasource#" username="#arguments.username#" password="#arguments.password#">
	#preserveSingleQuotes(SQLString)#
 </cfquery>

</cffunction>


<cffunction name="CF_QUERY" access="public" returntype="query" output="No">

  <cfargument name="SQLString" type="string" required="yes">
  <cfargument name="Datasource" type="string" default="#Request.DS#">
  <cfargument name="username" type="string" default="#Request.DSuser#">
  <cfargument name="password" type="string" default="#Request.DSpass#">
  
  <cfset var RecordSet = ''>
  
  <cfquery name="RecordSet" datasource="#arguments.Datasource#" username="#arguments.username#" password="#arguments.password#">
	#preserveSingleQuotes(SQLString)#
 </cfquery>
 
 <cfreturn RecordSet>

</cffunction>

<cffunction name="cfdump" access="public" returntype="string" output="No">

  <cfargument name="var" type="any" required="yes">
  
  <cfset var strDump = ''>
  
  	<cfsavecontent variable="strDump">
		<cfdump var="#arguments.var#">
	</cfsavecontent>
 
 <cfreturn strDump>

</cffunction>

<cffunction name="strip" access="public" returntype="string" output="No">

  <cfargument name="str" type="String" required="yes">
 
 	<cfreturn Trim(HTMLEditFormat(str))>

</cffunction>

