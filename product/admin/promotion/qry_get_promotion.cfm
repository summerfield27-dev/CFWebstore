
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information on a specific promotion. Called by product.admin&promotion=edit --->

<cfquery name="qry_get_promotion" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT P.*, Pt.Name AS ProdName 
	FROM #Request.DB_Prefix#Promotions P
	LEFT OUTER JOIN #Request.DB_Prefix#Products Pt ON P.Disc_Product = Pt.Product_ID
	WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
</cfquery>
		
	

	