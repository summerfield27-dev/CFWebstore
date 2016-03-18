
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run EZIC credit card validation. Called from checkout/act_pay_form.cfm --->

<!--- Retrive EZIC settings --->

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

<cfparam name="attributes.CVV2" default="">
<cfparam name="DisableCVV2" default="0">

<cfif get_Order_Settings.usecvv2 IS 0>
	<cfset DisableCVV2 = 1>
</cfif>

<cfset NameLen = ListLen(attributes.NameonCard, " ")>
<cfset LastName = ListGetAt(attributes.NameonCard, NameLen, " ")>
<cfset FirstName = ListDeleteAt(attributes.NameonCard, NameLen, " ")>

<cfset InvoiceNum = Replace(CGI.REMOTE_ADDR,".","","ALL") & randomnum>

<cfset CustNum = Session.BasketNum>

<CF_EZIC
	QUERYNAME="Results"
     ACCOUNT="#GetSettings.Password#"
	 ACTION="#GetSettings.Transtype#"
     CARDNUMBER="#attributes.CardNumber#"
     EXPIREDATE="#cardexp#"
     AMOUNT="#GetTotals.OrderTotal#"
     ORDER="#InvoiceNum#"
	 CVV2="#attributes.CVV2#"
	 CUSTOMER="#CustNum#"
	 FIRSTNAME="#FirstName#" 
	 LASTNAME="#LastName#" 
     TYPE="#GetSettings.Transtype#"
	 ADDRESS="#GetCustomer.Address1#"
	 CITY="#GetCustomer.City#"
	 STATE="#CustState#"
ZIP="#GetCustomer.Zip#"
COUNTRY="#ListGetAt(GetCustomer.Country, 2, "^")#"
PHONE="#GetCustomer.Phone#"
EMAIL="#GetCustomer.Email#"
DISABLECVV2="#DisableCVV2#"
TEST="Yes"
DEBUG="Yes">
			  
<cfif Results.response_code IS "0" OR Results.response_code IS "D">
	<cfset ErrorMessage = Results.response_text & " Please change the information entered, or return to the store.">    
	<cfset display = "Yes">
<cfelse>
	<cfset AuthNumber = Results.authorization_code>
	<cfset TransactNum = Results.trans_id>
	<cfset attributes.step = "receipt">
</cfif>


