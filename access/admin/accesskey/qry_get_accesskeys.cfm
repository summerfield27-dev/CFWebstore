
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the access keys. Called by access.admin&accessKey=list --->

<!--- Also called by various admin pages to display the list of access keys, used to assign a key to an item or page --->

<cfparam name="attributes.name" default="">

<cfquery name="qry_get_AccessKeys"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#AccessKeys
		WHERE 1 = 1
		
		<cfif len(attributes.name)>
			AND Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">
		</cfif>		
		ORDER BY Name
</cfquery>
		
