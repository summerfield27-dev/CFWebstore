
<!--- CFWebstore, version 6.50 --->

<!--- This query is used throughout the store to retrieve the settings related to placing orders. It is cached to improve performance so is also called after changing any of the settings to update the cached query.  --->

<cfquery name="get_Order_Settings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#OrderSettings
</cfquery>


