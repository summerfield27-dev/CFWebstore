
<!--- CFWebstore, version 6.50 --->

<!--- This query gets the Account record for a particular user --->
<cfquery name="qry_get_account" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT A.* FROM #Request.DB_Prefix#Account A, #Request.DB_Prefix#Users U
	WHERE A.User_ID = U.User_ID
	AND U.User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
		
