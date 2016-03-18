
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for a specific access key. Called by access.admin&accessKey=edit/act --->

<cfquery name="qry_get_AccessKey"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#AccessKeys
	WHERE AccessKey_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey_id#">
</cfquery>
		

