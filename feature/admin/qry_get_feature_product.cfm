
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of products the selected feature is currently related to. Called by feature.admin&feature=related_prod --->

<cfquery name="qry_get_Product_item" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT P.Product_ID, P.Name, P.SKU, P.Short_Desc
	FROM #Request.DB_Prefix#Feature_Product FP, #Request.DB_Prefix#Products P 
	WHERE FP.Product_ID = P.Product_ID
	AND FP.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_id#">
</cfquery>
		


