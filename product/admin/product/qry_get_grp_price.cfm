<!--- CFWebstore, version 6.50 --->

<!--- Retrieve the list of group prices for a product. Called by product.admin&do=grp_price --->

<cfparam name="attributes.edit" default="0">

<!--- Get Group Price --->
	<cfquery name="GetPrice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Group_ID AS GID, Price, GrpPrice_ID 
	FROM #Request.DB_Prefix#ProdGrpPrice
	WHERE GrpPrice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edit#">
	</cfquery>

