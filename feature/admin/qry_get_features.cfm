
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of features. Filters according to the search parameters that are passed. Called by feature.admin&feature=list|listform --->

<cfloop index="namedex" list="uname,search_string,feature_type,accesskey,display_status,feat_display,approved,highlight,order,CID,nocat,featureid">
	<cfparam name="attributes[namedex]" default="">
</cfloop>

<cfset uid = "">

<!--- if user does not have feature admin (1) or editor (2) permissions then show only features that current user created ---->
<cfparam name="ispermitted" default=1>
<cfmodule template="../../access/secure.cfm"
	keyname="feature"
	requiredPermission="1,2"
	> 
<cfif not ispermitted>
	<cfset uid = Session.User_ID>
</cfif>

<cfif attributes.display_status IS "off">
	<cfset attributes.feat_display = "0">
<cfelseif attributes.display_status IS "editor">
	<cfset attributes.feat_display = "1">
	<cfset attributes.approved = "0">
<cfelse>
	<cfset attributes.feat_display = "">
	<cfset attributes.approved = "">
</cfif>

<!--- Scrub the input to check for SQL injection code --->
<cfset attributes.order = sanitize(attributes.order)>

<cfif attributes.nocat IS 1>
	<cfquery name="categorized_features"  datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
	SELECT DISTINCT Feature_ID
	FROM #Request.DB_Prefix#Feature_Category
	</cfquery>
</cfif> 
	
<cfquery name="qry_get_Features"   datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
	SELECT F.*, U.Username, A.Name AS accesskey_name 
	FROM (<cfif len(attributes.cid)>(#Request.DB_Prefix#Features F 
		INNER JOIN #Request.DB_Prefix#Feature_Category FC ON FC.Feature_ID = F.Feature_ID)
	 <cfelse>#Request.DB_Prefix#Features F </cfif>
	LEFT OUTER JOIN #Request.DB_Prefix#Users U ON F.User_ID = U.User_ID) 
	LEFT OUTER JOIN #Request.DB_Prefix#AccessKeys A ON F.AccessKey = A.AccessKey_ID

	WHERE 
	
	<cfif attributes.nocat IS 1 AND categorized_features.recordcount>
		F.Feature_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(categorized_features.feature_id)#" list="true">)
	<cfelseif len(attributes.cid)>
		FC.Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	<cfelse> 
		1 = 1
	</cfif>	
	
	<cfif Len(uid)>
		AND F.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#uid#">
	</cfif>
	<cfif Len(Trim(attributes.search_string))>
		AND (F.Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_string#%">	
		OR F.Author LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_string#%">	 
		OR F.Copyright LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_string#%">	 
		OR F.Short_Desc LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.search_string#%">	 
		OR F.Long_Desc LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.search_string#%">) 
	</cfif>
	<cfif Len(attributes.feature_type)>
		AND Feature_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.feature_type#">	
	</cfif>
	<cfif Len(attributes.accesskey)>
		AND F.AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.accesskey#">
	</cfif>
	<cfif Len(attributes.feat_display)>
		AND F.Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.feat_display#"> 
	</cfif>			
	<cfif Len(attributes.approved)>
		AND F.Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.approved#"> 
	</cfif>				
	<cfif attributes.display_status IS "current">
		AND (F.Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR F.Start IS NULL)
		AND (F.Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR F.Expire IS NULL)
	</cfif>
	<cfif attributes.display_status IS "expired">
		AND F.Expire < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		</cfif>
	<cfif attributes.display_status IS "scheduled">
		AND F.Start > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		</cfif>
	<cfif len(attributes.highlight)>
		AND F.Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.highlight#">
	</cfif>
	<cfif isNumeric(attributes.featureid)>
		AND F.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.featureid#"> </cfif>			
	ORDER BY 	

	<cfif trim(attributes.order) is "username">			
		 U.Username, F.Name
	<cfelseif trim(attributes.order) is not "">
		 F.#attributes.order#
	<cfelse>
		F.Priority, F.Name
	</cfif>
			 
</cfquery>
		


