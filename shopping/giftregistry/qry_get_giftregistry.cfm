
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the users gift registries. Called by shopping.giftregistry --->

<!--- Used to check for invalid query strings --->
<cfparam name="invalid" default="0">


<cftry>
	<!--- Get registry information --->
	<cfquery name="qry_get_giftregistry" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#GiftRegistry
		WHERE GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GiftRegistry_ID#">
	</cfquery>

<cfcatch type="Any">
	<cfset invalid = 1>
</cfcatch>
</cftry>
