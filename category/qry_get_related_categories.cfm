
<!--- CFWebstore, version 6.50 --->

<!--- Used to retrieve a list of related categories. Called by category.related --->

<!--- 
Parameters:
Detail_Type: The item the category is related to. Options include: Product	
 --->
 
 <cfparam name="attributes.DETAIL_TYPE" type="string" default="Product">

<!--- Scrub the input to check for SQL injection code --->
<cfset attributes.DETAIL_TYPE = sanitize(attributes.DETAIL_TYPE)>


<!--- Related Categories --->
<cfquery name="Request.GetRelatedCats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT C.Name, C.Category_ID, C.Short_Desc, C.ParentIDs, C.ParentNames
FROM #Request.DB_Prefix#Categories C, #Request.DB_Prefix##attributes.DETAIL_TYPE#_Category DC
WHERE C.Category_ID = DC.Category_ID 
AND DC.#attributes.DETAIL_TYPE#_ID = 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DETAIL_ID#"> 
AND C.Display = 1
</cfquery>


