<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the selected review. Called by product.admin&review=edit|related|related_prod|copy --->

<cfquery name="qry_get_review" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT R.*, U.Username
	FROM #Request.DB_Prefix#ProductReviews R 
	LEFT JOIN #Request.DB_Prefix#Users U on R.User_ID = U.User_ID
	WHERE Review_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Review_ID#">
</cfquery>
		
<!--- Get Item record for header --->
<cfparam name="attributes.product_ID" default="#qry_get_review.product_ID#">
	
<cfquery name="GetDetail"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Product_ID, Name, Sm_Image, Short_Desc, User_ID FROM #Request.DB_Prefix#Products 
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#"> 
</cfquery>		

