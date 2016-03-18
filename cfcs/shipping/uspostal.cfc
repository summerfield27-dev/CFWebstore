<!--- CFWebstore, version 6.50 --->

<cfcomponent displayname="U.S.P.S. Shipping & Registration Tool" hint="This component is used for handling the USPS API for shipping functions." output="No">
<!--- This component developed by Mary Jo Sminkey maryjo@cfwebstore.com --->
<!--- This tag was developed using the XML Tools provided by U.S.P.S. --->
<!--- Originally developed for use with CFWebstore e-commerce (www.cfwebstore.com) --->

<!--- Requires CFMX 6 or higher --->

<cfscript>
//Set Directory path for logs
variables.Directory = GetDirectoryFromPath(ExpandPath(Request.StorePath));
variables.Directory = variables.Directory & "logs" & Request.Slash;
variables.logfile = variables.Directory & "usps_log.txt";

// Set USPS API address and header information 
variables.gateway = "http://production.shippingapis.com/ShippingAPI.dll";
//test server
variables.testgateway = "http://testing.shippingapis.com/ShippingAPITest.dll";
</cfscript>

<!--- Include logging functions --->
<cfinclude template="logging.cfm">

<!------------------------- COMPONENT INITIALIZATION ----------------------------------->
<cffunction name="init" access="public" output="no" returntype="uspostal">
    <cfreturn this>
  </cffunction>


<!------------------------- BEGIN ALL PACKAGES RATE FUNCTION ----------------------------------->
<cffunction name="getAllRates" returntype="struct" displayname="UPS rates for multiple shipments" hint="Retrieve UPS rates for multiple shipments and combine rates into one structure, by running the doUPSRate method for each shipper." output="No" access="public">

<!--- Required Attributes 
	ShipArray
	AddressInfo
	userid
	Server
--->
<!--- Optional Attributes
	Service	
	Container
	Size	
	Machinable
	 
	timeout
	logging
	Debug (set to Yes or True to see output of request sent and full response received)
	test
 --->
 
<!--- Returned Values --->
<!--- Success = 1 if rate returned, otherwise 0 --->
<!--- If Success, returns structure of the rates --->
<!--- If Error, returns ErrorMessage --->

<!--- The ShipArray is an array of all the packages in the shipment, by shipper. It allows you to calculate rates according to multiple drop-shippers. For each item in the array, it will hold a structure with the following keys:
	ShipFrom - Structure with the shippers information. Should include at a minimum the following keys:
		Country - Country code for the shipper
		Zip - Zip/Postal code for the shipper
	Packages - An array with the package information for this shipper. Each item in the array is a structure with these keys:
		Quantity - Total packages of this size and weight
		Weight - Weight of each package
		Pack_Length - For oversized packages, the package length. If not oversized, set to 0.
		Pack_Width - For oversized packages, the package width. If not oversized, set to 0.
		Pack_Height - For oversized packages, the package height. If not oversized, set to 0.
 --->
 
 <!--- AddressInfo is a structure with the customer's shipping address information. Contains the following keys:
 	Country - Country code from USPS
	Zip - Zip/Postal code
   --->
 


<cfscript>
	//structure to hold the combined rates for the shippers 
	var USPSRates = StructNew();
	var allResult = StructNew();
	var unmatchedRates = StructNew();
	var errorMessage = '';
	var debugstring = '';
	// loop counters
	var item = 0;
	var key = '';
	
	//Service names list
	var serviceNames = '';
	
	// For each shipper, retrieve the shipment rates
	var numshippers = ArrayLen(arguments.ShipArray);
	
	// structure to hold all other local vars
	var v = StructNew();	

	//add other necessary information to arguments scope
	StructInsert(arguments, "shipment", "");
	
</cfscript> 

	<cfloop index="item" from="1" to="#numshippers#">
		
	<cfscript>
		v.ItemStruct = arguments.ShipArray[item];

		//add the package to ship to the arguments collection
		StructUpdate(arguments, "shipment", v.ItemStruct);
		
		//rate structure for each shipment
		v.tempRates = StructNew();
		v.tempList = serviceNames;
		
		// Run the USPS request for this shipper 
		v.Result = doUSPSRate(argumentcollection=arguments);

		//append debug string
		debugstring = debugstring & v.Result.debug;
		if (v.Result.Success and Item is 1) {
			//if first package, add rates to the structure
			StructAppend(USPSRates, v.Result.Rates, "No");
			serviceNames = ListAppend(serviceNames, StructKeyList(v.Result.Rates));
			}
		else if (v.Result.Success) {
			//add rates to temporary structure
			StructAppend(v.tempRates, v.Result.Rates, "No");
		}
		else 
			errorMessage = v.Result.errormessage;
		
		// combine rates if more than one shipment
		if (StructCount(v.tempRates)) {					
			for (key IN v.tempRates) {
				if (StructKeyExists(USPSRates, "#key#")) {
				USPSRates[key] = USPSRates[key] + v.tempRates[key];
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
			if (StructKeyExists(USPSRates, "#key#"))
			StructDelete(USPSRates, key);
		}
	}
	
	//if no rates left or error message returned, return error message	
	StructInsert(allResult, "Rates", USPSRates);
	if (NOT StructIsEmpty(USPSRates) AND NOT len(errorMessage)) {
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
			<cfdump var="#USPSRates#">
		</cfsavecontent>
		<cfset allResult.debug =  v.adddebug>
	</cfif>
 
 	<cfreturn allResult> 

</cffunction>

<!------------------------- END ALL PACKAGES RATE FUNCTION ----------------------------------->




<!------------------------- BEGIN USPS RATE REQUEST FUNCTION ----------------------------------->

<cffunction name="doUSPSRate" returntype="struct" displayname="Retrieve USPS Rate" hint="This function sends a rate request to USPS, used for retrieving a rate for a given shipping method." access="public" output="No">
<!--- Required Attributes 
	userid
	Server
	AddressInfo
	Shipment  --->
	
<!--- Optional Attributes
	Service 
	Container (see USPS API documentation for valid entries)
	Size (Regular, Large, Oversize)
	Machinable (True or False)
	Timeout (max timeout for CF_HTTP request)
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if rate returned, otherwise 0 --->
<!--- If Success, returns Postage --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="userid" type="string" required="Yes" displayname="UserID" hint="USPS User ID for this merchant to access API.">
<cfargument name="service" type="string" required="No" default="All" displayname="USPS service to retrieve a rate for.">

<cfargument name="addressinfo" type="struct" required="Yes" displayname="Customer and Merchant address information" hint="The shipping and receiving address information." default="">

<cfargument name="Shipment" type="struct" required="Yes" displayname="Shipment Information" hint="An structure containing the information for the packages that will be shipped.">

<cfargument name="size" type="string" required="No" default="REGULAR" displayname="Package Size" hint="Size indicator for the shipment.">
<cfargument name="machinable" type="boolean" default="False" displayname="Machinable" hint="Indicates if shipment is machinable.">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="logging" type="boolean" default="No" displayname="XML logging" hint="Sets whether to log the XML requests and responses.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<cfscript>
var temprequest = '';
var USPSRates = StructNew();
var theResponse = StructNew();
var thePackages = arguments.Shipment.Packages;

//structure to hold all local vars
var v = StructNew();

v.CustomerAddr = arguments.AddressInfo;
v.MerchantAddr = arguments.Shipment.ShipFrom;

//default return values
USPSRates.debug = '';
USPSRates.success = 0;
USPSRates.errormessage = '';

if(val(arguments.timeout) LTE 0)
{
	arguments.timeout = 45;
}
// begin the request document and set variables for domestic vs international rates
if (v.CustomerAddr.country IS 'US') {
	temprequest = '<RateV4Request ';
	v.APItouse = 'RateV4';
	v.childelements = 'Postage';
	v.rateName = 'MailService';
	v.rateAmount = 'Rate';
	}
else {
	temprequest = '<IntlRateV2Request ';
	v.APItouse = 'IntlRateV2';
	v.childelements = 'Service';
	v.rateName = 'SvcDescription';
	v.rateAmount = 'Postage';
	}
	
// May 2015 Update	
temprequest = temprequest & 'USERID="#arguments.userid#">';
if (v.CustomerAddr.Country IS NOT 'US') {
temprequest = temprequest & '<Revision>2</Revision>';
}
else {
temprequest = temprequest & '<Revision/>';
}


v.packageID = 0;

// Loop through the shipment array to output the packages

v.numshipments = ArrayLen(thePackages);
for (i=1; i lte v.numshipments; i=i+1) {
	
	//Output a package for each quantity in the array
	v.ItemStruct = thePackages[i];
	v.numboxes = v.ItemStruct.Quantity;
	
	v.PackageWeight = NumberFormat(v.ItemStruct.Weight, ".9999");
	v.pounds = ListGetAt(v.PackageWeight, 1, ".");
	
	if (ListLen(v.PackageWeight, ".") GT 1) 
		v.ounces = Ceiling((v.PackageWeight-v.pounds) * 16);
	else
		v.ounces = 0;
			
	for (j=1; j lte v.numboxes; j=j+1) {
		v.packageID = v.packageID + 1;
		temprequest = temprequest & '<Package ID="#v.packageID#">';
		if (v.CustomerAddr.Country IS 'US') {
			temprequest = temprequest & '<Service>#arguments.service#</Service>';
			temprequest = temprequest & '<ZipOrigination>#v.MerchantAddr.Zip#</ZipOrigination>';
			temprequest = temprequest & '<ZipDestination>#v.CustomerAddr.Zip#</ZipDestination>';
		}
		temprequest = temprequest & '<Pounds>#v.pounds#</Pounds>';
		temprequest = temprequest & '<Ounces>#v.ounces#</Ounces>';	
		

		//determine size according to girth
		v.girth = (2*v.ItemStruct.Pack_Width) + (2*v.ItemStruct.Pack_Height);
		
		if ( v.ItemStruct.Pack_Width GT 12 OR v.ItemStruct.Pack_Height GT 12 OR v.ItemStruct.Pack_Length GT 12 ) {
			arguments.Size = 'LARGE';
		}	
		else {
			arguments.Size = 'REGULAR';
		}

		if (v.CustomerAddr.Country IS NOT 'US') {
			temprequest = temprequest & '<Machinable>#arguments.Machinable#</Machinable>';
			temprequest = temprequest & '<MailType>Package</MailType>';
		//	temprequest = temprequest & '<GXG><POBoxFlag>N</POBoxFlag><GiftFlag>N</GiftFlag></GXG>';
			temprequest = temprequest & '<ValueOfContents>#v.ItemStruct.Value#</ValueOfContents>';
			temprequest = temprequest & '<Country>#v.CustomerAddr.Country#</Country>';
			temprequest = temprequest & '<Container>RECTANGULAR</Container>';
		}	
		else {
		temprequest = temprequest & '<Container></Container>';
		}
		
		temprequest = temprequest & '<Size>#arguments.Size#</Size>';
		if (v.ItemStruct.Pack_Length GT 0) {	
			temprequest = temprequest & '<Width>#v.ItemStruct.Pack_Width#</Width>';
			temprequest = temprequest & '<Length>#v.ItemStruct.Pack_Length#</Length>';
			temprequest = temprequest & '<Height>#v.ItemStruct.Pack_Height#</Height>';	
			temprequest = temprequest & '<Girth>#v.girth#</Girth>';
		}
		else {
			temprequest = temprequest & '<Width></Width><Length></Length><Height></Height><Girth></Girth>';
		}
		
		// May 2015 Update
		if (v.CustomerAddr.Country IS 'US') {
			temprequest = temprequest & '<Machinable>#arguments.Machinable#</Machinable>';
		}
		else {
			temprequest = temprequest & '<OriginZip>#v.MerchantAddr.Zip#</OriginZip>';
		}
		temprequest = temprequest & '</Package>';	
	}
	
}

if (v.CustomerAddr.Country IS 'US') 
	temprequest = temprequest & '</RateV4Request>';
else
	temprequest = temprequest & '</IntlRateV2Request>';


</cfscript>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="get" url="#gatewayURL#?API=#v.APItouse#&XML=#urlencodedformat(temprequest)#" resolveurl="false" timeout="#arguments.timeout#">   

<cftry>

	<cfscript>
	
		try {		
			v.USPSResponse = XmlParse(CFHTTP.FileContent);
			theResponse = v.USPSResponse.XmlRoot;
	
			if (theResponse.XMLName IS NOT "Error")
				{
				//create an structure to hold the returned rates
				USPSRates.Rates = StructNew();
				v.serviceList = '';
				v.unmatchedRates = StructNew();
				//loop through each included package
				v.NumPackages = ArrayLen(theResponse.XmlChildren);
				for (i=1; i lte v.NumPackages; i=i+1) {
					// list used to check for matches, not used for first group of rates
					v.tempList = v.serviceList;
					//add each returned rate to the array
					v.thePackage = theResponse.XmlChildren[i];
					//check for errors
					if (isDefined("v.thePackage.Error")) {
						USPSRates.success = 0;
						USPSRates.errormessage = v.thePackage.Error.Description.XmlText;
					}
					else {
						//extract the rate information
						v.selectedRates = XMLSearch(v.thePackage, "#v.childelements#");
						v.NumRates = ArrayLen(v.selectedRates);
						// reverse loop to account for deleted services			
						for (j=v.NumRates; j gt 0; j=j-1) {
							v.ServiceName = v.selectedRates[j][v.rateName].XmlText;
							//replace any registration/trademark symbols and astericks in the XML
							v.ServiceName = Replace(v.ServiceName,"&lt;sup&gt;&##174;&lt;/sup&gt;", "");
							v.ServiceName = Replace(v.ServiceName,"&lt;sup&gt;&##8482;&lt;/sup&gt;", "");
							v.ServiceName = Replace(v.ServiceName, "*", "", "All");
							v.RateCost = v.selectedRates[j][v.rateAmount].XmlText;
							if (i is 1) {
								v.serviceList = ListPrepend(v.serviceList, v.ServiceName);
								StructInsert(USPSRates.Rates, v.ServiceName, v.RateCost);
							}
							else {
								v.valueinList = ListFind(v.tempList, v.ServiceName);
								if (v.valueinList) {
									USPSRates.Rates[v.ServiceName] = USPSRates.Rates[v.ServiceName] + v.RateCost;
									v.tempList = ListDeleteAt(v.tempList, v.valueinList);
								}		
							}
						}
						// after looping through all values, check for items that didn't have matches
						for (k=1; k lte ListLen(v.tempList); k=k+1) {
							StructInsert(v.unmatchedRates, ListGetAt(v.tempList, k), "0", "true");
						}
					}
				}				
				//after processing all data, remove any rates that were missing matches
					if (StructCount(v.unmatchedRates)) {
						for (key In v.unmatchedRates) {
						if (StructKeyExists(USPSRates.Rates, "#key#"))
							StructDelete(USPSRates.Rates, key);
						}
					}
				
				USPSRates.success = 1;
			}
			else
			{
				USPSRates.errormessage = theResponse.Description.XmlText;
			}
		}
		catch(Any excpt) {
			USPSRates.errormessage = 'Invalid response received from USPS. #CFHTTP.FileContent#';		
		}
		
	</cfscript>
	
	<!--- Debugging Output --->
		<cfif arguments.debug>
			<cfsavecontent variable="v.debug">
				<cfoutput>
				<H4>Request</H4>#htmleditformat(tostring(temprequest))#<br />
				<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
				</cfoutput>
				<cfdump var="#USPSRates#">
			</cfsavecontent>
			<cfset USPSRates.debug = v.debug>
		</cfif>

		<!--- Log files --->
		<cfscript>
			if (arguments.logging) {
				LogXML('#tostring(temprequest)#', '#variables.logfile#', 'Request Sent');
				LogXML('#CFHTTP.FileContent#', '#variables.logfile#', 'Response Received');
			}
		</cfscript>

<cfcatch>
	<cfscript>
		USPSRates.errormessage = "An unrecoverable error was encountered. Please make sure you entered the correct server address.";
	</cfscript>
</cfcatch>

</cftry>

<cfreturn USPSRates>


</cffunction>
<!------------------------- END USPS RATE REQUEST FUNCTION ----------------------------------->

<!-------------------------- USPS TRACKING REQUEST ------------------------------------->

<cffunction name="getTracking" displayname="U.S.P.S. Tracking Tool" hint="This function retrieves tracking information from US Postal Service, given a specific tracking number." returntype="Struct" access="public" output="No">

	<cfargument name="TrackingNumber" type="string" required="Yes" displayname="Tracking Number" hint="The tracking number for the shipment.">

	<cfargument name="userid" type="string" required="Yes" displayname="UserID" hint="USPS User ID for this merchant to access API.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
var temprequest = '';
var Tracking = StructNew();
var theResponse = StructNew();
//structure to hold all local vars
var v = StructNew();

//default return values
Tracking.debug = '';
Tracking.success = 0;
Tracking.errormessage = '';


if (val(arguments.timeout) LTE 0)
	arguments.timeout = 45;
	
// set up the request document 
temprequest = '<TrackRequest USERID="';
temprequest = temprequest & arguments.userid & '">';
temprequest = temprequest & '<TrackID ID="' & arguments.TrackingNumber & '">';
temprequest = temprequest & '</TrackID></TrackRequest>';
	
</cfscript>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="get" url="#gatewayURL#?API=TrackV2&XML=#urlencodedformat(temprequest)#" resolveurl="false" timeout="#arguments.timeout#">  

<cftry>

	<cfscript>
			
		try {
		
			USPSResponse = XmlParse(CFHTTP.FileContent);
			theResponse = USPSResponse.XmlRoot;
			
			//if (NOT isDefined("theResponse.Error"))
			if (theResponse.XMLName IS NOT "Error")
				{
				v.thePackage = theResponse.TrackInfo;
				if (isDefined("v.thePackage.Error")) {
					Tracking.success = 0;
					Tracking.errormessage = v.thePackage.Error.Description.XmlText;
					}
				else {
				Tracking.TrackNumber = v.thePackage.XmlAttributes.ID;
				Tracking.Summary = v.thePackage.TrackSummary.XMLText;
				//create an array to hold the activity information
				Tracking.Activity = XmlSearch(v.thePackage, "TrackDetail");			
				Tracking.success = 1;
				}
			}
			else
			{
				Tracking.errormessage = theResponse.Description.XmlText;
			}
		}
		catch(Any excpt) {
			Tracking.errormessage = 'Invalid response received from USPS. #CFHTTP.FileContent#';		
		}
			
	</cfscript>
	
	<!--- Debugging Output --->
	<cfif arguments.debug>
		<cfsavecontent variable="v.debug">
			<cfoutput>
			<H4>Request</H4>#htmleditformat(toString(temprequest))#<br />
			<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
			</cfoutput>
			<cfdump var="#Tracking#">
		</cfsavecontent>
		<cfset Tracking.debug = v.debug>
	</cfif>
	
	<!--- Log files --->
	<cfscript>
		if (arguments.logging) {
			LogXML('#tostring(temprequest)#', '#variables.logfile#', 'Request Sent');
			LogXML('#CFHTTP.FileContent#', '#variables.logfile#', 'Response Received');
		}
	</cfscript>


<cfcatch>
	<cfscript>
		Tracking.errormessage = "An unrecoverable error was encountered. Please make sure you entered the correct server address.";
	</cfscript>
</cfcatch>

</cftry>


<cfreturn Tracking>

</cffunction>

<!-------------------------- END USPS TRACKING REQUEST ------------------------------------->

<!-------------------- BEGIN USPS ADDRESS VERIFICATION TOOL ----------------------------->

<cffunction name="VerifyAddress" displayname="USPS Address Verification Tool" hint="This function takes a city, state, and zip and checks that they are a valid shipping address." returntype="struct" access="public" output="No">

	<cfargument name="Address1" type="string" required="No" default="" displayname="Address 1" hint="The apartment or suite number for the shipping address to verify.">
	<cfargument name="Address2" type="string" required="Yes" displayname="Address 2" hint="The street address for the shipping address to verify.">
	<cfargument name="City" type="string" required="Yes" displayname="City" hint="The city for the shipping address to verify.">
	<cfargument name="State" type="string" required="Yes" displayname="State" hint="The state for the shipping address to verify.">
	<cfargument name="Zipcode" type="string" required="Yes" displayname="Zip Code" hint="The zip code for the shipping address to verify.">

	<cfargument name="userid" type="string" required="Yes" displayname="UserID" hint="USPS User ID for this merchant to access API.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
var temprequest = '';
var Validated = StructNew();
var theResponse = StructNew();
//structure to hold all local vars
var v = StructNew();

//default return values
Validated.debug = '';
Validated.success = 0;
Validated.ValidAddress = 0;
Validated.errormessage = '';

if(val(arguments.timeout) LTE 0)
{
	arguments.timeout = 45;
}
if (ListLen(arguments.zipcode, "-") gt 1) {
	v.zip5 = ListGetAt(arguments.zipcode, 1, "-");
	v.zip4 = ListGetAt(arguments.zipcode, 2, "-");
	}
else  {
	v.zip5 = arguments.zipcode;
	v.zip4 = '';
}


// begin the request document
temprequest = '<AddressValidateRequest USERID="#arguments.userid#">';
temprequest = temprequest & '<Address ID="0">';
temprequest = temprequest & '<Address1>#arguments.address1#</Address1>';
temprequest = temprequest & '<Address2>#arguments.address2#</Address2>';
temprequest = temprequest & '<City>#arguments.city#</City>';
temprequest = temprequest & '<State>#arguments.state#</State>';
temprequest = temprequest & '<Zip5>#v.zip5#</Zip5>';
temprequest = temprequest & '<Zip4>#v.zip4#</Zip4>';
temprequest = temprequest & '</Address></AddressValidateRequest>';

</cfscript>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="get" url="#gatewayURL#?API=Verify&XML=#urlencodedformat(temprequest)#" resolveurl="false" timeout="#arguments.timeout#">  

<cfscript>

	try {
	
		v.USPSResponse = XmlParse(CFHTTP.FileContent);
		theResponse = v.USPSResponse.XmlRoot;
		
		if (theResponse.XMLName IS NOT "Error" AND NOT isDefined("theResponse.Address.Error")) {
			Validated.success = 1;
			//compare the address to the one we got and make sure they are the same
			if ( theResponse.Address.City.xmlText IS UCase(arguments.city)
					AND theResponse.Address.State.xmlText IS UCase(arguments.state) 
					AND theResponse.Address.Zip5.xmlText IS v.zip5 ) {
						Validated.ValidAddress = 1;
					}
			else {
				Validated.Address = StructNew();
				if ( isDefined("theResponse.Address.Address1") ) {
					Validated.Address.Address1 = theResponse.Address.Address1.xmlText;
				}
				Validated.Address.Address2 = theResponse.Address.Address2.xmlText;
				Validated.Address.City = theResponse.Address.City.xmlText;
				Validated.Address.State = theResponse.Address.State.xmlText;
				Validated.Address.Zip5 = theResponse.Address.Zip5.xmlText;
				Validated.Address.Zip4 = theResponse.Address.Zip4.xmlText;
				
			}
		}
		else if (isDefined("theResponse.Address.Error")) {
				Validated.success = 1;
				Validated.ErrorMessage = theResponse.Address.Error.Description.XMLText;
	
		}
		else
		{
			Validated.errormessage = theResponse.Description.XmlText;
		}
	}
	catch(Any excpt) {
		Validated.errormessage = 'Invalid response received from USPS. #CFHTTP.FileContent#';		
	}
		
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(toString(temprequest))#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
		</cfoutput>
		<cfdump var="#Validated#">
	</cfsavecontent>
	<cfset Validated.debug = v.debug>
</cfif>


<cfreturn Validated>

</cffunction>

<!-------------------- END USPS ADDRESS VERIFICATION TOOL ----------------------------->


</cfcomponent>