
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the wishlist. Called by shopping.wishlist --->

<!--- Get wishlist items --->
<cfquery name="qry_Get_list" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT W.Product_ID, P.Name, P.Availability, P.Sm_Image, P.Display, P.NotSold, P.User_ID,
	W.DateAdded, W.NumDesired, W.Comments
	FROM #Request.DB_Prefix#WishList W 
	LEFT JOIN #Request.DB_Prefix#Products P ON W.Product_ID = P.Product_ID
	WHERE W.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
	AND W.ListNum = 1
	ORDER BY W.ItemNum
</cfquery>

<cfparam name="attributes.currentpage" default=1>

<cfset ProdList = ValueList(qry_Get_list.Product_ID)>


