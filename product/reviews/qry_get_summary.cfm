<!--- CFWebstore, version 6.50 --->

<!--- Query for summary information about reviews for a particular product --->

<cfparam name="attributes.product_ID" default="0">

<cfquery name="qry_get_reviews" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT AVG(R.Rating) AS Avg_Rating, COUNT(R.Rating) AS Total_Ratings
FROM #Request.DB_Prefix#ProductReviews R 
WHERE R.Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">
</cfquery>
		
