
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the quantity discounts for a product. Called by product.qty_discount --->

<cfparam name="attributes.product_id" default="0">

<cfquery name="qry_qty_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#ProdDisc
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	AND Wholesale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#session.wholesaler#">
</cfquery>



