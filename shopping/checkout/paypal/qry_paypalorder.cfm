
<!--- CFWebstore, version 6.50 --->

<!--- Retrieve the Order Number for the complete PayPal transaction. Called by do_checkout.cfm --->

<!--- Get the order information --->
<cfquery name="GetOrderNum" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Order_No FROM #Request.DB_Prefix#Order_No
	WHERE (AuthNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#">
			OR TransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#">)
</cfquery>

<cfif GetOrderNum.RecordCount IS 0>

	<cfset Webpage_title = "Checkout Error">
	<cfset message = "Sorry, there does not appear to be an order with this number in the database.">

<cfelse>
	
	<!--- Check for downloads --->
	<cfquery name="CheckDownloads" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT OI.Product_ID FROM #Request.DB_Prefix#Order_Items OI, #Request.DB_Prefix#Products P
		WHERE OI.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrderNum.Order_No#">
		AND OI.Product_ID = P.Product_ID
		AND P.Prod_Type = 'download'		
	</cfquery>

</cfif>

