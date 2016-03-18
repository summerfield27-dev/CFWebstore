
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the affiliate information. Called from dsp_report.cfm --->

<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT A.AffCode, A.AffPercent, U.User_ID, U.Username, C.FirstName, C.LastName, C.Company 
FROM (#Request.DB_Prefix#Affiliates A 
		INNER JOIN #Request.DB_Prefix#Users U ON A.Affiliate_ID = U.Affiliate_ID)
LEFT JOIN #Request.DB_Prefix#Customers C ON U.Customer_ID = C.Customer_ID
WHERE 
U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
</cfquery>

<cfif GetInfo.Recordcount>
	<cfquery name="GetDates" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT DISTINCT Year(DateOrdered) AS OrderYear, Month(DateOrdered) AS OrderMonth
	FROM #Request.DB_Prefix#Order_No 
	WHERE Affiliate = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetInfo.AffCode#">
	AND VOID = 0
	ORDER BY 1, 2 DESC
	</cfquery>
</cfif>



