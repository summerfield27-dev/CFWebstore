
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of standard options. Called by product.admin&stdoption=list --->

<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<cfloop index="namedex" list="std_name,std_display,stdrequired,username">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>
		
<cfquery name="qry_get_StdOptions" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT SO.*, U.Username FROM #Request.DB_Prefix#StdOptions SO
	LEFT JOIN #Request.DB_Prefix#Users U ON SO.User_ID = U.User_ID
	WHERE 1 = 1
	<cfif len(trim(attributes.std_name))>
		AND Std_Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.std_name#%">	</cfif>
	<cfif len(trim(attributes.std_display))>
		AND Std_Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.std_display#"> </cfif>
	<cfif len(trim(attributes.stdrequired))>
		AND Std_Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.stdrequired#"> </cfif>
	<cfif len(trim(attributes.username))>
		AND U.Username Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.username#%">	</cfif>
	<!--- If not full product admin, filter by user --->
	<cfif not ispermitted>	
		AND SO.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#"> 
	<cfelseif isDefined("options_for_product")>
		AND SO.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_product.User_ID#">
	</cfif>
</cfquery>
		


