
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run PayPal Website Payments Pro Direct Pay credit card processing. Called from checkout/act_pay_form.cfm --->

<!--- Retrive PayPal Website Payments Pro settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT CCServer, Password, Setting1, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset PPServer = "https://api-3t.paypal.com/2.0/" >
<cfelse>
	<cfset PPServer = "https://api-3t.sandbox.paypal.com/2.0/" >
</cfif>	

<cfset r = Randomize(Minute(now())&Second(now()))>  
<cfset randomnum = RandRange(1000,9999)>

<!--- Get the Address Information --->
<cfset strCustAddress = Application.objCheckout.doCustomerAddress(GetCustomer,GetShipTo)>

<cfset NameLen = ListLen(attributes.NameonCard, " ")>
<cfset LastName = ListGetAt(attributes.NameonCard, NameLen, " ")>
<cfset FirstName = ListDeleteAt(attributes.NameonCard, NameLen, " ")>

<cfparam name="attributes.CVV2" default="">

<cfset InvoiceNum = Replace(CGI.REMOTE_ADDR,".","","ALL") & randomnum>

<cfset CustNum = Session.SessionID>

<CF_PayPalDirect
		STRUCTNAME="Results"
		USERNAME="#GetSettings.Username#"
	    PASSWORD="#GetSettings.Password#"
		SERVER="#PPServer#"
		SIGNATURE="#GetSettings.Setting1#"
		TRANSTYPE="#GetSettings.Transtype#"
		INVOICENUM="#InvoiceNum#"
		CCTYPE="#attributes.CardType#"
	    CARDNUMBER="#attributes.CardNumber#"
	    EXPIREDATE="#cardexp#"
		CVV2="#attributes.CVV2#"
	    AMOUNT="#GetTotals.OrderTotal#"
	    ORDER="#InvoiceNum#"
		CUSTOMER="#CustNum#"
		FIRSTNAME="#FirstName#" 
		LASTNAME="#LastName#" 
		COMPANY="#GetCustomer.Company#"
		ADDRESS="#strCustAddress.Billing.Address#"
		CITY="#strCustAddress.Billing.City#"
		STATE="#strCustAddress.Billing.State#"
		ZIP="#strCustAddress.Billing.Zip#"
		COUNTRY="#strCustAddress.Billing.Country#"
		SHIPTO_NAME="#strCustAddress.Shipping.Name#"
		SHIPTO_ADDRESS="#strCustAddress.Shipping.Address#"
		SHIPTO_ADDRESS2="#strCustAddress.Shipping.Address2#"
		SHIPTO_CITY="#strCustAddress.Shipping.City#"
		SHIPTO_STATE="#strCustAddress.Shipping.State#"
		SHIPTO_ZIP="#strCustAddress.Shipping.Zip#"
		SHIPTO_COUNTRY="#strCustAddress.Shipping.Country#"
		EMAIL="#GetCustomer.Email#">
			  
			  
<!--- DEBUG 
<cfoutput><h1>#Results.response_code#</h1></cfoutput> 
----->

<cfif Results.Success IS NOT "1">
	<cfset ErrorMessage = Results.errormessage & ". Please change the information entered, or return to the store.">    
	<cfset display = "Yes">

<cfelse>
	
	<cfset AuthNumber = ''>
	<cfset TransactNum = Results.TransactionID>
	<cfset attributes.step = "receipt">

</cfif>


