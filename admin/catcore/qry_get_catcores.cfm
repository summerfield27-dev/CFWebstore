
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of page templates. Called by home.admin&catcore=list --->

<cfparam name="attributes.name" default="">

<cfquery name="qry_get_catCores"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#CatCore
		ORDER BY CatCore_ID
</cfquery>
		

