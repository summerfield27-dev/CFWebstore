
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of products. Filters according to the search parameters that are passed. Called by product.admin&product=list|listform|related and feature.admin&feature=related_prod--->

<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<cfloop index="namedex" list="name,sku,display_status,highlight,potd,sale,hot,type,account_id,CID,nocat,prodid">
	<cfparam name="attributes[namedex]" default="">
</cfloop>

<cfif attributes.nocat is "1">
	<cfset attributes.cid = "">
</cfif>

<cfif attributes.display_status IS "off">
	<cfset attributes.prod_display = "0">
<cfelse>
	<cfset attributes.prod_display = "">
</cfif>
		
<cfquery name="qry_get_products" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT DISTINCT P.Product_ID, P.Wholesale, P.OptQuant, P.Base_Price, P.Retail_Price, P.Name, P.SKU, P.UseforPOTD, 
	P.Display, P.Highlight,  P.Account_ID, P.Priority, P.NumInStock, P.NotSold, P.Sale, P.Hot, P.Prod_Type
	FROM #Request.DB_Prefix#Products P 
	LEFT JOIN #Request.DB_Prefix#Product_Category PC ON PC.Product_ID = P.Product_ID
	
	<cfif len(attributes.cid)>
		WHERE PC.Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	<cfelseif attributes.nocat IS "1">
		WHERE P.Product_ID NOT IN (SELECT Product_ID FROM Product_Category)
	<cfelse> 
		WHERE 1 = 1
	</cfif>

<cfif trim(attributes.name) is not "">
		AND P.Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">	</cfif>
<cfif trim(attributes.sku) is not "">
		AND P.SKU Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.sku#%"> </cfif>
<cfif trim(attributes.prod_display) is not "">
		AND P.Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.prod_display#">	</cfif>
<cfif trim(attributes.highlight) is not "">
		AND P.Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.highlight#">	</cfif>
<cfif attributes.display_status IS "current">
		AND (P.Sale_Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR P.Sale_Start IS NULL)
		AND (P.Sale_End >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR P.Sale_End IS NULL)
<cfelseif attributes.display_status IS "expired">
	AND P.Sale_End < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
<cfelseif attributes.display_status IS "scheduled">
	AND P.Sale_Start > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfif>
<cfif trim(attributes.potd) is not "">
		AND P.UseforPOTD = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.potd#">	</cfif>
<cfif trim(attributes.sale) is not "">
		AND P.Sale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.sale#">	</cfif>
<cfif trim(attributes.hot) is not "">
		AND P.Hot = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.hot#">	</cfif>
<cfif trim(attributes.type) is not "">
		AND P.Prod_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.type#">	</cfif>
<cfif trim(attributes.account_id) is not "">
		AND P.Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#"> </cfif>
<cfif isNumeric(attributes.prodid)>
		AND P.Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prodid#"> </cfif>
<!--- If not full product admin, filter by user --->
<cfif not ispermitted>	
		AND P.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#"> </cfif>
		
	ORDER BY P.Priority, P.Name

</cfquery>
		


