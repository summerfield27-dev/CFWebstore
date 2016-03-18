
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of standard addons. Called by product.admin&stdaddon=list --->

<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<cfloop index="namedex" list="std_name,std_type,std_display,stdrequired,username">
	<cfparam name="attributes[namedex]" default="">
</cfloop>
		
<cfquery name="qry_get_Stdaddons" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT SA.*, U.Username FROM #Request.DB_Prefix#StdAddons SA
	LEFT JOIN #Request.DB_Prefix#Users U ON SA.User_ID = U.User_ID
	WHERE 1 = 1
	<cfif len(trim(attributes.std_name))>
		AND SA.Std_Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.std_name#%">	</cfif>
	<cfif len(trim(attributes.std_type))>
		AND SA.Std_Type Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.std_type#%">	</cfif>
	<cfif len(trim(attributes.std_display))>
		AND SA.Std_Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.std_display#"> </cfif>
	<cfif len(trim(attributes.stdrequired))>
		AND SA.Std_Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.stdrequired#"> </cfif>
	<cfif len(trim(attributes.username))>
		AND U.Username Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.username#%">	</cfif>
	<!--- If not full product admin, filter by user --->
	<cfif not ispermitted>	
		AND SA.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID# ">
	<cfelseif isDefined("addons_for_product")>
		AND SA.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_product.User_ID#">
	</cfif>
</cfquery>
		


