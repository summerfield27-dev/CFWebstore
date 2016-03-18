
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the custom information entered for a product. Called by product.admin&do=info --->

<cfquery name="qry_Get_Custominfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#Prod_CustInfo
WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>


