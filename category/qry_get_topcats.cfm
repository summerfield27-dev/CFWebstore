
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves a list of categories, given the parent ID, which defaults to 0. Used by category.topcatmenu and called by category admin action pages to refresh the cached query.  --->

<cfparam name="attributes.rootcat" default="0" type="numeric">

<cfquery name="qry_get_topcats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT Sm_Image, Sm_Title, Short_Desc, Category_ID, Name, Highlight, Sale 
	FROM #Request.DB_Prefix#Categories
	WHERE Parent_ID = #Val(attributes.rootcat)#
	AND Display = 1
	ORDER BY Priority, Name
</cfquery>
