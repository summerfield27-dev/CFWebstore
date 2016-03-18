
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve a list of all the categories --->

<!--- Used for the sitemap and verity search --->

<cfquery name="qry_Get_allCats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Category_ID, Name, Short_Desc, Long_Desc, Metadescription, Keywords
	FROM #Request.DB_Prefix#Categories
	WHERE Display = 1
<cfif isDefined("alphasearch") AND alphasearch IS NOT "All">
	<cfif alphasearch IS "Num">
	AND ( Name Like '1%' OR Name Like '2%' OR Name Like '3%' OR Name Like '4%' 
	OR Name Like '5%' OR Name Like '6%' OR Name Like '7%' OR Name Like '8%' 
	OR Name Like '9%' OR Name Like '0%')
	<cfelse>
	AND Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="#alphasearch#%">
	</cfif>
</cfif>
ORDER BY Name
</cfquery>



