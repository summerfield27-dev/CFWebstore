
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the admin sales summar. Called by dsp_admin_home.cfm --->

<cfset Today = CreateDate(Year(Now()), Month(Now()), Day(Now()))>
<cfset ThisMonth = CreateDate(Year(Now()), Month(Now()), 1)>
<cfset ThisYear = CreateDate(Year(Now()), 1, 1)>

<!--- Summary of orders for today --->
<cfquery name="OrdersToday" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Today#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Today)#">
AND Void = 0
</cfquery>

<!--- Summary of orders for yesterday --->
<cfquery name="OrdersYester" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Today)#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Today#">
AND Void = 0
</cfquery>

<!--- Summary of orders for the month --->
<cfquery name="OrdersMonth" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ThisMonth#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('m', 1, ThisMonth)#">
AND Void = 0
</cfquery>

<!--- Summary of orders for last month --->
<cfquery name="OrdersLastMonth" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('m', -1, ThisMonth)#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ThisMonth#">
AND Void = 0
</cfquery>

<!--- Summary of orders for the year --->
<cfquery name="OrdersYear" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ThisYear#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, ThisYear)#">
AND Void = 0
</cfquery>

<!--- Summary of orders for last year --->
<cfquery name="OrdersLastYear" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT SUM(OrderTotal) AS TotalSales, 
COUNT(Order_No) AS NumOrders,
SUM(Tax) As TotalTax, 
SUM(Shipping) As TotalShipping,
SUM(OrderDisc) As TotalDisc,
SUM(Credits) As TotalCredit
FROM #Request.DB_Prefix#Order_No
WHERE DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', -1, ThisYear)#">
AND DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('yyyy', 1, ThisYear)#">
AND Void = 0
</cfquery>