
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to start the PayPal Website Payments Express Checkout process. Sends the SOAP request to PayPal and gets a return response then redirects the user to the PayPal site to continue. Called from checkout/do_checkout.cfm --->

<!--- Retrieve PayPal Website Payments Pro settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT CCServer, Password, Setting1, Transtype, Username 
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

<cfif isDefined("Session.PP_Token") and isDefined("attributes.edit_shipping")>

	<CF_PPExpressToken
		STRUCTNAME="Results"
		TOKEN="#Session.PP_Token#"
		USERNAME="#GetSettings.Username#"
	    PASSWORD="#GetSettings.Password#"
		SERVER="#PPServer#"
		SIGNATURE="#GetSettings.Setting1#"
		TRANSTYPE="#GetSettings.Transtype#"
	    ORDERTOTAL="#Session.CheckoutVars.TotalBasket#">
			
<cfelse>

	<!--- Get customer records --->
	<cfinclude template="../customer/qry_get_tempcustomer.cfm">
	<cfinclude template="../customer/qry_get_tempshipto.cfm">
	
	<!--- Determine which if there is a shipping address to use --->
	<cfif GetShipTo.Recordcount AND len(GetShipTo.FirstName)>
		<cfset ShipAddress = GetShipTo>
	<cfelse>
		<cfset ShipAddress = GetCustomer>
	</cfif>
	
	<CF_PPExpressToken
			STRUCTNAME="Results"
			USERNAME="#GetSettings.Username#"
		    PASSWORD="#GetSettings.Password#"
			SERVER="#PPServer#"
			SIGNATURE="#GetSettings.Setting1#"
			TRANSTYPE="#GetSettings.Transtype#"
		    ORDERTOTAL="#Session.CheckoutVars.TotalBasket#"
			FIRSTNAME="#ShipAddress.FirstName#" 
			LASTNAME="#ShipAddress.LastName#" 
			ADDRESS="#ShipAddress.Address1#"
			CITY="#ShipAddress.City#"
			STATE="#ShipAddress.State#"
			ZIP="#ShipAddress.Zip#"
			COUNTRY="#iif(Len(ShipAddress.Country), Evaluate(DE('ListGetAt(ShipAddress.Country, 1, "^")')), DE(''))#"
			EMAIL="#GetCustomer.Email#">
				  
				  
	<!--- DEBUG 
	<cfoutput><h1>#Results.response_code#</h1></cfoutput> 
	----->


</cfif>


<cfif Results.Success IS NOT "1">
	<cfset Message = Results.errormessage>    
	<cfset attributes.step = "address">

<cfelse>
	<cfif get_Order_Settings.PayPalServer IS "sandbox">
		<cfset paypalserver = "www.sandbox.paypal.com">
	<cfelse>
		<cfset paypalserver = "www.paypal.com">
	</cfif>
	<cflocation url="https://#paypalserver#/cgi-bin/webscr?cmd=_express-checkout&token=#results.token#" addtoken="No">
</cfif>


