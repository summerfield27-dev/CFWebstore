<!--- CFWebstore, version 6.50 --->

<!--- Retrieve selected county tax rate(s). Called by shopping.admin&taxes=county --->

<cfquery name="GetCounties" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Counties
	WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_ID#">
	ORDER BY State, Name
</cfquery>
