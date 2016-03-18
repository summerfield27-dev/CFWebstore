<!--- CFWebstore, version 6.50 --->


<cfcomponent displayname="FedEx Shipping & Registration Tool" hint="This component is used for handling the FedEx API for shipping functions." output="No">
<!--- This component developed by Mary Jo Sminkey maryjo@cfwebstore.com --->
<!--- This tag was developed using the XML Tools provided by FedEx --->
<!--- Originally developed for use with CFWebstore e-commerce (www.cfwebstore.com) --->

<!--- Requires CFMX 6 or higher --->

<!--- This code is owned by Dogpatch Software and may not be distributes or reused without permission --->

<cfscript>
// Determine currency code 
//variables.Amount = LSCurrencyFormat("100", "international");
//variables.CurrCode = Left(variables.Amount, 3);

// Set Directory path for logs 
variables.Directory = GetDirectoryFromPath(ExpandPath(Request.StorePath));
variables.Directory = variables.Directory & "logs" & Request.Slash;
variables.fileIn = variables.Directory & "fedex_in.txt";
variables.fileOut = variables.Directory & "fedex_out.txt";

variables.currency = Left(LSCurrencyFormat(10, "international"),3);

// Set FedEx API address and header information 
variables.gateway = "https://ws.fedex.com:443/web-services";
//variables.gateway = "https://wsbeta.fedex.com:443/web-services";
//test server
variables.testgateway = "https://wsbeta.fedex.com:443/web-services";

variables.requestheader = structnew();   
variables.requestheader["Referer"] = "Dogpatch Software";   
variables.requestheader["Host"] = variables.gateway;   
variables.requestheader["Accept"] = "image/gif, image/jpeg,image/pjpeg, text/plain, text/html, */*";     
variables.requestheader["Content-Type"] = "image/gif";     
variables.requestheader["Content-Length"] = "0"; 
</cfscript> 

<!--- Include logging functions --->
<cfinclude template="logging.cfm">

<!------------------------- COMPONENT INITIALIZATION ----------------------------------->
<cffunction name="init" access="public" output="no" returntype="fedex">
    <cfreturn this>
  </cffunction>


<!------------------------- BEGIN FEDEX REGISTRATION FUNCTION ----------------------------------->

<cffunction name="doFedExRegistration" returntype="struct" hint="This function sends a registration request to FedEx, used for registering a new user." output="No" access="public">
<!--- Optional Attributes
	personname - contact name
	companyname - company or contact name is required
	faxnumber 
	address2 	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if subscription accepted, otherwise 0 --->
<!--- If Success, returns meter number --->
<!--- If Error, returns ErrorMessage --->
<cfargument name="FirstName" required="No" type="string" default="">
<cfargument name="LastName" required="No" type="string" default="">
<cfargument name="Company" required="No" type="string" default="">
<cfargument name="Address1" required="Yes" type="string">
<cfargument name="Address2" required="No" type="string" default="">
<cfargument name="City" required="Yes" type="string">
<cfargument name="State" required="yes" type="string" default="">
<cfargument name="Zip" required="yes" type="string" default="">
<cfargument name="Country" required="Yes" type="string">
<cfargument name="Phone" required="Yes" type="string">
<cfargument name="Email" required="yes" type="string" default="">
<cfargument name="accountno" required="Yes" type="string" hint="FedEx account number">

<cfargument name="Billing_Address1" required="no" type="string" default="">
<cfargument name="Billing_Address2" required="no" type="string" default="">
<cfargument name="Billing_City" required="no" type="string" default="">
<cfargument name="Billing_State" required="no" type="string" default="">
<cfargument name="Billing_Zip" required="no" type="string" default="">
<cfargument name="Billing_Country" required="no" type="string">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="logging" type="boolean" default="No" displayname="XML logging" hint="Sets whether to log the XML requests and responses.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
	var FedExReg = StructNew();
	var soapxml = '';
	// loop counter
	var key = '';
	// structure to hold all other local vars
	var v = StructNew();	
	
	//Remove dashes and parens from Phone
	arguments.Phone = reReplace(arguments.Phone,"[^[:digit:]]","","all");
	// Remove dashes and spaces from Zip
	arguments.Zip = reReplace(arguments.Zip,"[^[:digit:]]","","all");
	arguments.Billing_Zip = reReplace(arguments.Billing_Zip,"[^[:digit:]]","","all");
	
	//default return values
	FedExReg.debug = '';
	FedExReg.success = 0;
	FedExReg.errormessage = '';
</cfscript>


<cfsavecontent variable="soapxml">
<cfoutput>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<SOAP-ENV:Body>

	<RegisterWebCspUserRequest xmlns="http://fedex.com/ws/registration/v2">
	<WebAuthenticationDetail>
		<CspCredential>
			<Key>ZuEsOWWxhKwUxJed</Key>
			<Password>dOginXtWrxo8Isui3o1Akekt3</Password>
		</CspCredential>
	</WebAuthenticationDetail>
	<ClientDetail>
		<AccountNumber>#trim(arguments.accountno)#</AccountNumber>
		<ClientProductId>DPCF</ClientProductId>
		<ClientProductVersion>7146</ClientProductVersion>
	</ClientDetail>
	<Version>
		<ServiceId>fcas</ServiceId>
		<Major>2</Major>
		<Intermediate>1</Intermediate>
		<Minor>0</Minor>
	</Version>
	<!--- <cfif len(arguments.Billing_address1)> --->
	<BillingAddress>
		<StreetLines>#arguments.address1#</StreetLines>
		<cfif len(arguments.address2)><StreetLines>#arguments.address2#</StreetLines></cfif>
			<City>#arguments.city#</City>
			<StateOrProvinceCode>#arguments.state#</StateOrProvinceCode>
			<PostalCode>#arguments.zip#</PostalCode>
			<CountryCode>#arguments.country#</CountryCode>
	</BillingAddress>
	<!--- </cfif> --->
	<UserContactAndAddress>
		<Contact>
			<PersonName>
				<FirstName>#arguments.firstname#</FirstName>
				<LastName>#arguments.lastname#</LastName>
			</PersonName>
			<cfif len(arguments.company)><CompanyName>#arguments.company#</CompanyName></cfif>
			<cfif len(arguments.phone)><PhoneNumber>#arguments.phone#</PhoneNumber></cfif>
			<EMailAddress>#arguments.email#</EMailAddress>
		</Contact>
		<Address>
			<StreetLines>#arguments.address1#</StreetLines>
			<cfif len(arguments.address2)><StreetLines>#arguments.address2#</StreetLines></cfif>
			<City>#arguments.city#</City>
			<StateOrProvinceCode>#arguments.state#</StateOrProvinceCode>
			<PostalCode>#arguments.zip#</PostalCode>
			<CountryCode>#arguments.country#</CountryCode>
		</Address>
	</UserContactAndAddress>
</RegisterWebCspUserRequest>

</SOAP-ENV:Body>

</SOAP-ENV:Envelope>

</cfoutput>
</cfsavecontent>	

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp url="#gatewayURL#" method="post" resolveurl="No">
	<cfhttpparam type="CGI" name="SOAPAction" value="#gatewayURL#">
 	<cfhttpparam type="XML" name="cgi" value="#soapxml#">
</cfhttp>

<cftry> 
	<cfscript>
	
		try {
			v.FedExResponse = XmlParse(CFHTTP.FileContent);
			v.theResponse = v.FedExResponse.XmlRoot.Body.RegisterWebCspUserReply;
		
			if (v.theResponse.HighestSeverity.XmlText IS "SUCCESS")
				{
				//create an array to hold the returned info
				FedExReg.UserKey = v.theResponse.Credential.Key.XmlText;
				FedExReg.Password = v.theResponse.Credential.Password.XmlText;
				FedExReg.success = 1;
			}
			else
			{
				FedExReg.errormessage = v.theResponse.Notifications.Message.XmlText;
			}
		}
		
	catch(Any excpt) {
		FedExReg.errormessage = 'Invalid response received from FedEx. #CFHTTP.FileContent#';		
	}
	</cfscript>	
	
<cfcatch>
	<cfscript>
		FedExReg.errormessage =  "An unrecoverable error was encountered. Please contact your system admin for help.";
	</cfscript>
</cfcatch>

</cftry> 

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debugstring">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(soapxml))#<br />
		<H4>Header</H4>#htmleditformat(CFHTTP.Header)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))# 
		</cfoutput>
	</cfsavecontent>
	<cfset FedExReg.debug = v.debugstring>
</cfif>

<!--- Log files --->
<cfscript>
	if (arguments.logging) {
		LogXML('#tostring(soapxml)#', '#variables.fileIn#', 'Request Sent to #gatewayURL#');
		LogXML('#CFHTTP.FileContent#', '#variables.fileOut#', 'Response Received');
	}
</cfscript>

<cfreturn FedExReg>

</cffunction>

<!------------------------- BEGIN FEDEX SUBSCRIPTION FUNCTION ----------------------------------->

<cffunction name="doFedExSubscribe" returntype="struct" displayname="Subscribe to FedEx API Tools" hint="This function sends a subscription request to FedEx, used for registering a new user." output="No" access="public">
<!--- Optional Attributes
	personname - contact name
	companyname - company or contact name is required
	faxnumber 
	address2 	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if subscription accepted, otherwise 0 --->
<!--- If Success, returns meter number --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="UserKey" required="No" type="string" default="">
<cfargument name="Password" required="No" type="string" default="">
<cfargument name="FirstName" required="Yes" type="string" default="">
<cfargument name="LastName" required="Yes" type="string" default="">
<cfargument name="Company" required="No" type="string" default="">
<cfargument name="Address1" required="Yes" type="string">
<cfargument name="City" required="Yes" type="string">
<cfargument name="State" required="No" type="string" default="">
<cfargument name="Zip" required="No" type="string" default="">
<cfargument name="Country" required="Yes" type="string">
<cfargument name="Phone" required="Yes" type="string">
<cfargument name="Email" required="No" type="string" default="">
<cfargument name="accountno" required="Yes" type="string" hint="FedEx account number">

<cfargument name="ShipToSame" required="no" type="Boolean" default="0">
<cfargument name="Shipping_Address1" required="no" type="string">
<cfargument name="Shipping_City" required="no" type="string">
<cfargument name="Shipping_State" required="no" type="string" default="">
<cfargument name="Shipping_Zip" required="no" type="string" default="">
<cfargument name="Shipping_Country" required="no" type="string">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="logging" type="boolean" default="No" displayname="XML logging" hint="Sets whether to log the XML requests and responses.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
			
<cfscript>
	var FedExSub = StructNew();
	var soapxml = '';
	//Remove dashes and parens from Phone and fax
	var PhoneNum = reReplace(arguments.Phone,"[^[:digit:]]","","all");
	// Remove dashes and spaces from Zip
	var ZipCode = reReplace(arguments.Zip,"[^[:digit:]]","","all");
	// loop counter
	var key = '';
	// structure to hold all other local vars
	var v = StructNew();	
	
	//default return values
	FedExSub.debug = '';
	FedExSub.success = 0;
	FedExSub.errormessage = '';
	
	if (arguments.ShipToSame) {
		arguments.Shipping_Address1 = arguments.Address1;
		arguments.Shipping_City = arguments.City;
		arguments.Shipping_State = arguments.State;
		arguments.Shipping_Zip = arguments.Zip;
		arguments.Shipping_Country = arguments.Country;
	}
</cfscript>


	<cfsavecontent variable="soapxml">
	<cfoutput>
	<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<SOAP-ENV:Body>
	<SubscriptionRequest xmlns="http://fedex.com/ws/registration/v2">
		<WebAuthenticationDetail>
			<CspCredential>
				<Key>ZuEsOWWxhKwUxJed</Key>
				<Password>dOginXtWrxo8Isui3o1Akekt3</Password>
			</CspCredential>
			<UserCredential>
				<Key>#arguments.userkey#</Key>
				<Password>#arguments.password#</Password>
			</UserCredential>
		</WebAuthenticationDetail>
		<ClientDetail>
			<AccountNumber>#trim(arguments.accountno)#</AccountNumber>
			<MeterNumber/>
			<ClientProductId>DPCF</ClientProductId>
			<ClientProductVersion>7146</ClientProductVersion>
		</ClientDetail>
		<Version>
			<ServiceId>fcas</ServiceId>
			<Major>2</Major>
			<Intermediate>1</Intermediate>
			<Minor>0</Minor>
		</Version>
		<CspSolutionId>121</CspSolutionId>
		<CspType>CERTIFIED_SOLUTION_PROVIDER</CspType>
		<Subscriber>
			<AccountNumber>#arguments.accountno#</AccountNumber>
			<Contact>
				<PersonName>#arguments.FirstName# #arguments.LastName#</PersonName>
				<CompanyName>#arguments.Company#</CompanyName>
				<PhoneNumber>#arguments.Phone#</PhoneNumber>
				<FaxNumber/>
				<EMailAddress>#arguments.Email#</EMailAddress>
			</Contact>
			<Address>
				<StreetLines>#arguments.Address1#</StreetLines>
				<cfif len(arguments.address2)><StreetLines>#arguments.address2#</StreetLines></cfif>
				<City>#arguments.City#</City>
				<StateOrProvinceCode>#arguments.State#</StateOrProvinceCode>
				<PostalCode>#arguments.Zip#</PostalCode>
				<CountryCode>#arguments.Country#</CountryCode>
			</Address>
		</Subscriber>
		<AccountShippingAddress>
			<StreetLines>#arguments.Shipping_Address1#</StreetLines>
			<cfif len(arguments.Shipping_address2)><StreetLines>#arguments.Shipping_address2#</StreetLines></cfif>
			<City>#arguments.Shipping_City#</City>
			<StateOrProvinceCode>#arguments.Shipping_State#</StateOrProvinceCode>
			<PostalCode>#arguments.Shipping_Zip#</PostalCode>
			<CountryCode>#arguments.Shipping_Country#</CountryCode>
		</AccountShippingAddress>
	</SubscriptionRequest>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	</cfoutput>
	</cfsavecontent>
	
<cfset variables.requestheader["Content-Length"] = len(trim(tostring(soapxml)))>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp url="#gatewayURL#" method="post" resolveurl="No">
	<cfhttpparam type="CGI" name="SOAPAction" value="#gatewayURL#">
 	<cfhttpparam type="XML" name="cgi" value="#soapxml#">
</cfhttp>

<cftry> 
	<cfscript>
	
		try {
			v.FedExResponse = XmlParse(CFHTTP.FileContent);
			v.theResponse = v.FedExResponse.XmlRoot.Body.SubscriptionReply;
	
			if (v.theResponse.HighestSeverity.XMLText IS "SUCCESS")
				{
				//create an array to hold the returned info
				FedExSub.MeterNum = v.theResponse.MeterNumber.XmlText;
				FedExSub.success = 1;
			}
			else
			{
				FedExSub.errormessage = v.theResponse.Notifications.Message.XmlText;
			}
		}
		
		catch(Any excpt) {
			FedExSub.errormessage = 'Invalid response received from FedEx. #CFHTTP.FileContent#';		
		} 
	</cfscript>	
	
<cfcatch>
	<cfscript>
		FedExSub.errormessage =  "An unrecoverable error was encountered. Please contact your system admin for help.";
	</cfscript>
</cfcatch>

</cftry> 

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debugstring">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(soapxml))#<br />
		<H4>Header</H4>#htmleditformat(CFHTTP.Header)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))# 
		</cfoutput>
	</cfsavecontent>
	<cfset FedExSub.debug = v.debugstring>
</cfif>

<!--- Log files --->
<cfscript>
	if (arguments.logging) {
		LogXML('#tostring(soapxml)#', '#variables.fileIn#', 'Request Sent to #gatewayURL#');
		LogXML('#CFHTTP.FileContent#', '#variables.fileOut#', 'Response Received');
	}
</cfscript>

<cfreturn FedExSub>

</cffunction>

<!------------------------- END FEDEX SUBSCRIPTION FUNCTION ----------------------------------->


<!------------------------- BEGIN FEDEX VERSION CAPTURE FUNCTION ------------------------------>
<cffunction name="doFedExVerCapture" returntype="struct" displayname="Send a Version Capture transaction to FedEx" hint="This function sends a version capture request to FedEx, used after registering a new user." output="No" access="public">
<!--- Optional Attributes	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if version capture accepted, otherwise 0 --->
<!--- If Success, returns meter number --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="accountno" required="Yes" type="string" hint="FedEx Account number">
<cfargument name="UserKey" required="Yes" type="string">
<cfargument name="UserPass" required="Yes" type="string">
<cfargument name="meternum" required="Yes" type="string" hint="Meter number for this account">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="logging" type="boolean" default="No" displayname="XML logging" hint="Sets whether to log the XML requests and responses.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<cfscript>
	var FedExVersion = StructNew();
	var soapxml = '';
	// loop counter
	var key = '';
	// structure to hold all other local vars
	var v = StructNew();
	
	//default return values
	FedExVersion.debug = '';
	FedExVersion.success = 0;
	FedExVersion.errormessage = '';
</cfscript>


	<cfsavecontent variable="soapxml">
	<cfoutput>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://fedex.com/ws/registration/v2">
   <soapenv:Header/>
   <soapenv:Body>
      <VersionCaptureRequest>
         <WebAuthenticationDetail>
            <CspCredential>
               <Key>ZuEsOWWxhKwUxJed</Key>
               <Password>dOginXtWrxo8Isui3o1Akekt3</Password>
            </CspCredential>
            <UserCredential>
				<Key>#arguments.userkey#</Key>
				<Password>#arguments.userpass#</Password>
			</UserCredential>
         </WebAuthenticationDetail>
         <ClientDetail>
            <AccountNumber>#arguments.accountno#</AccountNumber>
            <MeterNumber>#arguments.meternum#</MeterNumber>
            <ClientProductId>DPCF</ClientProductId>
            <ClientProductVersion>7146</ClientProductVersion>
            <Region>US</Region>
         </ClientDetail>
         <TransactionDetail>
            <CustomerTransactionId>Version Capture Request</CustomerTransactionId>
         </TransactionDetail>
         <Version>
            <ServiceId>fcas</ServiceId>
            <Major>2</Major>
            <Intermediate>1</Intermediate>
            <Minor>0</Minor>
         </Version>
         <OriginLocationId>RDUA</OriginLocationId>
         <VendorProductPlatform>ACF700</VendorProductPlatform>
      </VersionCaptureRequest>
   </soapenv:Body>
</soapenv:Envelope>
	</cfoutput>
	</cfsavecontent>
	
<cfset variables.requestheader["Content-Length"] = len(trim(tostring(soapxml)))>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp url="#gatewayURL#" method="post" resolveurl="No">
	<cfhttpparam type="CGI" name="SOAPAction" value="#gatewayURL#">
 	<cfhttpparam type="XML" name="cgi" value="#soapxml#">
</cfhttp>

<cftry> 
	<cfscript>
	
		try {
			v.FedExResponse = XmlParse(CFHTTP.FileContent);
			v.theResponse = v.FedExResponse.XmlRoot.Body.VersionCaptureReply;
	
			if (v.theResponse.HighestSeverity.XMLText IS "SUCCESS")
				{
				FedExVersion.success = 1;
			}
			else
			{
				FedExVersion.errormessage = v.theResponse.Notifications.Message.XmlText;
			}
		}
		
		catch(Any excpt) {
			FedExVersion.errormessage = 'Invalid response received from FedEx. #CFHTTP.FileContent#';		
		} 
	</cfscript>	
	
<cfcatch>
	<cfscript>
		FedExVersion.errormessage =  "An unrecoverable error was encountered. Please contact your system admin for help.";
	</cfscript>
</cfcatch>

</cftry> 

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debugstring">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(soapxml))#<br />
		<H4>Header</H4>#htmleditformat(CFHTTP.Header)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))# 
		</cfoutput>
	</cfsavecontent>
	<cfset FedExVersion.debug = v.debugstring>
</cfif>

<!--- Log files --->
<cfscript>
	if (arguments.logging) {
		LogXML('#tostring(soapxml)#', '#variables.fileIn#', 'Request Sent to #gatewayURL#');
		LogXML('#CFHTTP.FileContent#', '#variables.fileOut#', 'Response Received');
	}
</cfscript>

<cfreturn FedExVersion>


</cffunction>
<!------------------------- END FEDEX VERSION CAPTURE FUNCTION --------------------------------->


<!------------------------- BEGIN ALL PACKAGES RATE FUNCTION ----------------------------------->
<cffunction name="getAllRates" returntype="struct" displayname="FedEx rates for multiple shipments" hint="Retrieve FedEx rates for multiple shipments and combine rates into one structure, by running the doFedExRate method for each package." output="No" access="public">

<!--- Required Attributes 
	carriers
	ShipArray
	accountno
	meternum 
	userkey
	userpass
	addressinfo
--->
<!--- Optional Attributes
	
	dropoff	
	package
	service	
	addinsurance
	units
	 
	timeout
	logging
	Debug (set to Yes or True to see output of request sent and full response received)
	test
 --->
 
<!--- Returned Values --->
<!--- Success = 1 if rate returned, otherwise 0 --->
<!--- If Success, returns structure of the rates --->
<!--- If Error, returns ErrorMessage --->

<cfscript>
	//structure to hold the combined rates for the shippers 
	var FedexRates = StructNew();
	var allResult = StructNew();
	var unmatchedRates = StructNew();
	var errorMessage = '';
	var debugstring = '';
	//queries
	var qryFedExMethods = '';
	var serviceInfo = '';
	// loop counters
	var shipper = '';
	var i = 0;
	var thecarrier = '';
	var key = '';
	
	//Service names list
	var serviceNames = '';
	
	// For each shipper, retrieve the shipment rates
	var numshippers = ArrayLen(arguments.ShipArray);
	 
	// structure to hold all other local vars
	var v = StructNew();

	//add other necessary information to arguments scope
	StructInsert(arguments, "shipment", "");
	StructInsert(arguments, "carrier", "");
	
</cfscript> 

	<!--- If only retrieving one service type, get the carrier for that service --->
	<cfif isDefined("arguments.service")>
		<cfset qryFedExMethods = Application.objShipping.getFedExMethods()>
		
		<cfquery name="serviceInfo" dbtype="query">
			SELECT Shipper FROM qryFedExMethods
			WHERE Code = '#UCase(arguments.service)#'
		</cfquery>
		
		<cfset arguments.carriers = serviceInfo.Shipper>
	</cfif>

	<cfloop index="shipper" from="1" to="#numshippers#">
	
		<cfscript>
		v.ItemStruct = arguments.ShipArray[shipper];

		//add the packages to ship to the arguments collection
		StructUpdate(arguments, "shipment", v.ItemStruct);
		
		//rate structure for each shipment
		v.tempRates = StructNew();
		v.tempList = serviceNames;	
			
		// Run the FedEx request for selected carrier types 
		for ( i = 1; i lte listLen(arguments.carriers); i = i+1 ) {		

			arguments.Carrier = listGetAt(arguments.carriers, i);
					
			//Get FedEx Shipping Amount
			v.Result = doFedExRate(argumentcollection=arguments);
					
			//append debug string
			debugstring = debugstring & v.Result.debug;
			if (v.Result.Success and shipper is 1) {
				//if first package, add rates to the structure
				StructAppend(FedexRates, v.Result.Rates, "No");
				serviceNames = ListAppend(serviceNames, StructKeyList(v.Result.Rates));
				}
			else if (v.Result.Success) {
				//add rates to temporary structure
				StructAppend(v.tempRates, v.Result.Rates, "No");
			}
			else 
				errorMessage = v.Result.errormessage;
		}

		// combine rates if more than one shipment
		if (StructCount(v.tempRates)) {					
			for (key IN v.tempRates) {
				if (StructKeyExists(FedExRates, "#key#")) {
				FedExRates[key] = FedExRates[key] + v.tempRates[key];
				v.tempList = ListDeleteAt(v.tempList, ListFind(v.tempList, key));
				}
			}
			// after looping through all values, check for items that didn't have matches
			for (k=1; k lte ListLen(v.tempList); k=k+1) {
				StructInsert(unmatchedRates, ListGetAt(v.tempList, k), "0", "true");
			}
		}
		</cfscript>					

	</cfloop>
	
	<cfscript>
	//after processing all data, remove any rates that were missing matches
	if (NOT StructIsEmpty(unmatchedRates)) {
		for (key In unmatchedRates) {
			if (StructKeyExists(FedExRates, "#key#"))
			StructDelete(FedExRates, key);
		}
	}
	
	//if no rates left, return error message	
	StructInsert(allResult, "Rates", FedExRates);
	if (NOT StructIsEmpty(FedExRates) AND NOT len(errorMessage)) {
		StructInsert(allResult, "Success", "1");
		StructInsert(allResult, "ErrorMessage", "");
	}
	else {
		StructInsert(allResult, "Success", "0");
		StructInsert(allResult, "ErrorMessage", errorMessage);
	}
	
	// add debug
	StructInsert(allResult, "debug", debugstring);
	
	</cfscript>		
	
	<!--- Add dump of final rates --->
	<cfif len(allResult.debug)>
		<cfsavecontent variable="v.adddebug">
			<cfdump var="#arguments.ShipArray#">
			<cfoutput>#allResult.debug#</cfoutput>
			<cfdump var="#FedExRates#">
		</cfsavecontent>
		<cfset allResult.debug =  v.adddebug>
	</cfif>
 
 	<cfreturn allResult>
 

</cffunction>


<!------------------------- END ALL PACKAGES RATE FUNCTION ----------------------------------->


<!------------------------- BEGIN FEDEX RATE REQUEST FUNCTION ----------------------------------->

<cffunction name="doFedExRate" returntype="struct" displayname="Retrieve FedEx Rates" hint="This function sends a rate request to FedEx, to retrieve all available rates for a given shipping address and shipper." access="package" output="No">
<!--- Required Attributes 
	carrier
	userkey
	userpass
	accountno
	meternum 
	shipment
	addressinfo
	--->
	
<!--- Optional Attributes	
	dropoff	
	packaging
	service 	
	addinsurance
	units
	 
	timeout
	logging
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if rate returned, otherwise 0 --->
<!--- If Success, returns Postage --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="carrier" required="No" type="string" default="FDXE" displayname="FedEx Carrier" hint="The FedEx carrier used for the shipment." >

<cfargument name="Shipment" type="struct" required="Yes" displayname="Shipment Information" hint="An structure containing the information for the packages that will be shipped.">
<cfargument name="addressinfo" type="struct" required="Yes" displayname="Customer address information" hint="The customer address information." default="">

<cfargument name="dropoff" type="string" required="No" default="REGULARPICKUP" displayname="Dropoff Type" hint="The type of package dropoff being used. Default setting is regular pickup.">
<cfargument name="packaging" type="string" required="No" default="YOURPACKAGING" displayname="Packaging Type" hint="Type of packaging used for this shipment. Default is your own packaging.">
<cfargument name="service" type="string" required="No" default="All" displayname="FedEx Service" hint="The service to retrieve rates for. Default is to get all services.">
<cfargument name="addinsurance" type="boolean" default="no" displayname="Add Insurance" hint="Toggles whether to add insurance to the rate request">

<cfargument name="units" type="string" required="No" default="LBS/IN" displayname="Units of Measurement" hint="The units of measurement being used. Default setting is pounds and inches.">

<cfargument name="accountno" type="string" required="Yes" displayname="Account Number" hint="FedEx Account number for the shipper.">
<cfargument name="UserKey" required="Yes" type="string" >
<cfargument name="UserPass" required="Yes" type="string" >
<cfargument name="meternum" type="string" required="Yes" displayname="Meter Number" hint="Meter number assigned by FedEx to this account.">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="logging" type="boolean" default="No" displayname="XML logging" hint="Sets whether to log the XML requests and responses.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<cfscript>
	var FedExRates = StructNew();
	var soapxml = '';
	// loop counter
	var key = '';
	var thePackages = arguments.Shipment.Packages;
	// structure to hold all other local vars
	var v = StructNew();
	
	//default return values
	FedExRates.debug = '';
	FedExRates.success = 0;
	FedExRates.errormessage = '';
</cfscript>


<cfscript>
if (ListLen(arguments.units, "/") is 2) {
	v.unitofweight = ListGetAt(arguments.units, 1, "/");
	v.unitoflength = ListGetAt(arguments.units, 2, "/");
	}
else {
	v.unitofweight = "LBS";
	v.unitoflength = "IN";
}

v.CustomerAddr = arguments.AddressInfo;
v.MerchantAddr = arguments.Shipment.ShipFrom;

</cfscript>

<cfsavecontent variable="soapxml">
	<cfoutput>
	<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<SOAP-ENV:Body>
	<RateRequest xmlns="http://fedex.com/ws/rate/v9">
		<WebAuthenticationDetail>
			<UserCredential>
				<Key>#arguments.userkey#</Key>
				<Password>#arguments.userpass#</Password>
			</UserCredential>
		</WebAuthenticationDetail>
		<ClientDetail>
			<AccountNumber>#trim(arguments.accountno)#</AccountNumber>
			<MeterNumber>#arguments.meternum#</MeterNumber>
		</ClientDetail>
		<Version>
			<ServiceId>crs</ServiceId>
			<Major>9</Major>
			<Intermediate>0</Intermediate>
			<Minor>0</Minor>
		</Version>
		<CarrierCodes>#arguments.carrier#</CarrierCodes>
		<RequestedShipment>
			<DropoffType>#arguments.dropoff#</DropoffType>
			<cfif arguments.service IS NOT "All">
			<ServiceType>#arguments.service#</ServiceType>
			</cfif>
			<PackagingType>#arguments.packaging#</PackagingType>
			<Shipper>
			<Contact>
		<PersonName></PersonName>
		<CompanyName></CompanyName>
		</Contact>
		<Address>
		<!---
		<StreetLines>#v.MerchantAddr.Address1#</StreetLines>
			
			<cfif len(v.MerchantAddr.City)><City>#v.MerchantAddr.City#</City></cfif>
		--->	
		<cfif len(v.MerchantAddr.State)><StateOrProvinceCode>#v.MerchantAddr.State#</StateOrProvinceCode></cfif>
		<cfif len(v.MerchantAddr.Zip)><PostalCode>#v.MerchantAddr.Zip#</PostalCode></cfif>
			<CountryCode>#v.MerchantAddr.Country#</CountryCode>
			</Address>
		</Shipper>
		<Recipient>
			<Contact>
			</Contact>
		<Address>
			<cfif len(v.CustomerAddr.City)><City>#v.CustomerAddr.City#</City></cfif>
			<cfif len(v.CustomerAddr.Zip)><PostalCode>#v.CustomerAddr.Zip#</PostalCode></cfif>
			<CountryCode>#v.CustomerAddr.Country#</CountryCode>
			<cfif v.CustomerAddr.Residence><Residential>1</Residential></cfif>
		
		</Address>
		</Recipient>
		<RateRequestTypes>ACCOUNT</RateRequestTypes>
		<cfset v.numshipments = ArrayLen(thePackages)>
		<PackageCount>#v.numshipments#</PackageCount>
		<PackageDetail>INDIVIDUAL_PACKAGES</PackageDetail>
		<cfset local.packageNum = 0 />
		<!--- Loop through the shipment array to output the packages --->
		<cfloop index="i" from="1" to="#v.numshipments#">
			<!--- Output a package for each quantity in the array --->
			<cfset v.ItemStruct = thePackages[i]>
			<cfset v.numboxes = v.ItemStruct.Quantity>
			<cfloop index="i" from="1" to="#v.numboxes#">		
				<cfset local.packageNum = local.packageNum + 1 />
				<RequestedPackageLineItems>
				<SequenceNumber>#local.packageNum#</SequenceNumber>
				<!--- No insurance on SmartPost shipments ---->
				<cfif arguments.addinsurance AND arguments.carrier IS NOT "FXSP">
					<InsuredValue>
					<Currency>#variables.currency#</Currency>
					<Amount>#v.ItemStruct.Value#</Amount>
					</InsuredValue>
				</cfif>
				<Weight>
				<Units>#Left(v.unitofweight,2)#</Units>
				<Value>#v.ItemStruct.weight#</Value>
				</Weight>
				<cfif v.ItemStruct.Pack_Length IS NOT 0>
					<Dimensions>
						<Length>#v.ItemStruct.Pack_Length#</Length>
						<Width>#v.ItemStruct.Pack_Width#</Width>
						<Height>#v.ItemStruct.Pack_Height#</Height>
						<Units>#Left(v.unitoflength,2)#</Units>
					</Dimensions>
				</cfif>
				</RequestedPackageLineItems>	
			</cfloop>
		</cfloop>
	</RequestedShipment>
	</RateRequest>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	</cfoutput>
	</cfsavecontent>
	
<cfset variables.requestheader["Content-Length"] = len(trim(tostring(soapxml)))>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp url="#gatewayURL#" method="post" resolveurl="No">
	<cfhttpparam type="CGI" name="SOAPAction" value="#gatewayURL#">
 	<cfhttpparam type="XML" name="cgi" value="#soapxml#">
</cfhttp>

<cfscript>
	
	try {
			v.FedExResponse = XmlParse(CFHTTP.FileContent);
			v.theResponse = v.FedExResponse.XmlRoot.Body.RateReply;
	
			if ( NOT ListFind("ERROR,FAILURE", v.theResponse.HighestSeverity.XMLText) ) {
				//create an structure to hold the returned rates
				FedExRates.Rates = StructNew();
				//add each returned rate to the structure
				v.returnedRates = XMLSearch(v.theResponse, "//*[local-name()='RateReplyDetails']" );
				v.NumRates = ArrayLen(v.returnedRates);
				for (x=1; x LTE v.NumRates; x=x+1) {
					v.ServiceName = v.returnedRates[x].ServiceType.XmlText;
					v.RateCost = v.returnedRates[x].RatedShipmentDetails.ShipmentRateDetail.TotalNetCharge.Amount.XmlText;
					StructInsert(FedExRates.Rates, v.ServiceName, v.RateCost);
				}
				FedExRates.success = 1;
			}
			else
			{
				FedExRates.errormessage = v.theResponse.Notifications.Message.XmlText;
			}
		}
		
		catch(Any excpt) {
			FedExRates.errormessage = 'Invalid response received from FedEx. #CFHTTP.FileContent#';		
		} 
					
		
		
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debugstring">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(soapxml))#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))# 
		</cfoutput>
		<cfdump var="#FedExRates#">
	</cfsavecontent>
	<cfset FedExRates.debug = v.debugstring>
</cfif>

<!--- Log files --->
 <cfscript>
	if (arguments.logging) {
		LogXML('#tostring(soapxml)#', '#variables.fileIn#', 'Request Sent to #gatewayURL#');
		LogXML('#CFHTTP.FileContent#', '#variables.fileOut#', 'Response Received');
	}
</cfscript> 


<cfreturn FedExRates>


</cffunction>
<!------------------------- END FEDEX RATE REQUEST FUNCTION ----------------------------------->

<!-------------------------- FEDEX TRACKING REQUEST ------------------------------------->

<cffunction name="getTracking" displayname="FedEx Tracking Tool" hint="This function retrieves tracking information from FedEx, given a specific tracking number." returntype="Struct" access="public" output="No">

	<cfargument name="TrackingNumber" type="string" required="Yes" displayname="Tracking Number" hint="The tracking number for the shipment.">

	<cfargument name="carrier" required="No" type="string" default="FDXE" displayname="FedEx Carrier" hint="The FedEx carrier used for the shipment." >

	<cfargument name="UserKey" required="No" type="string" default="">
	<cfargument name="UserPass" required="No" type="string" default="">
	<cfargument name="accountno" type="numeric" required="Yes" displayname="Account Number" hint="FedEx Account number for the shipper.">
	<cfargument name="meternum" type="numeric" required="Yes" displayname="Meter Number" hint="Meter number assigned by FedEx to this account.">

	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">

	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<cfscript>
	var Tracking = StructNew();
	var theResponse = '';
	var thePackage = '';
	var soapxml = '';
	var debugstring = '';
	var key = '';

	//default return values
	Tracking.debug = '';
	Tracking.success = 0;
	Tracking.errormessage = '';
</cfscript>


	<cfsavecontent variable="soapxml">
	<cfoutput>
	<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<SOAP-ENV:Body>
	<TrackRequest xmlns="http://fedex.com/ws/track/v4">
		<WebAuthenticationDetail>
			<CspCredential>
				<Key>ZuEsOWWxhKwUxJed</Key>
				<Password>dOginXtWrxo8Isui3o1Akekt3</Password>
			</CspCredential>
			<UserCredential>
				<Key>#arguments.userkey#</Key>
				<Password>#arguments.userpass#</Password>
			</UserCredential>
		</WebAuthenticationDetail>
		<ClientDetail>
			<AccountNumber>#trim(arguments.accountno)#</AccountNumber>
			<MeterNumber/>
			<ClientProductId>DPCF</ClientProductId>
			<ClientProductVersion>7146</ClientProductVersion>
		</ClientDetail>
		<Version>
			<ServiceId>trck</ServiceId>
			<Major>4</Major>
			<Intermediate>0</Intermediate>
			<Minor>0</Minor>
		</Version>
		<PackageIdentifier>
		<Value>#arguments.TrackingNumber#</Value>
		<Type>TRACKING_NUMBER_OR_DOORTAG</Type>
		</PackageIdentifier>
		<IncludeDetailedScans>true</IncludeDetailedScans>
	</TrackRequest>
	</SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	</cfoutput>
	</cfsavecontent>
	
<cfset variables.requestheader["Content-Length"] = len(trim(tostring(soapxml)))>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp url="#gatewayURL#" method="post" resolveurl="No">
	<cfhttpparam type="CGI" name="SOAPAction" value="#gatewayURL#">
 	<cfhttpparam type="XML" name="cgi" value="#soapxml#">
</cfhttp>

<!--- <cftry>  --->
 
	<cfscript>
		
		//try {
			v.FedExResponse = XmlParse(CFHTTP.FileContent);
			v.theResponse = v.FedExResponse.XmlRoot.Body.TrackReply;
			
			if ( NOT ListFind("ERROR,FAILURE", v.theResponse.HighestSeverity.XMLText) ) {
				thePackage = v.theResponse.TrackDetails;
				Tracking.TrackNumber = thePackage.TrackingNumber.XMLText;
				Tracking.Service = thePackage.ServiceInfo.XMLText;
				// Save the shipping information for the package
				Tracking.Address = StructNew();
				if (isDefined("thePackage.DestinationAddress")) 
					Tracking.Address = thePackage.DestinationAddress;
				if (isDefined("thePackage.PackageWeight")) {
					Tracking.WeightUnit = thePackage.PackageWeight.Units.XMLText;
					Tracking.Weight = thePackage.PackageWeight.Value.XMLText;
				}	
				if (isDefined("thePackage.StatusDescription")) 
					Tracking.StatusDescription = thePackage.StatusDescription.XMLText;
				if (isDefined("thePackage.ShipTimestamp")) 
					Tracking.ShipDate = thePackage.ShipTimestamp.XMLText;
				if (isDefined("thePackage.EstimatedDeliveryTimestamp")) 
					Tracking.EstimatedDeliveryDate = thePackage.EstimatedDeliveryTimestamp.XMLText;
				if (isDefined("thePackage.ActualDeliveryTimestamp")) 
					Tracking.DeliveredDate = thePackage.ActualDeliveryTimestamp.XMLText;
				if (isDefined("thePackage.PackageCount")) 
					Tracking.PackageCount = thePackage.PackageCount.XMLText;
				//create an array to hold the activity information
				Tracking.Activity = XmlSearch(thePackage, "//v4:Events");
				Tracking.success = 1;
			}
			else
			{
				Tracking.errormessage = v.theResponse.Notifications.Message.XmlText;
			}
		//}
			
		//catch(Any excpt) {
		//	Tracking.errormessage = 'Invalid response received from FedEx. #CFHTTP.FileContent#';		
		//}
			
	</cfscript>

<!---  <cfcatch>
	<cfscript>
		Tracking.errormessage = "An unrecoverable error was encountered. Please make sure you entered the correct server address.";
	</cfscript>
</cfcatch>

</cftry>  --->
	
<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="debugstring">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(soapxml))#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))# 
		</cfoutput>
		<cfdump var="#Tracking#">
	</cfsavecontent>
	<cfset Tracking.debug = debugstring>
</cfif>

<!--- Log files --->
<cfscript>
	if (arguments.logging) {
		LogXML('#tostring(soapxml)#', '#variables.fileIn#', 'Request Sent to #gatewayURL#');
		LogXML('#CFHTTP.FileContent#', '#variables.fileOut#', 'Response Received');
	}
</cfscript>
	
<cfreturn Tracking>

</cffunction>

<!-------------------------- END FEDEX TRACKING REQUEST ------------------------------------->



</cfcomponent>