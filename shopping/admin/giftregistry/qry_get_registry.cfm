
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of category templates, must be set for use with categories. Used on the list pages for filter and for the category form page --->

<cfquery name="qry_get_giftregistry" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT * FROM #Request.DB_Prefix#GiftRegistry
	Where GiftRegistry_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.giftregistry_ID#">
</cfquery>
		

