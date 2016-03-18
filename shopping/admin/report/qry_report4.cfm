
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Top Products by Total Sales Report. Called by dsp_reports.cfm --->

<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Max(O.Name) AS Name, O.Product_ID, 
	SUM(O.Quantity) AS ProductsSold_Sum,
	SUM((O.Price+O.OptPrice-O.DiscAmount+O.AddonMultP)*O.Quantity+O.AddonNonMultP-O.PromoAmount) AS ProductsPrice_Sum
	FROM #Request.DB_Prefix#Order_Items O, #Request.DB_Prefix#Order_No N
	WHERE N.Order_No = O.Order_No
	AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
	AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND Void = 0
	GROUP BY O.Product_ID
	ORDER BY 4 DESC
</cfquery>

<!--- This page is called by viewreport.cfm and is used to output the top products by total sales --->


