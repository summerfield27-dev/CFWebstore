
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Sales Summary Report. Called by dsp_reports.cfm --->

<!--- Get list of orders --->
<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT SUM(OrderTotal) AS TotalSales, 
	COUNT(Order_No) AS NumOrders, 
	SUM(Tax) As TotalTax, 
	SUM(Shipping) As TotalShipping,
	SUM(OrderDisc) As TotalDisc,
	SUM(Credits) As TotalCredit
	FROM #Request.DB_Prefix#Order_No
	WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#"> 
	AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND Void = 0
</cfquery>


<cfquery name="PendingOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT SUM(OrderTotal) AS TotalPending,
	SUM(Tax) As PendingTax, 
	SUM(Shipping) As PendingShipping,
	SUM(OrderDisc) As PendingDisc,
	SUM(Credits) As PendingCredit
	FROM #Request.DB_Prefix#Order_No
	WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#"> 
	AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
	AND Void = 0
	AND Paid = 0
</cfquery>

