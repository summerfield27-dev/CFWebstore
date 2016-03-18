
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of Customers for the admin. Called by the fuseaction users.admin&customer=list --->

<!--- initialize parameters --->
<cfloop index="namedex" list="uid,custname,company,city,state,zip,country,phone,email,lastused,location,order,un">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<!--- Use to show recent activity --->
<cfparam name="attributes.Show" default="recent">

<!--- remove any non-alphanumeric or non-space characters --->
<cfset attributes.order = Trim(sanitize(attributes.order))>

<cfquery name="qry_get_Customers" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT C.*, U.Customer_ID AS billto, U.ShipTo, U.Username AS un
	FROM #Request.DB_Prefix#Customers C 
	<cfif CompareNoCase(fusebox.fuseaction, "loginAsAnother") IS 0>
		INNER JOIN #Request.DB_Prefix#Users U ON C.User_ID = U.User_ID
		WHERE U.Customer_ID = C.Customer_ID
	<cfelse>
		LEFT JOIN #Request.DB_Prefix#Users U ON C.User_ID = U.User_ID
		WHERE 1 = 1
	</cfif>
	<cfif attributes.show is "recent">
		AND C.LastUsed >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("ww", -1, Now())#">
	</cfif>
	<cfif len(trim(attributes.uid))>
		AND C.User_ID =<cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.uid#">
		</cfif>		
	<cfif len(trim(attributes.un))>
		AND U.Username Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.un#%">
		</cfif>		
	<cfif len(trim(attributes.custname))>
		AND (LastName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.custname#%">
		OR FirstName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.custname#%">)
		</cfif>
	<cfif len(trim(attributes.company))>
		AND Company Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.company#%">
		</cfif>
	<cfif len(trim(attributes.location))>
		AND (Address1 Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR Address2 Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR City Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR County Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR State Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR State2 Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR Zip Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">
		OR Country Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.location#%">)
		</cfif>
	<cfif len(trim(attributes.phone))>
		AND Phone Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.phone#%">
		</cfif>
	<cfif len(trim(attributes.email))>
		AND C.Email Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.email#%">
		</cfif>
	<cfif isDate(attributes.lastused)>
		AND C.LastUsed > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.lastused#">
		</cfif>
	<cfif len(trim(attributes.order))>
		ORDER BY #attributes.order#
	<cfelse>
		ORDER BY C.Customer_ID DESC
	</cfif>
</cfquery>
		
