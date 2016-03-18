
<!--- CFWebstore, version 6.50 --->

<!--- This query is used throughout the store to retrieve the settings related to shipping. It is cached to improve performance so is also called after changing any of the settings to update the cached query.  --->
<cfparam name="session.ship_id" default="1">

<cfif StructKeyExists( attributes, "ship_id" )>
	<cfset session.ship_id = attributes.ship_id>
<cfelse>
	<cfset attributes.ship_id = session.ship_id />
</cfif>

<cfquery name="qry_get_ship_settings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#ShipSettings
WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ship_id#">
</cfquery>



