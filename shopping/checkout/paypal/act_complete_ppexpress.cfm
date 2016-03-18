
<!--- CFWebstore, version 6.50 --->

<!--- This page completes the PayPal Website Payments Express Checkout process. Sends the SOAP request to PayPal and gets a return response to complete the checkout. Called from checkout/do_checkout.cfm --->

<!--- Retrive PayPal Website Payments Pro settings --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Password, Setting1, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	<cfif get_Order_Settings.CCProcess IS NOT "PayPalPro">
		WHERE Setting3 = 'PayPalExpress'
	<cfelse>
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	</cfif>
</cfquery>

<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset PPServer = "https://api-3t.paypal.com/2.0/" >
<cfelse>
	<cfset PPServer = "https://api-3t.sandbox.paypal.com/2.0/" >
</cfif>	

<!--- Get Order Totals --->
<cfquery name="GetTotals" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#TempOrder 
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<cfset attributes.token = Session.PP_Token>
<cfset attributes.PayerID = Session.PayerID>

<CF_PPExpressComplete
	STRUCTNAME="Results"
	USERNAME="#GetSettings.Username#"
    PASSWORD="#GetSettings.Password#"
	SERVER="#PPServer#"
	SIGNATURE="#GetSettings.Setting1#"
	TOKEN="#attributes.token#"
	PAYERID="#attributes.PayerID#"
	ORDERTOTAL="#GetTotals.OrderTotal#"
	TRANSTYPE="#GetSettings.Transtype#">
			  
			  
<!--- DEBUG 
<cfoutput><h1>#Results.response_code#</h1></cfoutput> 
----->

<cfif Results.Success IS NOT "1">
	<cfset Message = Results.errormessage>    
	<cfset attributes.step = "address">

<cfelse>
	<!--- <cfdump var="#Results#"> --->

	<cfscript>
	//Complete the order
	attributes.step = "receipt";
	PayPal = 'Yes';
	PayPalStatus = Results.PaymentStatus;
	PendingReason = Results.PendingReason;
	if (PayPalStatus IS "Completed")
		Confirmed = 1;
	TransactNum = Results.transactionID;
	</cfscript>		
	
	<cfinclude template="act_pending.cfm">
	
</cfif>


