
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of permissions for the selected group --->

<cfquery name="qry_get_perm_list" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT * FROM #Request.DB_Prefix#Permissions P, #Request.DB_Prefix#Permission_Groups PG
	WHERE PG.Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.circuit#">
	AND P.Group_ID = PG.Group_ID
	ORDER BY BitValue
</cfquery>
	

	
