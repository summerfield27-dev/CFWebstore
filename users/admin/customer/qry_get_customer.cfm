
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves a specific Customer record for editing. Called by the fuseaction users.admin&customer=edit --->

<cfquery name="qry_get_Customer" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Customers
	WHERE Customer_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Customer_ID#">
</cfquery>
		
		


