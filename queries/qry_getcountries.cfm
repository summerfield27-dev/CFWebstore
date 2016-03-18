
<!--- CFWebstore, version 6.50 --->

<!--- This query retrieves the list of countries. --->

<cfparam name="attributes.GetUPS" default="0">

<cfquery name="GetCountries" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#Countries
	<cfif attributes.GetUPS>WHERE AllowUPS = 1</cfif>
	ORDER BY Name
</cfquery>



