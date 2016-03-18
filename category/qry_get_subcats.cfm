
<!--- CFWebstore, version 6.50 --->

<!--- gets both direct and related categories for a given parent_ID. --->

<!--- Called by category.display and category.subcatmenu --->

<!--- Also used by a variety of admin pages to retrieve subcategories while browsing the store categories on the list pages --->

<cfparam name="attributes.parent_id" default="0">
<cfparam name="attributes.subcatkey" default="">
<cfparam name="all" default="0">

<cfquery name="request.qry_get_subcats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT A.Sm_Image, A.Sm_Title, A.Short_Desc, A.Category_ID, A.Name, A.Highlight, A.Sale, A.ParentIDs, A.Priority
	FROM #Request.DB_Prefix#Categories A
	WHERE Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#">
		<cfif len(attributes.subcatkey)>
		AND A.AccessKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subcatkey#">
		</cfif>
		<cfif not all>AND Display= 1</cfif>
ORDER BY Priority, Name
</cfquery>

<cfset numlist= request.qry_get_subcats.recordcount>

