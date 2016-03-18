
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the users gift registries. Called by shopping.giftregistry --->

<!--- Get registry items --->
<cfquery name="qry_Get_items" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT G.*, P.Name, P.Display, P.Recur
	FROM #Request.DB_Prefix#GiftItems G 
	INNER JOIN #Request.DB_Prefix#Products P ON G.Product_ID = P.Product_ID
	WHERE G.GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GiftRegistry_ID#">
	ORDER BY <cfif Request.AppSettings.ItemSort IS "Name">Name<cfelse>SKU</cfif>
</cfquery>

<cfset ProdList = ValueList(qry_Get_items.Product_ID)>

<cfif Session.User_ID>
	<cfset accesskeys = '0,1'>
	<cfset key_loc = ListContainsNoCase(session.userPermissions,'contentkey_list',';')>
	<cfif key_loc>
		<cfset accesskeys = ListAppend(accesskeys,ListLast(ListGetAt(session.userPermissions,key_loc,';'),'^'))>
	</cfif>
</cfif>
<cfparam name="accesskeys" default="0">


<!--- Get current product information for the items, making sure the product is available too --->
<cfquery name="qry_Get_Products" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Product_ID, OptQuant
	FROM #Request.DB_Prefix#Products
	WHERE <cfif len(ProdList)>
			Product_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ProdList#" list="true">)
		  <cfelse>0 = 1 </cfif>
	AND AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">)
	<cfif Request.AppSettings.InvLevel IS NOT "None" AND NOT Request.AppSettings.OutOfStock>
		AND NumInStock > 0 </cfif>
	AND (Sale_Start IS NULL OR Sale_Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND (Sale_End IS NULL OR Sale_End >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND Display = 1
</cfquery>

<!--- Get Product Option Choices for the items --->
<cfinclude template="../../product/queries/qry_get_opt_choices.cfm">

