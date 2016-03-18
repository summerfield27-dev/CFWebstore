
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Affiliate Sales Report. Called by dsp_reports.cfm --->

<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT N.Affiliate, 
	SUM(OrderTotal) AS TotalSales, 
	SUM(Tax) As TotalTax, 
	SUM(Shipping) As TotalShipping,
	SUM(OrderDisc) As TotalDisc,
	SUM(Credits) As TotalCredit
	FROM #Request.DB_Prefix#Order_No N
	WHERE N.Affiliate <> 0 
	AND N.Filled <> 0 
	AND N.DateFilled >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
	AND N.DateFilled <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND Void = 0
	GROUP BY N.Affiliate
</cfquery>


<!--- This page is called by viewreport.cfm and is used to output the sales totals and referral fees for each Affiliate --->


