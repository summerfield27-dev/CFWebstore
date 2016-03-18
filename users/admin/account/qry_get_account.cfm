
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves a specific Account record for editing. Called by the fuseaction users.admin&account=edit --->

<cfquery name="qry_get_Account" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Account
	WHERE Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Account_ID#">
</cfquery>


