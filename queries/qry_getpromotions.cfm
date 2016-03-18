
<!--- CFWebstore, version 6.50 --->

<!--- This query retrieves the promotions for the site. The query is cached for better performance. Used throughout the site to calculate promotions, and is called to refresh the query whenever promotions are modified. --->

<cfquery name="GetPromotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#"  cachedwithin="#Request.Cache#">
	SELECT P.*, Pt.Base_Price AS ProdPrice 
	FROM #Request.DB_Prefix#Promotions P
	LEFT OUTER JOIN #Request.DB_Prefix#Products Pt ON P.Disc_Product = Pt.Product_ID
	ORDER BY QualifyNum 
</cfquery>



