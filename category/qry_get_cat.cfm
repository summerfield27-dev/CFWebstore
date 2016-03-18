
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve the information for a selected category. Called by category.display --->

<cfparam name="attributes.category_id" default="0">
<!--- Used to check for invalid query strings --->
<cfparam name="invalid" default="0">

<cftry>

	<cfquery name="request.qry_get_cat" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT C.*, CC.*
		FROM #Request.DB_Prefix#Categories C, #Request.DB_Prefix#CatCore CC
		WHERE C.CatCore_ID = CC.CatCore_ID 
		AND Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Category_id#">
		AND Display = 1
	</cfquery>
	
	<cfif len(request.qry_get_cat.CColumns)>
		<cfset attributes.CatCols = request.qry_get_cat.CColumns>
	</cfif>
	
<cfcatch type="Any">
	<cfset invalid = 1>
</cfcatch>
</cftry>
