
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of categories the selected discount is currently assigned to. Called by product.admin&discount=categories --->

<cfquery name="qry_get_category_item" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT C.Name, C.Category_ID, C.ParentNames
	FROM #Request.DB_Prefix#Discount_Categories DC, #Request.DB_Prefix#Categories C
	WHERE DC.Category_ID = C.Category_ID
	AND DC.Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">
</cfquery>
		


