
<!--- CFWebstore, version 6.50 --->

<!--- This page retrieves the list of option choices for a list of products. Used for category, product and gift registry pages. --->

<cfparam name="ProdList" default="0">

<!--- Get the option choices for these --->
<cfquery name="qry_get_Opt_Choices" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	<!--- This section retrieves the standard options that have SKU and inventory data --->
	SELECT PO.Product_ID, PO.Option_ID, SC.SortOrder, SC.Choice_ID, SC.ChoiceName, SC.Price, SC.Weight, SC.Display,
	PC.SKU, PC.NumInStock, PC.Display AS ItemDisplay 
	FROM #Request.DB_Prefix#StdOpt_Choices SC, 
		#Request.DB_Prefix#Product_Options PO,
		#Request.DB_Prefix#ProdOpt_Choices PC
	WHERE <cfif len(ProdList)>PO.Product_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ProdList#" list="Yes">)
			<cfelse>0 = 1 </cfif>
	AND PO.Std_ID = SC.Std_ID
	AND SC.Choice_ID = PC.Choice_ID
	AND PC.Option_ID = PO.Option_ID
	
	UNION 
	
	<!--- This section retrieves the standard options that do NOT have SKU and inventory data --->
	SELECT PO.Product_ID, PO.Option_ID, SC.SortOrder, SC.Choice_ID, SC.ChoiceName, SC.Price, SC.Weight, SC.Display,
	'' AS SKU, 0 AS NumInStock, 1 AS ItemDisplay 
	FROM #Request.DB_Prefix#StdOpt_Choices SC, #Request.DB_Prefix#Product_Options PO
	WHERE <cfif len(ProdList)>PO.Product_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ProdList#" list="Yes">)
			<cfelse>0 = 1 </cfif>
	AND PO.Std_ID = SC.Std_ID
	AND NOT EXISTS (SELECT PC.Choice_ID FROM #Request.DB_Prefix#ProdOpt_Choices PC
					WHERE PC.Option_ID = PO.Option_ID
					AND PC.Choice_ID = SC.Choice_ID)					
	
	UNION
	
	<!--- This section retrieves the custom product options --->
	SELECT PO.Product_ID, PO.Option_ID, PC.SortOrder, PC.Choice_ID, PC.ChoiceName, PC.Price, PC.Weight, PC.Display,
	PC.SKU, PC.NumInStock, 1 AS ItemDisplay
	FROM #Request.DB_Prefix#ProdOpt_Choices PC, #Request.DB_Prefix#Product_Options PO 
	WHERE <cfif len(ProdList)>PO.Product_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ProdList#" list="Yes">)
			<cfelse>0 = 1 </cfif>
	AND PO.Option_ID = PC.Option_ID	
	AND PO.Std_ID = 0
	
	ORDER BY 1, 2, 3
</cfquery>
