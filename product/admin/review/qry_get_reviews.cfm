<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of reviews. Filters according to the search parameters that are passed. Called by product.admin&review=list|listform --->

<cfset fieldlist = "uid,uname,search_string,product_ID,editorial,sortby,rating,recommend,display_status,approved,needsCheck,recent_days">

<cfloop index="namedex" list="#fieldlist#">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<cfif attributes.display_status is "check">
	<cfset attributes.needsCheck = 1>
<cfelseif attributes.display_status is "pending">
	<cfset attributes.approved = 0>
<cfelseif attributes.display_status is "day">
	<cfset attributes.recent_days = 1>
<cfelseif attributes.display_status is "week">
	<cfset attributes.recent_days = 7>
<cfelseif attributes.display_status is "month">
	<cfset attributes.recent_days = 30>
</cfif>

<cfswitch expression="#attributes.sortby#">
	<cfcase value="newest">
		<!--- Newest are grouped by editorial type --->
		<cfset attributes.sort = "Posted">
		<cfset attributes.order = "DESC">
	</cfcase>
	<cfcase value="oldest">
		<cfset attributes.sort = "Posted">
		<cfset attributes.order = "ASC">
	</cfcase>
	<cfcase value="highest">
		<cfset attributes.sort = "Rating">
		<cfset attributes.order = "DESC">
	</cfcase>
	<cfcase value="lowest">
		<cfset attributes.sort = "Rating">
		<cfset attributes.order = "ASC">
	</cfcase>
	<cfcase value="mosthelp">
		<cfset attributes.sort = "1">
		<cfset attributes.order = "DESC">
	</cfcase>
	<cfcase value="leasthelp">
		<cfset attributes.sort = "1">
		<cfset attributes.order = "ASC">
	</cfcase>
	<cfdefaultcase>
		<cfif len(attributes.sortby)>
			<cfset attributes.sort = "#attributes.sortby#">
		<cfelse>
			<cfset attributes.sort = "Review_ID">
		</cfif>
		<cfparam name="attributes.order" default="DESC">
	</cfdefaultcase>
</cfswitch>

<cfset attributes.sortby = Trim(sanitize(attributes.sortby))>
<cfset attributes.order = Trim(sanitize(attributes.order))>

<cfquery name="qry_get_reviews"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	<cfif Request.dbtype IS "Access">
		SELECT IIF(R.Helpful_Total=0,0,R.Helpful_Yes/R.Helpful_Total) AS Helpful,
	<cfelse>
		SELECT CASE WHEN R.Helpful_Total > 0 THEN R.Helpful_Yes/R.Helpful_Total ELSE 0 END AS Helpful,
	</cfif>
	R.Helpful_Yes, R.Helpful_Total, R.Review_ID, R.Product_ID, R.Posted, 
	R.Updated, R.Title, R.Comment, R.Rating, R.Editorial, R.User_ID, R.Anonymous, R.Anon_Name, R.Anon_Loc, 
	R.Anon_Email, R.NeedsCheck, U.Username, R.Approved, P.Name as Product_Name
	
	FROM (#Request.DB_Prefix#ProductReviews R 
			INNER JOIN #Request.DB_Prefix#Products P ON R.Product_ID = P.Product_ID) 
			LEFT JOIN #Request.DB_Prefix#Users U ON R.User_ID = U.User_ID
	WHERE 
	<cfif len(attributes.UID)>R.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#"> AND 
		<cfif fusebox.fuseaction is not "manager">R.Anonymous <> 1 AND</cfif>
	<cfelseif len(attributes.uname)>
		 (U.Username Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.uname#%"> 
		 OR R.Anon_Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.uname#%">) AND
	</cfif> 
	<cfif len(attributes.search_string)>
		(R.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_string#%">	
		 OR R.Comment LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.search_string#%">
		 OR P.Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_string#%">
		 ) AND
	</cfif>

	<cfif len(attributes.product_ID)>
		R.Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#"> AND</cfif>
	<cfif len(attributes.editorial) AND attributes.editorial IS NOT "NA">
		R.Editorial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.editorial#"> AND
	<cfelseif attributes.editorial IS "NA">
		(R.Editorial = NULL OR R.Editorial = '') AND
	</cfif>
	<cfif len(attributes.rating)>
		Rating = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.rating##attributes.editorial#"> AND</cfif>
	<cfif len(attributes.recommend)>
		Recommend = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.recommend#"> AND</cfif>
	<cfif Len(attributes.recent_days)>
		R.Posted >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("y",-attributes.recent_days,Now())#"> AND</cfif>	
	
	<cfif attributes.display_status is "editor">
		(R.Approved = 0 OR R.NeedsCheck = 1) AND
	<cfelse>
		<cfif len(attributes.approved)>
			R.Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.approved#"> AND</cfif>
		<cfif len(attributes.needscheck)>
			R.NeedsCheck = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.needscheck#"> AND</cfif>
	</cfif>
		
	1 = 1
	ORDER BY #attributes.sort# #attributes.order# 
</cfquery>
	

