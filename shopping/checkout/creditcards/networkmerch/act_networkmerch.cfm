
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run Network Merchants credit card validation. Called from checkout/act_pay_form.cfm --->

<!--- Retrive settings --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Transtype, Username, Password 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfif GetCustomer.State Is "Unlisted">
	<cfset CustState = GetCustomer.State2>
<cfelse>
	<cfset CustState = GetCustomer.State>
</cfif>

<cfset NameLen = ListLen(attributes.NameonCard, " ")>
<cfset LastName = ListGetAt(attributes.NameonCard, NameLen, " ")>
<cfset FirstName = ListDeleteAt(attributes.NameonCard, NameLen, " ")>

<cfset r = Randomize(Minute(now())&Second(now()))>  
<cfset randomnum = RandRange(1000,9999)>

<cfset InvoiceNum = Replace(CGI.REMOTE_ADDR,".","","ALL") & randomnum>

<cfset cardexpire = Month & Right(Year,2)>
<cfparam name="attributes.CVV2" default="">

<CF_NetworkMerchants
	QUERYNAME="Results"
	USERNAME="#GetSettings.Username#"
	TYPE="#GetSettings.Transtype#"
	ORDERID="#InvoiceNum#"
	IPADDRESS="#CGI.REMOTE_ADDR#"
	AMOUNT="#GetTotals.OrderTotal#"
    CCNUMBER="#attributes.CardNumber#"
	CCEXP="#cardexpire#"
	CVV="#attributes.CVV2#"
    FIRSTNAME="#FirstName#" 
	LASTNAME="#LastName#" 
	COMPANY="#GetCustomer.Company#"
	ADDRESS="#GetCustomer.Address1#"
	CITY="#GetCustomer.City#"
	STATE="#CustState#"
	ZIP="#GetCustomer.Zip#"
	COUNTRY="#ListGetAt(GetCustomer.Country, 2, "^")#"
	PHONE="#GetCustomer.Phone#"
	EMAIL="#GetCustomer.Email#">
			  
			  
<!--- DEBUG --->
<!--- <cfdump var="#Results#">  --->

<cfset ErrorMessage = "">

<cfif Results.Response IS NOT "1">
	<cfif len(Results.ResponseText)>
		<cfset ErrorMessage = Results.ResponseText>
	</cfif>
	<cfset ErrorMessage = ErrorMessage & ". Please change the information entered, or return to the store.">       
<cfset display = "Yes">

<cfelse>

<cfset AuthNumber = Results.AuthCode>
<cfset attributes.step = "receipt">

</cfif>


