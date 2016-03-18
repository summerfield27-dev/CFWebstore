
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of features the selected feature is currently related to. Called by feature.admin&feature=related --->

<cfquery name="qry_get_feature_item" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT F.Feature_ID, Name, Author, Copyright
	FROM #Request.DB_Prefix#Feature_Item FI, #Request.DB_Prefix#Features F
	WHERE FI.Feature_ID = F.Feature_ID
	AND FI.Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_id#">
</cfquery>
		

