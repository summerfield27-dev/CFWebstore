
<!--- CFWebstore, version 6.50 --->

<!--- This query retrieves the list of counties. --->

<cfquery name="GetCounties" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT DISTINCT Name, State FROM #Request.DB_Prefix#Counties
	ORDER BY State, Name
</cfquery>



