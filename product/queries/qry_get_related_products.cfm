
<!--- CFWebstore, version 6.50 --->

<!--- This template is called by any of the detail pages to output a list of items that the product is related to. Called by product.related

REQUIRED: DETAIL_TYPE -- Feature, Product (Item), etc.  
DETAIL_ID - ID for item you are looking for relations for --->

<cfparam name="attributes.DETAIL_TYPE" default="Product">
<cfparam name="attributes.DETAIL_ID" default="0">


<cfif attributes.Detail_type is "Product">
	<cfset attributes.detail_type="Item">
</cfif>

<cfif Session.User_ID>
	<cfset key_loc = ListContainsNoCase(session.userPermissions,'contentkey_list',';')>
	<cfif key_loc>
		<cfset accesskeys = ListLast(ListGetAt(session.userPermissions,key_loc,';'),'^')>
		<cfset accesskeys = ListAppend(accesskeys,'0')>
	</cfif>
</cfif>
<cfparam name="accesskeys" default="0">

<!--- Cfif detail_type is product --->

<cfif attributes.detail_type is "Item">

<!--- Get related products --->
<cfquery name="Qry_Get_Rel_Prods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Name, P.Product_ID, P.Sm_Image, P.Sm_Title, P.AccessKey, P.Short_Desc, P.Sale, P.Highlight, P.Hot, P.Long_Desc, P.Retail_Price, P.Base_Price, P.Wholesale, P.TaxCodes, P.Availability, P.User_ID
	FROM #Request.DB_Prefix#Products P, #Request.DB_Prefix#Product_#attributes.DETAIL_TYPE# PR
	WHERE P.Product_ID = PR.Product_ID AND
	PR.#attributes.DETAIL_TYPE#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DETAIL_ID#"> 
	AND AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) 
	AND NOT EXISTS (SELECT C.Category_ID FROM #Request.DB_Prefix#Categories C 
			INNER JOIN #Request.DB_Prefix#Product_Category PCat ON C.Category_ID = PCat.Category_ID
			 WHERE PCat.Product_ID = P.Product_ID
			 AND (C.Display = 0 OR (
				C.AccessKey IS NOT NULL AND C.AccessKey <> 0 AND C.AccessKey NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">)) ) )
	AND
	(P.Sale_Start IS NULL OR P.Sale_Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	(P.Sale_End IS NULL OR P.Sale_End > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	P.Display = 1
	<cfif Request.AppSettings.InvLevel IS NOT "None" AND NOT Request.AppSettings.OutOfStock>
	AND P.NumInStock > 0</cfif>
</cfquery>

<cfelse>

<!--- Get related products --->
<cfquery name="Qry_Get_Rel_Prods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Name, P.Product_ID, P.Sm_Image, P.Sm_Title, P.AccessKey, P.Sale, P.Highlight, P.Hot, P.Long_Desc, P.Retail_Price, P.Base_Price, P.Wholesale, P.TaxCodes, P.Availability, P.User_ID
	FROM #Request.DB_Prefix#Products P, #Request.DB_Prefix##attributes.DETAIL_TYPE#_Product PR
	WHERE P.Product_ID = PR.Product_ID 
	AND PR.#attributes.DETAIL_TYPE#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DETAIL_ID#"> 
	AND AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) AND
	(P.Sale_Start IS NULL OR P.Sale_Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	(P.Sale_End IS NULL OR P.Sale_End > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	P.Display = 1
	<cfif Request.AppSettings.InvLevel IS NOT "None" AND NOT Request.AppSettings.OutOfStock>
	AND P.NumInStock > 0</cfif>
</cfquery>


</cfif>


