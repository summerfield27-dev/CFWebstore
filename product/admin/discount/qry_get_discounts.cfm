
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of discounts. Called by product.admin&discount=list --->

<cfloop index="namedex" list="Name,Coup_code,accesskey,disc_display,current">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>
				
<cfquery name="qry_get_Discounts"   datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
	SELECT D.*, A.Name AS accesskey_name 
	FROM #Request.DB_Prefix#Discounts D
	LEFT OUTER JOIN #Request.DB_Prefix#AccessKeys A ON D.AccessKey = A.AccessKey_ID
	WHERE 1 = 1

<cfif trim(attributes.Name) is not "">
		AND D.Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Name#%">	
</cfif>
<cfif trim(attributes.Coup_code) is not "">
		AND D.Coup_Code Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(attributes.Coup_code)#%">	
</cfif>
<cfif trim(attributes.disc_display) is not "">
		AND D.Display Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.disc_display#%">
</cfif>
<cfif trim(attributes.current) is "current">
		AND (D.EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR D.EndDate IS NULL)	
</cfif>
<cfif trim(attributes.current) is "expired">
		AND D.EndDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 				
</cfif>
<cfif trim(attributes.current) is "scheduled">
		AND D.StartDate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	
</cfif>		
<cfif len(attributes.accesskey)>
		AND D.AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.accesskey#"> 
</cfif>
				
	ORDER BY D.Name, D.MinOrder
</cfquery>
		



