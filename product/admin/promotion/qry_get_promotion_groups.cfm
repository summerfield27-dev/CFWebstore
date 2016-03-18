
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of user groups the selected promotion is currently assigned to. Called by product.admin&promotion=groups --->

<cfquery name="qry_get_disc_groups" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT G.Name, G.Group_ID
	FROM #Request.DB_Prefix#Promotion_Groups PG, #Request.DB_Prefix#Groups G
	WHERE PG.Group_ID = G.Group_ID
	AND PG.Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
</cfquery>
		


