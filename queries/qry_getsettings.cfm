
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the main site settings --->

<cfquery name="Request.AppSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#Settings
</cfquery>
 


