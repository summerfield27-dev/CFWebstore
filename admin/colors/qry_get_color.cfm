
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information on a selected color palette. Called by home.admin&colors=edit --->

<cfquery name="qry_get_Color" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Colors
	WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
</cfquery>

