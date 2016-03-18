
<!--- CFWebstore, version 6.50 --->

<!--- This query retrieves the list of states. --->

<cfquery name="GetStates" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#States
	ORDER BY Name
</cfquery>



