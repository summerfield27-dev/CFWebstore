<!--- CFWebstore, version 6.50 --->

<!-----------------------------------------------------------------------
	AuthorizeNet30
		Uses the "ADC Direct Response" method to send data to a secure
		AuthorizeNet gateway.
		
	Required Parameters:
		login 		(API Login ID)
		password 	(transaction key)		
		action	
		
	--- for credit card transactions ---
		amount
		cardnumber				
		expiredate
		
	--- for echeck transactions ---
		nameonaccount
		bankname
		routingnum
		accounttype
		accountnum	
		
		order
		customer
		firstname
		lastname
		address
		city
		state
		zip
		country
		phone
		email
		
		
	Optional Parameters:	
		company
		customer 		(customer ID)	
		proxy			(none)
		test			(TRUE)
		emailcustomer	(FALSE)
		emailmerchant	(TRUE)
		merchantemail	("")
		CVV2
		method			CC|ECHECK
		test
		testgateway

  ----------------------------------------------------------------------->

<cfparam name="attributes.method" default="CC">
<cfparam name="attributes.action" default="AUTH_ONLY">
<cfparam name="attributes.proxy" default="">
<cfparam name="attributes.test" default="FALSE">
<cfparam name="attributes.testgateway" default="TRUE">
<cfparam name="attributes.emailcustomer" default="FALSE">
<cfparam name="attributes.emailmerchant" default="TRUE">
<cfparam name="attributes.merchantemail" default="">
<cfparam name="attributes.firstname" default="">
<cfparam name="attributes.lastname" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.CVV2" default="">

<cfset amount = NumberFormat(attributes.amount, "0.00")>

<cfif attributes.testgateway>
	<cfset gatewayURL = "https://test.authorize.net/gateway/transact.dll">
<cfelse>
	<cfset gatewayURL = "https://secure.authorize.net/gateway/transact.dll">
</cfif>	

 
<cfhttp url="#gatewayURL#" method="post">

	<cfhttpparam type="FORMFIELD" name="x_login" value="#attributes.login#">
	<cfhttpparam type="FORMFIELD" name="x_tran_key" value="#attributes.password#">
	<cfhttpparam type="FORMFIELD" name="x_version" value="3.1">
	<cfhttpparam type="FORMFIELD" name="x_test_request" value="#attributes.test#">
	
	<cfhttpparam type="FORMFIELD" name="x_delim_data" value="TRUE">
	<cfhttpparam type="FORMFIELD" name="x_delim_char" value=",">
	<cfhttpparam type="FORMFIELD" name="x_relay_response" value="FALSE">
	
	<cfhttpparam type="FORMFIELD" name="x_first_name" value="#attributes.firstname#">
	<cfhttpparam type="FORMFIELD" name="x_last_name" value="#attributes.lastname#">
	<cfhttpparam type="FORMFIELD" name="x_company" value="#attributes.company#">
	<cfhttpparam type="FORMFIELD" name="x_address" value="#attributes.address#">
	<cfhttpparam type="FORMFIELD" name="x_city" value="#attributes.city#">
	<cfhttpparam type="FORMFIELD" name="x_state" value="#attributes.state#">
	<cfhttpparam type="FORMFIELD" name="x_zip" value="#attributes.zip#">
	<cfhttpparam type="FORMFIELD" name="x_country" value="#attributes.country#">
	<cfhttpparam type="FORMFIELD" name="x_phone" value="#attributes.phone#">
	
	<cfhttpparam type="FORMFIELD" name="x_cust_id" value="#attributes.customer#">
	<cfhttpparam type="FORMFIELD" name="x_customer_ip" value="#CGI.REMOTE_ADDR#">
	
	<cfhttpparam type="FORMFIELD" name="x_email" value="#attributes.email#">			
	<cfhttpparam type="FORMFIELD" name="x_email_customer" value="#attributes.emailcustomer#">
	<cfhttpparam type="FORMFIELD" name="x_email_merchant" value="#attributes.emailmerchant#">
	<cfhttpparam type="FORMFIELD" name="x_merchant_email" value="#attributes.merchantemail#">
	
	<cfhttpparam type="FORMFIELD" name="x_invoice_num" value="#attributes.order#">

	<cfhttpparam type="FORMFIELD" name="x_amount" value="#amount#">
	<cfhttpparam type="FORMFIELD" name="x_method" value="#attributes.method#">
	<cfhttpparam type="FORMFIELD" name="x_type" value="#attributes.action#">
	
	<cfif attributes.method IS "CC">
		<cfhttpparam type="FORMFIELD" name="x_card_num" value="#attributes.cardnumber#">
		<cfhttpparam type="FORMFIELD" name="x_exp_date" value="#attributes.expiredate#">
		<cfhttpparam type="FORMFIELD" name="x_card_code" value="#attributes.CVV2#">
	<cfelse>
		<cfhttpparam type="FORMFIELD" name="x_bank_aba_code" value="#attributes.routingnum#">
		<cfhttpparam type="FORMFIELD" name="x_bank_acct_num" value="#attributes.accountnum#">
		<cfhttpparam type="FORMFIELD" name="x_bank_acct_type" value="#attributes.accounttype#">
		<cfhttpparam type="FORMFIELD" name="x_bank_name" value="#attributes.bankname#">
		<cfhttpparam type="FORMFIELD" name="x_bank_acct_name" value="#attributes.nameonaccount#">
		<cfhttpparam type="FORMFIELD" name="x_echeck_type" value="WEB">
	</cfif>
	


</cfhttp>

<cfscript>
	ParsedResults = StructNew();
	ParsedResults.Message = '';
	
	ResponseCodes = ListToArray(CFHTTP.FileContent);
	
	FieldList = "Response_Code,Response_SubCode,Reason_Code,Reason_Text,Authorization_Code,AVS_Code,Transaction_ID,Invoice_Num";
	ResponseFields = ListToArray(FieldList);
	
	//Make sure we received a full response
	if (ArrayLen(ResponseCodes) LT 4) {
		ParsedResults.Reason_Text = CFHTTP.FileContent;		
		ParsedResults.Response_Code = "E";
		}
		
	else {	
		//Only process up to 8 fields
		TotalFields = iif(ArrayLen(ResponseCodes) LT 8,ArrayLen(ResponseCodes),8);
		//Save into structure of values
		for (i=1; i lte TotalFields; i=i+1) { 
			// get variable name
			CodeName = ResponseFields[i];
			CodeValue = Replace(ResponseCodes[i],'"','','ALL');
			StructInsert(ParsedResults, CodeName, CodeValue);	
		}
	}
	
</cfscript>

<!----------------------------------------------------------------------
	Set caller query object
  ---------------------------------------------------------------------->
<cfset Caller[attributes.queryname] = ParsedResults>


