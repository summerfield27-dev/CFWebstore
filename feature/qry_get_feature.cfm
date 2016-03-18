
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve the information for a selected feature. Called by feature.display|print --->

<cfparam name="attributes.Feature_ID" default="0">
<!--- Used to check for invalid query strings --->
<cfparam name="invalid" default="0">

<cfif Session.User_ID>
	<cfset accesskeys = '0,1'>
	<cfset key_loc = ListContainsNoCase(session.userPermissions,'contentkey_list',';')>
	<cfif key_loc>
		<cfset accesskeys = ListAppend(accesskeys,ListLast(ListGetAt(session.userPermissions,key_loc,';'),'^'))>
	</cfif>
</cfif>
<cfparam name="accesskeys" default="0">


<cftry>
	<cfquery name="qry_Get_Feature"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Features F
	WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_ID#">
	AND Approved = 1
	AND Display = 1
	AND NOT EXISTS (SELECT C.Category_ID FROM #Request.DB_Prefix#Categories C 
		INNER JOIN #Request.DB_Prefix#Feature_Category FCat ON C.Category_ID = FCat.Category_ID
		 WHERE FCat.Feature_ID = F.Feature_ID
		AND C.Display = 0 )
	AND (Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Start is null)
	AND (Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Expire is null)
	</cfquery>

	<!--- Check if there are any categories with an access key that this feature belongs to --->
	<cfquery name="qry_check_accesskey" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT C.Category_ID, C.AccessKey FROM #Request.DB_Prefix#Categories C
		INNER JOIN #Request.DB_Prefix#Feature_Category FCat ON C.Category_ID = FCat.Category_ID
		WHERE FCat.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_ID#">
		AND C.AccessKey IS NOT NULL 
		AND C.AccessKey <> 0 
		AND C.AccessKey NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="Yes">)
	</cfquery>

<cfcatch type="Any">
	<cfset invalid = 1>
</cfcatch>
</cftry>
