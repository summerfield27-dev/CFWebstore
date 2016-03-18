
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Sales Tax Report. Called by dsp_reports.cfm --->

<cfparam name="taxesfound" default="0">

<!--- Retrieve state tax totals --->
<cfquery name="StateTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
(SELECT S.Name, T.CodeName,
SUM(T.ProductTotal) AS Sales_Sum,
SUM(T.StateTax) AS StateTax_Sum,
SUM(T.LocalTax) AS LocalTax_Sum
FROM #Request.DB_Prefix#States S, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Billing' AND T.AddressUsed IS NOT NULL)
AND	C.State = S.Abb
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND (T.StateTax > 0 OR T.LocalTax > 0)
GROUP BY S.Name, T.CodeName)

UNION

(SELECT S.Name, T.CodeName,
SUM(T.ProductTotal) AS Sales_Sum,
SUM(T.StateTax) AS StateTax_Sum,
SUM(T.LocalTax) AS LocalTax_Sum
FROM #Request.DB_Prefix#States S, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND N.ShipTo = 0
AND	C.State = S.Abb
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND (T.StateTax > 0 OR T.LocalTax > 0)
GROUP BY S.Name, T.CodeName)

UNION

(SELECT S.Name, T.CodeName,
SUM(T.ProductTotal) AS Sales_Sum,
SUM(T.StateTax) AS StateTax_Sum,
SUM(T.LocalTax) AS LocalTax_Sum
FROM #Request.DB_Prefix#States S, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.ShipTo <> 0
AND N.ShipTo = C.Customer_ID 
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND	C.State = S.Abb
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND (T.StateTax > 0 OR T.LocalTax > 0)
GROUP BY S.Name, T.CodeName)

ORDER BY 1
</cfquery>

<cfif StateTaxes.RecordCount>
	<cfset taxesfound = 1>
	<!--- Do additional query to add up duplicate records --->
	<cfquery name="StateTaxesTotal" dbtype="query">
		SELECT Name, CodeName, 
		SUM(Sales_Sum) AS Sales_Total, SUM(StateTax_Sum) AS StateTax_Total, SUM(LocalTax_Sum) AS LocalTax_Total
		FROM StateTaxes
		GROUP BY Name, CodeName
		ORDER BY Name
	</cfquery>
	
</cfif>

<!--- Retrieve county tax totals --->
<cfquery name="CountyTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
(SELECT C.State, C.County, T.CodeName,
SUM(T.CountyTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Counties CT, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Billing' AND T.AddressUsed IS NOT NULL)
AND	CT.State = C.State
AND CT.Name = C.County
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountyTax > 0
GROUP BY C.State, C.County, T.CodeName)

UNION

(SELECT C.State, C.County, T.CodeName,
SUM(T.CountyTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Counties CT, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND N.ShipTo = 0
AND	CT.State = C.State
AND CT.Name = C.County
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountyTax > 0
GROUP BY C.State, C.County, T.CodeName)

UNION

(SELECT C.State, C.County, T.CodeName,
SUM(T.CountyTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Counties CT, #Request.DB_Prefix#Order_No N, 
	 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.ShipTo <> 0
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND N.ShipTo = C.Customer_ID 
AND	CT.State = C.State
AND CT.Name = C.County
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountyTax > 0
GROUP BY C.State, C.County, T.CodeName)

ORDER BY 1, 2, 3
</cfquery>

<cfif CountyTaxes.RecordCount>
	<cfset taxesfound = 1>
	<!--- Do additional query to add up duplicates --->
	<cfquery name="CountyTaxesTotal" dbtype="query">
		SELECT State, County, CodeName, 
		SUM(Sales_Sum) AS Sales_Total, SUM(Tax_Sum) AS Tax_Total
		FROM CountyTaxes
		GROUP BY State, County, CodeName
		ORDER BY 1, 2, 3
	</cfquery>
</cfif>

<!--- Retrieve country tax totals --->
<cfquery name="CountryTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
(SELECT C.Country, T.CodeName,
SUM(T.CountryTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Order_No N, #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Billing' AND T.AddressUsed IS NOT NULL)
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountryTax > 0
GROUP BY C.Country, T.CodeName)

UNION

(SELECT C.Country, T.CodeName,
SUM(T.CountryTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Order_No N, #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.Customer_ID = C.Customer_ID 
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND N.ShipTo = 0
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountryTax > 0
GROUP BY C.Country, T.CodeName)

UNION

(SELECT C.Country, T.CodeName,
SUM(T.CountryTax) AS Tax_Sum,
SUM(T.ProductTotal) AS Sales_Sum
FROM #Request.DB_Prefix#Order_No N, #Request.DB_Prefix#Customers C, #Request.DB_Prefix#OrderTaxes T
WHERE N.ShipTo <> 0
AND N.ShipTo = C.Customer_ID 
AND (T.AddressUsed = 'Shipping' AND T.AddressUsed IS NOT NULL)
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.CountryTax > 0
GROUP BY C.Country, T.CodeName)

ORDER BY 1, 2
</cfquery>

<cfif CountryTaxes.RecordCount>
	<cfset taxesfound = 1>
	<!--- Do additional query to add up duplicates --->
	<cfquery name="CountryTaxesTotal" dbtype="query">
		SELECT Country, CodeName, 
		SUM(Sales_Sum) AS Sales_Total, SUM(Tax_Sum) AS Tax_Total
		FROM CountryTaxes
		GROUP BY Country, CodeName
		ORDER BY Country
	</cfquery>
	
</cfif>


<!--- Retrieve all user tax totals --->
<cfquery name="AllUserTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT T.CodeName,
SUM(T.ProductTotal) AS Sales_Sum,
SUM(T.AllUserTax) AS Tax_Sum
FROM #Request.DB_Prefix#Order_No N, #Request.DB_Prefix#OrderTaxes T
WHERE T.AddressUsed IS NULL
AND	N.Order_No = T.Order_No
AND N.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#StartDate#">
AND N.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ToDate#">
AND Void = 0
AND T.AllUserTax > 0
GROUP BY T.CodeName
ORDER BY T.CodeName
</cfquery>

<cfif AllUserTaxes.RecordCount>
	<cfset taxesfound = 1>
</cfif>