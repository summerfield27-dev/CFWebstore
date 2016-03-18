<!--- CFWebstore, version 6.50 --->

<!--- Outputs the form button to order through CRESecure. --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer
	FROM #Request.DB_Prefix#CCProcess
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="CRESecure">
</cfquery>

<cfset session.formKeys.cre_form = CreateUUID()>

<cfset fieldlist = "firstname,lastname,company,email,phone,city,state">

<!--- Build the URL string --->

<cfif GetSettings.CCServer IS "LIVE">
	<cfset creURL = "https://safe.cresecure.net/securepayments/a1/cc_collection.php">
<cfelse>
	<cfset creURL = "https://safe.sandbox-cresecure.net/securepayments/a1/cc_collection.php">		
</cfif>	

<cfset creURL = creURL & "?CRESecureID=#GetSettings.Username#">
<cfset creURL = creURL & "&CRESecureAPIToken=#GetSettings.Password#">
<cfset creURL = creURL & "&sess_id=#session.formKeys.cre_form#">
<cfset creURL = creURL & "&total_amt=#Total#">
<cfset creURL = creURL & "&total_weight=#Session.CheckoutVars.TotalWeight#">
<cfset creURL = creURL & "&order_desc=#Request.AppSettings.SiteName# Order">
<cfset creURL = creURL & "&currency_code=#Left(LSCurrencyFormat(10, "international"),3)#">
<cfset creURL = creURL & "&order_id=#Session.BasketNum#">
<cfloop index="field" list="#fieldlist#">
	<cfset creURL = creURL & "&customer_#field#=#GetCustomer[field][1]#">
</cfloop>
<cfset creURL = creURL & "&customer_address=#GetCustomer['address1'][1]#">
<cfset creURL = creURL & "&customer_postal_code=#GetCustomer['zip'][1]#">
<cfset creURL = creURL & "&customer_country=#ListGetAt(GetCustomer['country'][1], 1, "^")#">
<cfif GetShipTo.RecordCount>
	<cfset shipInfo = GetShipTo>
<cfelse>
	<cfset shipInfo = GetCustomer>		
</cfif>
<cfloop index="field" list="#fieldlist#">
	<cfset creURL = creURL & "&delivery_#field#=#shipInfo[field][1]#">
</cfloop>
<cfset creURL = creURL & "&delivery_address=#shipInfo['address1'][1]#">
<cfset creURL = creURL & "&delivery_postal_code=#shipInfo['zip'][1]#">
<cfset creURL = creURL & "&delivery_country=#ListGetAt(shipInfo['country'][1], 1, "^")#">
<cfset creURL = creURL & "&allowed_types=Visa|MasterCard|American Express">
<cfset creURL = creURL & "&return_url=#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=cresecure&redirect=yes&#UCase(Session.URLToken)#')#">
<cfset creURL = creURL & "&content_template_url=#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=payment&show=template&redirect=yes&custom=#Session.BasketNum#&#Ucase(Session.URLToken)#')#">

<cflocation url="#creURL#" addtoken="false">
	