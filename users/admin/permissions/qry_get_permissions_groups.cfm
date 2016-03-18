
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of permissions groups --->

<cfquery name="qry_get_groups" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Permission_Groups
	ORDER BY Name
</cfquery>
	

	
