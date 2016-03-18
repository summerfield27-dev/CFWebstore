
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of products the selected discount is currently assigned to. Called by product.admin&discount=products --->

<cfquery name="qry_get_product_item" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Product_ID, P.Name, P.SKU, P.Short_Desc
	FROM #Request.DB_Prefix#Discount_Products DP, #Request.DB_Prefix#Products P 
	WHERE DP.Product_ID = P.Product_ID
	AND DP.Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">
</cfquery>
		


