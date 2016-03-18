

<!--- CFWebstore, version 6.50 --->

<!--- Used to get the list of the last 10 orders on the admin homepage, according to permissions. Called from put_order_links.cfm --->

<!--- Get the last 10 pending or in process orders --->

<cfquery name="qry_get_Orders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="10">
SELECT O.Order_No, O.OrderTotal, C.FirstName, C.LastName, O.DateOrdered
FROM #Request.DB_Prefix#Order_No O
LEFT JOIN #Request.DB_Prefix#Customers C ON O.Customer_ID = C.Customer_ID
WHERE 
		
	<cfif order_pending>
		Process = 0
		AND Filled = 0
	<cfelseif order_process>
		Process = 1
		AND Filled = 0
	<cfelse>
		0 = 1
	</cfif>
	
ORDER BY DateOrdered DESC
</cfquery>

		
