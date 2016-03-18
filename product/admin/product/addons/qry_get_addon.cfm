
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information on a product addon. Called by product.admin&addon=change --->

<cfquery name="qry_get_Addon" datasource="#Request.ds#"	username="#Request.DSuser#" password="#Request.DSpass#">
SELECT PA.*, SA.Std_Prompt, SA.Std_Type, SA.Std_Display, SA.Std_Required 
FROM #Request.DB_Prefix#ProdAddons PA 
LEFT JOIN #Request.DB_Prefix#StdAddons SA ON PA.Standard_ID = SA.Std_ID
WHERE PA.Addon_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Addon_ID#">
</cfquery>
		

