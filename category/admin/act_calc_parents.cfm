
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to create the string of parent category names. These are used to create the various breadcrumb trails. Called from act.categories.cfm and act_update_children.cfm --->

<cfset CatIDs = "">
<cfset CatNames = "">
<cfset Parent = Parent_ID>

<cfloop condition="Parent GT 0">
<cfset CatIDs = ListPrepend(CatIDs, Parent)>

<cfquery name="GetParent" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
SELECT Name, Parent_ID
FROM #Request.DB_Prefix#Categories
WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Parent#">
</cfquery>

<cfset CatNames = ListPrepend(CatNames, GetParent.Name, ":")>
<cfset Parent = GetParent.Parent_ID>
</cfloop>



