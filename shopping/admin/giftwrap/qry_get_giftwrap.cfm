
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for a giftwrap option. Called by shopping.admin&giftwrap=edit --->

<cfquery name="qry_get_giftwrap" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Giftwrap
	WHERE Giftwrap_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Giftwrap_ID#">
</cfquery>
		
