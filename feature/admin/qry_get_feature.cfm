
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the selected feature. Called by feature.admin&feature=edit|related|related_prod|copy --->

<cfparam name="uid" default="">

<!--- if user does not have feature editor permission (2) then show only features
that current user created ---->
<cfparam name="ispermitted" default="1">
<cfmodule template="../../access/secure.cfm"
	keyname="feature"
	requiredPermission="2"
	> 
<cfif not ispermitted>
	<cfset uid = Session.User_ID>	
</cfif>



<cfquery name="qry_get_Feature" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Features
	WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
	<cfif len(uid)>
		AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#uid#">
	</cfif>
</cfquery>
		


