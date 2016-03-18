
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Coupon Totals Report. Called by dsp_reports.cfm --->

<cfparam name="ordersfound" default="0">

<cfquery name="OrderDiscounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Coup_Code,
	SUM(OrderTotal-Tax-Shipping+OrderDisc+Credits) AS TotalSales, 
	COUNT(Order_No) AS NumSales,
	SUM(OrderDisc) As TotalDisc
	FROM #Request.DB_Prefix#Order_No
	WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
	AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND Coup_Code <> ''
	AND Void = 0
	GROUP BY Coup_Code
</cfquery>

<cfif OrderDiscounts.RecordCount>
	<cfset ordersfound = 1>
</cfif>

<cfquery name="ProductDiscounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.Disc_Code, SUM(O.Quantity) AS TotalItems,
	SUM((O.Price+O.OptPrice+O.AddonMultP)*O.Quantity+O.AddonNonMultP-O.PromoAmount) AS TotalSales, 
	SUM(O.DiscAmount*O.Quantity) AS TotalDisc
	FROM #Request.DB_Prefix#Order_Items O, #Request.DB_Prefix#Order_No N
	WHERE N.Order_No = O.Order_No
	AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
	AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND N.Void = 0
	AND O.Disc_Code <> ''
	GROUP BY O.Disc_Code
</cfquery>

<cfif ProductDiscounts.RecordCount>
	<cfset ordersfound = 1>
</cfif>

<cfquery name="Promotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.Promo_Code, SUM(O.PromoQuant) AS TotalItems,
	SUM(O.PromoAmount) AS TotalDisc
	FROM #Request.DB_Prefix#Order_Items O, #Request.DB_Prefix#Order_No N
	WHERE N.Order_No = O.Order_No
	AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
	AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND N.Void = 0
	AND O.Promo_Code <> ''
	GROUP BY O.Promo_Code
</cfquery>

<cfif Promotions.RecordCount>
	<cfset ordersfound = 1>
</cfif>

