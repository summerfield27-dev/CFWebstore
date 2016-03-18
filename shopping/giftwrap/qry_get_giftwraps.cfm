
<!--- CFWebstore, version 6.50 --->

<!--- This query gets current giftwrapping options.  --->
<cfquery name="qry_get_giftwraps" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#Giftwrap
	WHERE Display = 1
	Order By Priority, Name
</cfquery>

