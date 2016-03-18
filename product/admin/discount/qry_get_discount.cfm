
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information on a specific discount. Called by product.admin&discount=edit --->

<cfquery name="qry_get_Discount" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Discounts
	WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
</cfquery>
		
	

	