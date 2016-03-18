
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of user groups the selected discount is currently assigned to. Called by product.admin&discount=groups --->

<cfquery name="qry_get_disc_groups" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT G.Name, G.Group_ID
	FROM #Request.DB_Prefix#Discount_Groups DG, #Request.DB_Prefix#Groups G
	WHERE DG.Group_ID = G.Group_ID
	AND DG.Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">
</cfquery>
		


