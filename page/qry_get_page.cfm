
<!--- CFWebstore, version 6.50 --->

<!--- Retrieve the information the selected page to display. Called by page.display --->

<cfparam name="attributes.pageaction" default="">
<!--- Used to check for invalid query strings --->
<cfparam name="invalid" default="0">

<cftry>
<!--- Get settings for this page --->
<cfquery name="qry_get_page" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT P.*, CC.Template 
FROM #Request.DB_Prefix#Pages P 
LEFT OUTER JOIN #Request.DB_Prefix#CatCore CC ON P.CatCore_ID = CC.CatCore_ID 
WHERE 
	<cfif len(attributes.pageaction)>
		PageAction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pageaction#">	
	<cfelseif isdefined("attributes.page_ID")>
		Page_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.page_ID#">
	</cfif>
</cfquery>

<cfcatch type="Any">
	<cfset invalid = 1>
</cfcatch>
</cftry>


