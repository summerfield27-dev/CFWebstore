
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of categories. Filters according to the search parameters that are passed. Called by category.admin&category=list|listform --->

<cfloop index="namedex" list="PID,Catcore_ID,Name,AccessKey,CatDisplay,highlight,Sale,catcore_content">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<!--- remove any non-alphanumeric or non-space characters --->
<cfset attributes.catcore_content = sanitize(attributes.catcore_content)>
		
<cfquery name="qry_get_categories"   datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
	SELECT C.*, CC.Catcore_Name AS catcore_name, A.Name AS accesskey_name
	FROM (#Request.DB_Prefix#Categories C 
	INNER JOIN #Request.DB_Prefix#CatCore CC ON C.CatCore_ID = CC.CatCore_ID) 
	LEFT OUTER JOIN #Request.DB_Prefix#AccessKeys A ON C.AccessKey = A.AccessKey_ID
	WHERE 1 = 1
<cfif trim(attributes.PID) is not "">
		AND C.Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#"></cfif>
<cfif trim(attributes.Catcore_ID) is not "">
		AND C.CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Catcore_ID#"></cfif>
<cfif trim(attributes.Name) is not "">
		AND C.Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Name#%"></cfif>
<cfif len(attributes.AccessKey)>
		AND C.AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey#"></cfif>
<cfif trim(attributes.CatDisplay) is not "">
		AND C.Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.CatDisplay#"></cfif>
<cfif trim(attributes.highlight) is not "">
		AND C.Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.highlight#"></cfif>
<cfif trim(attributes.Sale) is not "">
		AND C.Sale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Sale#"></cfif>
<cfif attributes.catcore_content is not "">
	AND CC.#attributes.catcore_content# = 1</cfif>
	
	ORDER BY C.Priority, C.Name
</cfquery>
		


