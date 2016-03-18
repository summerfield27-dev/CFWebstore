<!--- CFWebstore, version 6.50 --->

<!-----------------------------------------------------------------------
	AuthNetAction
		Uses the "ADC Direct Response" method to send data to a secure
		AuthorizeNet gateway to perform actions on a previously authorized transaction.
		
	Required Parameters:
		login (API Login ID)
		password (transaction key)	
		TransactNum	
		
		
				
	Optional Parameters:		
		action			PRIOR_AUTH_CAPTURE|CREDIT|VOID
		amount			for capture and credit
		cardnumber		for credit
		proxy			(none)
		test			(TRUE)
		emailcustomer	(FALSE)
		emailmerchant	(TRUE)
		merchantemail	("")

  ----------------------------------------------------------------------->

<cfparam name="attributes.action" default="PRIOR_AUTH_CAPTURE">
<cfparam name="attributes.proxy" default="">
<cfparam name="attributes.test" default="FALSE">
<cfparam name="attributes.amount" default="0">
<cfparam name="attributes.testgateway" default="TRUE">
<cfparam name="attributes.emailcustomer" default="FALSE">
<cfparam name="attributes.emailmerchant" default="TRUE">
<cfparam name="attributes.merchantemail" default="">

<cfif attributes.testgateway>
	<cfset gatewayURL = "https://test.authorize.net/gateway/transact.dll">
<cfelse>
	<cfset gatewayURL = "https://secure.authorize.net/gateway/transact.dll">
</cfif>	

<cfset amount = DecimalFormat(attributes.amount)>
 
<cfhttp url="#gatewayURL#" method="post">

	<cfhttpparam type="FORMFIELD" name="x_login" value="#attributes.login#">
	<cfhttpparam type="FORMFIELD" name="x_tran_key" value="#attributes.password#">
	<cfhttpparam type="FORMFIELD" name="x_version" value="3.1">
	<cfhttpparam type="FORMFIELD" name="x_test_request" value="#attributes.test#">
	
	<cfif attributes.action IS "Credit">
		<cfhttpparam type="FORMFIELD" name="x_card_num" value="#attributes.cardnumber#">
	</cfif>
	
	<cfhttpparam type="FORMFIELD" name="x_delim_data" value="TRUE">
	<cfhttpparam type="FORMFIELD" name="x_delim_char" value=",">
	<cfhttpparam type="FORMFIELD" name="x_relay_response" value="FALSE">
	
	<cfif attributes.action IS NOT "VOID">
		<cfhttpparam type="FORMFIELD" name="x_amount" value="#amount#">
	</cfif>
			
	<cfhttpparam type="FORMFIELD" name="x_type" value="#attributes.action#">	
	<cfhttpparam type="FORMFIELD" name="x_trans_id" value="#attributes.TransActNum#">	
	<cfhttpparam type="FORMFIELD" name="x_email_customer" value="#attributes.emailcustomer#">
	<cfhttpparam type="FORMFIELD" name="x_email_merchant" value="#attributes.emailmerchant#">
	<cfhttpparam type="FORMFIELD" name="x_merchant_email" value="#attributes.merchantemail#">

	<cfhttpparam type="FORMFIELD" name="x_test_request" value="#attributes.test#">

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

<!--- <cfdump var="#CFHTTP.FileContent#">
<cfabort> --->
<!----------------------------------------------------------------------
	Set caller query object
  ---------------------------------------------------------------------->
<cfset Caller[attributes.queryname] = ParsedResults>


