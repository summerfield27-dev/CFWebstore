
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of categories that the feature is currently assigned to. Called by feature.admin&feature=edit|copy --->

<cfquery name="qry_get_Feature_cats" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT C.Category_ID, C.Name, C.ParentNames
	FROM #Request.DB_Prefix#Categories C, #Request.DB_Prefix#Feature_Category FC
	WHERE FC.Category_ID = C.Category_ID
	AND FC.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
</cfquery>
		


