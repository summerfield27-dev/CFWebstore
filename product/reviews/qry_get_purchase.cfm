<!--- CFWebstore, version 6.50 --->

<!--- Query to check if a user has ordered a product prior to reviewing it. --->

<cfparam name="attributes.Product_ID" default="0">
<!--- Used to check for invalid query strings --->
<cfparam name="invalid" default="0">

<cftry>
	<cfquery name="qry_get_purchase" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.Item_ID FROM #Request.DB_Prefix#Order_No N, #Request.DB_Prefix#Order_Items O
	WHERE N.Order_No = O.Order_No
	AND N.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
	AND O.Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	</cfquery>

<cfcatch type="Any">
	<cfset invalid = 1>
</cfcatch>
</cftry>