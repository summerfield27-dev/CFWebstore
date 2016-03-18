
<!--- CFWebstore, version 6.50 --->

<!--- Used throughout the store to retrieve the list of store vendors. --->

<cfparam name="type1" default="vendor">

<cfquery name="qry_get_Vendors" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Account_ID, Account_Name
	FROM #Request.DB_Prefix#Account
	WHERE Type1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type1#">
	ORDER BY Account_Name			
</cfquery>
		

