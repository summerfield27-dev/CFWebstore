
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of Accounts for the admin. Called by the fuseaction users.admin&account=list --->

<!--- initialize parameters --->
<cfloop index="namedex" list="uid,un,customer_ID,Account_name,lastused,type1,directory_live">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>
		
<cfquery name="qry_get_Accounts" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT A.*, U.Username AS UN
	FROM #Request.DB_Prefix#Account A 
	LEFT JOIN #Request.DB_Prefix#Users U ON A.User_ID = U.User_ID
	WHERE 1 = 1
	
	<cfif len(trim(attributes.uid))>
		AND A.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
		</cfif>
	<cfif len(trim(attributes.un))>
		AND U.Username Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.un#%">
		</cfif>		
	<cfif len(trim(attributes.customer_ID))>
		AND A.Customer_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_ID#">
		</cfif>
	<cfif len(trim(attributes.Account_name))>
		AND A.Account_Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Account_name#%">
		</cfif>
	<cfif isDate(attributes.lastused)>
		AND A.LastUsed > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.lastused#">
		</cfif>
	<cfif len(trim(attributes.type1))>
		AND A.Type1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type1#">
		</cfif>
	<cfif len(trim(attributes.directory_live))>
		AND A.Directory_Live = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.directory_live#">
		</cfif>
	Order by A.Account_ID DESC
</cfquery>


