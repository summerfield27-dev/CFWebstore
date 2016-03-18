
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run Authorize.Net credit card validation. Called from checkout/act_pay_form.cfm --->

<!--- Retrive Authorize.Net settings --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Password, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfset r = Randomize(Minute(now())&Second(now()))>  
<cfset randomnum = RandRange(1000,9999)>
<cfif GetCustomer.State Is "Unlisted">
<cfset CustState = GetCustomer.State2>
<cfelse>
<cfset CustState = GetCustomer.State>
</cfif>

<cfset InvoiceNum = Replace(CGI.REMOTE_ADDR,".","","ALL") & randomnum>

<cfset CustNum = Session.BasketNum>

<!---<cfdump var="#GetSettings#">--->

<cfset NameLen = ListLen(attributes.NameonCard, " ")>
<cfset LastName = ListGetAt(attributes.NameonCard, NameLen, " ")>
<cfset FirstName = ListDeleteAt(attributes.NameonCard, NameLen, " ")>

<cfparam name="attributes.CVV2" default="">

<CF_AuthorizeNet30
	QUERYNAME="Results"
	LOGIN="#GetSettings.Username#"
    PASSWORD="#GetSettings.Password#"
    CARDNUMBER="#attributes.CardNumber#"
    EXPIREDATE="#cardexp#"
	CVV2="#attributes.CVV2#"
    AMOUNT="#GetTotals.OrderTotal#"
    ORDER="#InvoiceNum#"
	CUSTOMER="#CustNum#"
	FIRSTNAME="#FirstName#" 
	LASTNAME="#LastName#" 
    ACTION="#GetSettings.Transtype#"
	COMPANY="#GetCustomer.Company#"
	ADDRESS="#GetCustomer.Address1#"
	CITY="#GetCustomer.City#"
	STATE="#CustState#"
	ZIP="#GetCustomer.Zip#"
	COUNTRY="#ListGetAt(GetCustomer.Country, 2, "^")#"
	PHONE="#GetCustomer.Phone#"
	EMAIL="#GetCustomer.Email#"
	TEST="No"
	TESTGATEWAY="No">

			  	  
<!--- DEBUG 
<cfdump var="#Results#"><cfabort>----->

<cfif Results.Response_Code IS "E">
	<cfset ErrorMessage = "There was an error with the payment gateway communication. Please contact our tech support for more assistance. ">    
	<cfset display = "Yes">

<cfelseif Results.Response_Code IS NOT "1">
	<cfset ErrorMessage = Results.Reason_Text & " Please change the information entered, or return to the store.">    
	<cfset display = "Yes">

<cfelse>

	<cfset AuthNumber = Results.Authorization_Code>
	<cfset TransactNum = Results.Transaction_ID>
	<cfset attributes.step = "receipt">

<!--- DEBUG 
<cfoutput><h1>step #attributes.step#</h1></cfoutput> ----->
<!----------
<cfset AuthNumber = Results.authorization_code>
<cfinclude template="../complete.cfm">
<cfset display = "No">
---->

</cfif>


