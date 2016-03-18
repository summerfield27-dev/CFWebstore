
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for a selected page template. Used by the dsp_catheader.cfm page --->

<cfquery name="qry_get_catCore"  datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
	SELECT * FROM #Request.DB_Prefix#CatCore
	WHERE CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.catcore_id#">
</cfquery>
		


