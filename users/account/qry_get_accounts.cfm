
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve a listing of accounts. Called by users.directory --->

<cfloop index="namedex" list="account_name,rep,type1,directory_live,city,state,country,description,sortby,order">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<!--- remove any non-alphanumeric or non-space characters --->
<cfset attributes.sortby = Trim(sanitize(attributes.sortby))>
<cfset attributes.order = Trim(sanitize(attributes.order))>

<cfif attributes.order is "desc">
	<cfset orderby = "desc">
<cfelse>
	<cfset orderby = "asc">
</cfif>

<cfset searchheader = "">
<cfif Len(attributes.type1)>
	<cfset searchheader = "#searchheader# that are ""<b>#attributes.type1#s</b>""">
</cfif>

<cfif Len(attributes.account_name)>
	<cfset searchheader = "#searchheader# with a name like ""<b>#attributes.account_name#</b>""">
</cfif>

<cfif Len(attributes.rep)>
	<cfset searchheader = "#searchheader# whose sales rep is ""<b>#attributes.rep#</b>""">
</cfif>

<cfif Len(attributes.city)>
	<cfset searchheader = "#searchheader# located in the city of ""<b>#attributes.city#</b>""">	
</cfif>

<cfif Len(attributes.state)>
	<cfset searchheader = "#searchheader# located in the state of ""<b>#attributes.state#</b>""">	
</cfif>

<cfif Len(attributes.country)>
	<cfset searchheader = "#searchheader# located in the country of ""<b>#attributes.country#</b>""">	
</cfif>

<cfif Len(attributes.description)>
	<cfset searchheader = "#searchheader# matching ""<b>#attributes.description#</b>""">	
</cfif>

<cfquery name="qry_get_Accounts" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT A.*, C.FirstName, C.LastName, C.Company, 
	C.Address1, C.Address2, C.City, C.State, 
	C.State2, C.Zip, C.Country, C.Phone, C.Phone2,
	C.Fax, C.Email, C.Residence
	FROM #Request.DB_Prefix#Account A 
	INNER JOIN #Request.DB_Prefix#Customers C ON A.Customer_ID = C.Customer_ID
	WHERE A.Directory_Live = 1
	<cfif len(trim(attributes.account_name))>
		AND A.Account_Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.account_name#%">
		</cfif>
	<cfif len(trim(attributes.type1))>
		AND A.Type1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.type1#">
		</cfif>
	<cfif len(trim(attributes.rep))>
		AND Rep LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.rep#%">
		</cfif>
	<cfif len(trim(attributes.city))>
		AND C.City LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">
		</cfif>
	<cfif len(trim(attributes.state))>
		AND C.State LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.state#%">
		</cfif>
	<cfif len(trim(attributes.country))>
		AND C.Country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.country#">
		</cfif>
	<cfif len(trim(attributes.description))>
		AND A.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.description#%">
		</cfif>
	ORDER BY
	<cfif attributes.sortby is "city">
		State #orderby#, 
		City #orderby#,
		Account_Name
	<cfelseif attributes.sortby is "type1">
		Type1 #orderby#,
		Account_Name
	<cfelseif attributes.sortby is "name">
		Account_Name #orderby#
	<cfelseif attributes.sortby is "rep">
		Rep #orderby#,
		Account_Name
	<cfelse>
		Account_Name
	</cfif>
</cfquery>
		

