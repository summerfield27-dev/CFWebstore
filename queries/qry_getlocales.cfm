
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of locales --->

<cfquery name="GetLocales" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#Locales
	ORDER BY Name
</cfquery>
 


