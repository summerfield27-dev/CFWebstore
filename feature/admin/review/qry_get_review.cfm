<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the selected review. Called by Feature.admin&review=edit|related|related_prod|copy --->

<cfquery name="qry_get_review"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
SELECT  R.*, U.Username, 
(SELECT count(*) FROM #Request.DB_Prefix#FeatureReviews FR 
	WHERE FR.Parent_ID = R.Review_ID
	AND FR.Parent_ID <> 0) AS children
FROM #Request.DB_Prefix#FeatureReviews R 
LEFT JOIN #Request.DB_Prefix#Users U on R.User_ID = U.User_ID
WHERE Review_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.Review_ID#">
</cfquery>
		
<!--- Get Item record for header --->
<cfparam name="attributes.Feature_ID" default="#qry_get_review.Feature_ID#">

<cfquery name="GetDetail"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Feature_ID, Name, Sm_Image, Sm_Title, Short_Desc FROM #Request.DB_Prefix#Features 
	WHERE Feature_ID =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.Feature_ID#">
</cfquery>		

