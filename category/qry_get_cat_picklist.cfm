
<!--- CFWebstore, version 6.50 --->

<!--- intended to return a category list for a pick list with:
	#parentnames#:#Name#  and #category_ID#,
	
This query is used for select boxes in admin forms. It will, for instance, produce a list of all categories that accept products for use on the product admin form.  --->

<cfparam name="attributes.Root_id" default="0" type="numeric">
<cfparam name="attributes.catcore_content" default="" type="string">

<!--- Scrub the input to check for SQL injection code --->
<cfset attributes.catcore_content = sanitize(attributes.catcore_content)>

<cfquery name="qry_get_cat_picklist" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT C.ParentNames, C.Category_ID, C.Name, C.ParentIDs
FROM #Request.DB_Prefix#Categories C 
INNER JOIN #Request.DB_Prefix#CatCore CC ON C.CatCore_ID = CC.CatCore_ID
WHERE 1=1
	<cfif attributes.catcore_content is not "">
	AND #attributes.catcore_content# = 1
	</cfif>
	<cfif attributes.root_id gt 0>
	AND #attributes.root_id# IN ParentIDs
	</cfif>
ORDER BY ParentNames, Name
</cfquery>

