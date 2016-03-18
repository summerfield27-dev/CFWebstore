
<!--- CFWebstore, version 6.50 --->

<!--- This query gets the User Settings --->
<cfquery name="get_User_Settings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows=1 cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#UserSettings
</cfquery>


