
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information on a specific gift certificate. Called by shopping.admin&certificate=edit --->

<cfquery name="qry_get_Certificate" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#"  maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Certificates
	WHERE Cert_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Cert_ID#">
</cfquery>
	
	