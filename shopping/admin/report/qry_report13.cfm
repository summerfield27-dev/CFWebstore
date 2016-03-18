
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the Payment Detail (by Card) Report. Called by dsp_reports.cfm --->

<!--- Get list of orders --->
<cfquery name="qPayments" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT *
	FROM #Request.DB_Prefix#Payments
	WHERE Captured = <cfqueryparam value="1" cfsqltype="#Request.SQL_Bit#">
		AND PaymentDateTime >= <cfqueryparam value="#StartDate#" cfsqltype="cf_sql_timestamp">
		AND PaymentDateTime <= <cfqueryparam value="#ToDate#" cfsqltype="cf_sql_timestamp">
	ORDER BY
		CardType, CardNumber, InvoiceNum,
		Order_No, PaymentID
</cfquery>
