
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve the list of products related to the current product. Called by product.admin&do=related --->

<cfquery name="qry_get_Product_item" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Product_ID, Name, SKU, Short_Desc
	FROM #Request.DB_Prefix#Product_Item PI, #Request.DB_Prefix#Products P 
	WHERE PI.Product_ID = P.Product_ID
	AND PI.Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">
</cfquery>
		


