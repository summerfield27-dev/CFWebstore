<!--- CFWebstore, version 6.50 --->

<!-----------------------------------------------------------------------
	Network Merchants
		Uses the Direct Post method to send data to the secure
		payment gateway.
		
	Required Parameters:
		username		
		type	
		
		amount
		ccnumber				
		ccexp
		
		orderid
		firstname
		lastname
		address1
		city
		state
		zip
		country
		phone
		email
		
		
	Optional Parameters:	
		ipaddress
		company
		test			(TRUE)
		cvv

  ----------------------------------------------------------------------->

<cfparam name="attributes.type" default="auth">
<cfparam name="attributes.test" default="FALSE">
<cfparam name="attributes.firstname" default="">
<cfparam name="attributes.lastname" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.cvv" default="">

<cfset amount = DecimalFormat(attributes.amount)>
 
		<cfhttp url="https://secure.networkmerchants.com/gw/api/transact.php" method="post">

			<cfhttpparam type="FORMFIELD" name="type" value="#attributes.type#">
			<cfhttpparam type="FORMFIELD" name="username" value="#attributes.username#">
			

			<cfhttpparam type="FORMFIELD" name="amount" value="#amount#">
			<cfhttpparam type="FORMFIELD" name="type" value="#attributes.type#">
			<cfhttpparam type="FORMFIELD" name="ccnumber" value="#attributes.ccnumber#">
			<cfhttpparam type="FORMFIELD" name="ccexp" value="#attributes.ccexp#">
			<cfhttpparam type="FORMFIELD" name="cvv" value="#attributes.cvv#">
			
			<cfhttpparam type="FORMFIELD" name="orderid" value="#attributes.orderid#">
			<cfhttpparam type="FORMFIELD" name="firstname" value="#attributes.firstname#">
			<cfhttpparam type="FORMFIELD" name="lastname" value="#attributes.lastname#">
			<cfhttpparam type="FORMFIELD" name="company" value="#attributes.company#">
			<cfhttpparam type="FORMFIELD" name="address1" value="#attributes.address#">
			<cfhttpparam type="FORMFIELD" name="city" value="#attributes.city#">
			<cfhttpparam type="FORMFIELD" name="state" value="#attributes.state#">
			<cfhttpparam type="FORMFIELD" name="zip" value="#attributes.zip#">
			<cfhttpparam type="FORMFIELD" name="country" value="#attributes.country#">
			<cfhttpparam type="FORMFIELD" name="phone" value="#attributes.phone#">
			<cfhttpparam type="FORMFIELD" name="email" value="#attributes.email#">	
			
			<cfhttpparam type="FORMFIELD" name="ipaddress" value="#CGI.REMOTE_ADDR#">

		</cfhttp>

<cfscript>
	ParsedResults = StructNew();
	ParsedResults.Message = '';
	
	ResponseCodes = ListToArray(CFHTTP.FileContent, "&");
	
	//Make sure we found a two-line CSV
	if (ArrayLen(ResponseCodes) LT 2 OR NOT FindNoCase("response",CFHTTP.FileContent)) {
		ParsedResults.Message = CFHTTP.FileContent;
		}
	else {
	
		//Save into structure of values
		for (i=1; i lte ArrayLen(ResponseCodes); i=i+1) { 
		// get variable name
		CodeName = ListGetAt(ResponseCodes[i],1,"=");
		if (ListLen(ResponseCodes[i],"=") IS 2) {
			CodeValue = ListGetAt(ResponseCodes[i],2,"=");
			}
		else {
			CodeValue = '';
		}
		StructInsert(ParsedResults, CodeName, CodeValue);	
		}
	}
	
</cfscript>


<!----------------------------------------------------------------------
	Set caller query object
  ---------------------------------------------------------------------->
<cfset Caller[attributes.queryname] = ParsedResults>


