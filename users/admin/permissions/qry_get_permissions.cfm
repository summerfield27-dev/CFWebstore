
<!--- CFWebstore, version 6.50 --->

<!--- Retrieve the permissions for the selected user or group. Called by act_set_permissions.cfm --->

<!--- attributes.type: user | group , attributes.ID: user_id | group_id --->

<cfset attributes.type = Trim(sanitize(attributes.type))>

<cfquery name="qry_get_permissions" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Permissions
	FROM #Request.DB_Prefix##attributes.type#s
	WHERE #attributes.type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
</cfquery>

		
		


