
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of addons for a product. Called from product\admin\product\dsp_addons_form.cfm --->

<cfquery name="qry_Get_Addons" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT PA.*, SA.Std_Prompt, SA.Std_Type, SA.Std_Display, SA.Std_Required 
	FROM #Request.DB_Prefix#ProdAddons PA 
	LEFT JOIN #Request.DB_Prefix#StdAddons SA ON PA.Standard_ID = SA.Std_ID
	WHERE PA.Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	ORDER BY PA.Priority, PA.Addon_ID
</cfquery>


