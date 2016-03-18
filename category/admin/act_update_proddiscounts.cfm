
<!--- CFWebstore, version 6.50 --->


<!--- This page is used to update the discounts for the products in a category if changes made to the selected discounts. Called by act_category.cfm --->

<!--- Get the list of products in the category --->
<cfquery name="qry_get_products" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Product_ID	
	FROM #Request.DB_Prefix#Products P, #Request.DB_Prefix#Product_Category PC 
	WHERE PC.Product_ID = P.Product_ID
	AND PC.Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
</cfquery>

<!--- Loop through query and reset the product discounts --->
<cfloop query="qry_get_products">

	<cfset Application.objDiscounts.updProdDiscounts(qry_get_products.product_id)>

</cfloop>
