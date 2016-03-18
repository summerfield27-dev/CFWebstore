
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of promotions. Called by product.admin&promotion=list --->

<cfloop index="namedex" list="Name,Coup_code,accesskey,promo_display,current">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>
				
<cfquery name="qry_get_promotions" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT P.*, A.Name AS accesskey_name 
	FROM #Request.DB_Prefix#Promotions P
	LEFT OUTER JOIN #Request.DB_Prefix#AccessKeys A ON P.AccessKey = A.AccessKey_ID
	WHERE 1 = 1

<cfif trim(attributes.Name) is not "">
		AND P.Name Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Name#%">	</cfif>
<cfif trim(attributes.Coup_code) is not "">
		AND P.Coup_Code Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(attributes.Coup_code)#%">	</cfif>
<cfif trim(attributes.promo_display) is not "">
		AND P.Display Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.promo_display#%">	</cfif>
<cfif trim(attributes.current) is "current">
		AND (P.EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR P.EndDate IS NULL)	</cfif>
<cfif trim(attributes.current) is "expired">
		AND P.EndDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	</cfif>
<cfif trim(attributes.current) is "scheduled">
		AND P.StartDate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> </cfif>		
<cfif len(attributes.accesskey)>
		AND P.AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.accesskey#">  </cfif>
				
	ORDER BY P.Name, P.QualifyNum
</cfquery>
		



