<!--- CFWebstore, version 6.50 --->

<cfcomponent displayname="UPS Rates & Services Tool" hint="This component is used for working with the UPS Rates & Services XML tool." output="No">

<!--- This component developed by Mary Jo Sminkey maryjo@cfwebstore.com --->
<!--- This tag was developed using the XML Tools provided by the UPS --->
<!--- Originally developed for use with CFWebstore e-commerce (www.cfwebstore.com) --->

<!--- Requires CFMX 6 or higher --->

<!--- To use these tools, you will need to register with UPS at:
		http://www.ups.com/e_comm_access/gettools_index?loc=en_US
		and receive a userid, password and Access Key --->

<cfscript>
	variables.encryptkey = "cfweb256";
	
	//Set Directory path for logs
	variables.Directory = GetDirectoryFromPath(ExpandPath(Request.StorePath));
	variables.Directory = variables.Directory & "logs" & Request.Slash;
	variables.logfile = variables.Directory & "ups_log.txt";
	
	// Set UPI API gateway server address
	variables.gateway = "https://onlinetools.ups.com/ups.app/xml";
	//test server
	variables.testgateway = "https://wwwcie.ups.com/ups.app/xml";
</cfscript>

<!--- Include logging functions --->
<cfinclude template="logging.cfm">

<!------------------------- COMPONENT INITIALIZATION ----------------------------------->
<cffunction name="init" access="public" output="no" returntype="upstools">
    <cfreturn this>
  </cffunction>


<!------------------------- BEGIN ALL PACKAGES RATE FUNCTION ----------------------------------->
<cffunction name="getAllRates" returntype="struct" displayname="UPS rates for multiple shipments" hint="Retrieve UPS rates for multiple shipments and combine rates into one structure, by running the doUPSRate method for each shipper." output="No" access="public">

<!--- Required Attributes 
	ShipArray
	AddressInfo
	Accesskey
	Username
	Password
--->
<!--- Optional Attributes
	
	Pickup	
	CustomerClass
	Service	
	Package
	Units
	 
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
	var UPSRates = StructNew();
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

		//add the packages to ship to the arguments collection
		StructUpdate(arguments, "shipment", v.ItemStruct);
		
		//rate structure for each shipment
		v.tempRates = StructNew();
		v.tempList = serviceNames;
		
		// Run the UPS request for this shipper 
		v.Result = doUPSRate(argumentcollection=arguments);

		//append debug string
		debugstring = debugstring & v.Result.debug;
		if (v.Result.Success and Item is 1) {
			//if first package, add rates to the structure
			StructAppend(UPSRates, v.Result.Rates, "No");
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
				if (StructKeyExists(UPSRates, "#key#")) {
				UPSRates[key] = UPSRates[key] + v.tempRates[key];
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
			if (StructKeyExists(UPSRates, "#key#"))
			StructDelete(UPSRates, key);
		}
	}
	
	//if no rates left or error message returned, return error message	
	StructInsert(allResult, "Rates", UPSRates);
	if (NOT StructIsEmpty(UPSRates) AND NOT len(errorMessage)) {
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
			<cfdump var="#UPSRates#">
		</cfsavecontent>
		<cfset allResult.debug =  v.adddebug>
		
	</cfif>
 
 	<cfreturn allResult>
 

</cffunction>


<!------------------------- END ALL PACKAGES RATE FUNCTION ----------------------------------->



<!------------------------ BEGIN UPS RATES & SERVICES TOOLS -------------------------------->

<cffunction name="doUPSRate" returntype="struct" displayname="Get a UPS Rate" hint="This function retrieves a UPS rate for the specified service, package weight, origin and destination." output="No">
		
<!--- Required Attributes 
	Shipment
	AddressInfo
	Accesskey
	Username
	Password
--->
	
<!--- Optional Attributes
	Pickup - Type of pickup used
	CustomerClass - Customer classification
	Service - Used if only rates for a particular service are needed
	Package - Type of packaging used
	Units - Units of measurement used
	Timeout (max timeout for CF_HTTP request)
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if postage rate returned, otherwise 0 --->
<!--- If Success, returns Postage --->
<!--- If Error, returns ErrorMessage --->

	<cfargument name="accountno" type="string" required="No" default="" displayname="UPS Account Number" hint="The UPS account number for the shipper.">

	<cfargument name="addressinfo" type="struct" required="Yes" displayname="Customer and Merchant address information" hint="The shipping and receiving address information." default="">

	<cfargument name="pickup" type="string" required="No" default="01" displayname="Pickup Type" hint="The type of package pickup being used. Default setting is daily pickup.">
	<!--- 
	Possible settings:
	01: Daily Pickup
	03: Customer Counter
	06: Onetime Pickup
	07: On call Air
	11: Suggested Retail Rates	
	19: Letter Center
	20: Air Service Center
	--->
	
	<cfargument name="customerclass" type="string" required="No" default="01" displayname="Customer Classification" hint="The UPS customer classification for the merchant. Default setting is wholesale.">
	<!--- 
	Possible settings:
	01: Wholesale
	03: Occasional
	04: Retail
	--->


	<cfargument name="package" type="string" required="No" default="02" displayname="Packaging Type" hint="Type of packaging used for this shipment. Default is your own packaging.">
	<!--- 
	Possible settings:
	01: UPS Letter
	02: Package
	03: UPS Tube
	04: UPS Pak
	21: UPS Express Box
	24: UPS 25kg Box
	25: UPS 10Kg Box
	--->
	
	<cfargument name="units" type="string" required="No" default="LBS/IN" displayname="Units of Measurement" hint="The units of measurement being used. Default setting is pounds and inches.">
	<!--- 
	Possible settings:
	LBS/IN: Pounds/inches
	KGS/CM: Kilograms/centimeters
	--->
	
	<cfargument name="service" type="string" required="No" default="All" displayname="UPS Service" hint="The service to retrieve rates for. Default is to get all services.">
	<cfargument name="Shipment" type="struct" required="Yes" displayname="Shipment Information" hint="An structure containing the information for the packages that will be shipped.">
	<cfargument name="Accesskey" type="string" required="Yes" displayname="Access Key" hint="The access key assigned by UPS.">
	<cfargument name="UserID" type="string" required="Yes" displayname="UserID" hint="The user ID assigned by UPS.">
	<cfargument name="UPSPassword" type="string" required="Yes" displayname="UPSPassword" hint="The password assigned by UPS.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
	//structure to hold all local vars
	var v = StructNew();
	
	var UPSRates = StructNew();
	var theResponse = StructNew();
	
	var thePackages = arguments.Shipment.Packages;
	
	//default return values
	UPSRates.debug = '';
	UPSRates.success = 0;
	UPSRates.errormessage = '';
	
	// Decrypt the UPS settings 
	try {
		v.Accesskey = UPSDecrypt(arguments.Accesskey);
		v.UserID = UPSDecrypt(arguments.UserID);
		v.UPSPassword = UPSDecrypt(arguments.UPSPassword);
		v.DecryptOK = "yes";
		}	
	 catch(Any excpt) {
		v.DecryptOK = "no";
		}
</cfscript>


<cfif v.DecryptOK>
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

<!--- Build the XML string --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0"?>
<AccessRequest>
	<AccessLicenseNumber>#v.Accesskey#</AccessLicenseNumber>
	<UserId>#v.UserID#</UserId>
	<Password>#v.UPSPassword#</Password>
</AccessRequest>
<?xml version="1.0"?>
<RatingServiceSelectionRequest>
	<Request>
		<TransactionReference>
			<CustomerContext>Rate Request</CustomerContext>
			<XpciVersion>1.0001</XpciVersion>
		</TransactionReference>
		<RequestAction>Rate</RequestAction>
		<cfif arguments.service IS "All"><RequestOption>Shop</RequestOption></cfif>
	</Request>
	<PickupType>
		<Code>#arguments.pickup#</Code>
	</PickupType>
	<CustomerClassification>
		<Code>#arguments.customerclass#</Code>
	</CustomerClassification>
	<Shipment>
		<Shipper>
			<cfif len(arguments.accountno)><ShipperNumber>#arguments.accountno#</ShipperNumber></cfif>
			<Address>
				<cfif len(v.MerchantAddr.City)><City>#v.MerchantAddr.City#</City></cfif>
				<cfif len(v.MerchantAddr.Zip)><PostalCode>#v.MerchantAddr.Zip#</PostalCode></cfif>
				<CountryCode>#v.MerchantAddr.Country#</CountryCode>
			</Address>
		</Shipper>
		<ShipTo>
			<Address>
				<cfif len(v.CustomerAddr.City)><City>#v.CustomerAddr.City#</City></cfif>
				<cfif len(v.CustomerAddr.Zip)><PostalCode>#v.CustomerAddr.Zip#</PostalCode></cfif>
				<CountryCode>#v.CustomerAddr.Country#</CountryCode>
				<cfif v.CustomerAddr.Residence><ResidentialAddressIndicator></ResidentialAddressIndicator></cfif>
			</Address>
		</ShipTo>
		<ShipmentWeight>
			<UnitOfMeasurement>
				<Code>#v.unitofweight#</Code>
			</UnitOfMeasurement>
			<Weight>#arguments.Shipment.TotalWeight#</Weight>
		</ShipmentWeight>
		<cfif arguments.service IS NOT "All">
		<Service><Code>#arguments.service#</Code></Service>
		</cfif>
		<!--- Loop through the shipment array to output the packages --->
		<cfset v.numshipments = ArrayLen(thePackages)>
		<cfloop index="i" from="1" to="#v.numshipments#">
		<!--- Output a package for each quantity in the array --->
			<cfset v.ItemStruct = thePackages[i]>
			<cfset v.numboxes = v.ItemStruct.Quantity>
			<cfloop index="i" from="1" to="#v.numboxes#">
				<Package>
					<PackagingType>
						<Code>#arguments.package#</Code>
					</PackagingType>
					<cfif v.ItemStruct.Pack_Length IS NOT 0>
					<Dimensions>
						<UnitOfMeasurement>
							<Code>#v.unitoflength#</Code>
						</UnitOfMeasurement>
						<Length>#v.ItemStruct.Pack_Length#</Length>
						<Width>#v.ItemStruct.Pack_Width#</Width>
						<Height>#v.ItemStruct.Pack_Height#</Height>
					</Dimensions>
					</cfif>
					<PackageWeight>
						<UnitOfMeasurement>
							<Code>#v.unitofweight#</Code>
						</UnitOfMeasurement>
						<Weight>#v.ItemStruct.weight#</Weight>
					</PackageWeight>
				</Package>
			</cfloop>
		</cfloop>
	</Shipment>
</RatingServiceSelectionRequest>
</cfoutput>
</cfsavecontent>

 <CFHTTP URL="#variables.gateway#/Rate" METHOD="Post" RESOLVEURL="false" TIMEOUT="#arguments.timeout#">
	<cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
</CFHTTP>


<cfscript>

	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSSuccess = theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			//create a structure to hold the returned rates
			UPSRates.Rates = StructNew();
			//add each returned rate to the array
			v.returnedRates = XMLSearch(theResponse, "RatedShipment");
			v.NumRates = ArrayLen(v.returnedRates);
			for (x=1; x LTE v.NumRates; x=x+1) {
				v.RateCode = v.returnedRates[x].Service.Code.XmlText;
				v.RateCost = v.returnedRates[x].TotalCharges.MonetaryValue.XmlText;
				StructInsert(UPSRates.Rates, v.RateCode, v.RateCost);
			}
			UPSRates.success = 1;
		}
		else
		{
			UPSRates.errormessage = theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		UPSRates.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}

</cfscript>


<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
		</cfoutput>
		<cfdump var="#UPSRates#">
	</cfsavecontent>
	<cfset UPSRates.debug = v.debug>
</cfif>

<!--- Log files --->
<cfscript>
	if (arguments.logging) {
		LogXML('#tostring(v.temprequest)#', '#variables.logfile#', 'Request Sent');
		LogXML('#CFHTTP.FileContent#', '#variables.logfile#', 'Response Received');
	}
</cfscript>


<!--- Decrypt of settings failed --->
<cfelse>
	<cfscript>
		UPSRates.errormessage = 'There was an error in the setup for shipping rates, please contact the system admistrator for more assistance';
	</cfscript>

</cfif>


<cfreturn UPSRates>

</cffunction>

<!------------------------ END UPS RATES & SERVICES TOOLS -------------------------------->


<!-------------------------- BEGIN UPS TRACKING TOOL ------------------------------------->

<cffunction name="getTracking" displayname="UPS Tracking Tool" hint="This function retrieves tracking information from UPS, given a specific tracking number." returntype="Struct" output="No" access="public">

	<cfargument name="TrackingNumber" type="string" required="Yes" displayname="Tracking Number" hint="The tracking number for the shipment.">

	<cfargument name="Accesskey" type="string" required="Yes" displayname="Access Key" hint="The access key assigned by UPS.">
	<cfargument name="UserID" type="string" required="Yes" displayname="UserID" hint="The user ID assigned by UPS.">
	<cfargument name="UPSPassword" type="string" required="Yes" displayname="UPSPassword" hint="The password assigned by UPS.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
	//structure to hold all local vars
	var v = StructNew();
	
	var Tracking = StructNew();
	var theResponse = StructNew();
	
	//default return values
	Tracking.debug = '';
	Tracking.success = 0;
	Tracking.errormessage = '';
	
	// Decrypt the UPS settings 
	try {
		v.Accesskey = UPSDecrypt(arguments.Accesskey);
		v.UserID = UPSDecrypt(arguments.UserID);
		v.UPSPassword = UPSDecrypt(arguments.UPSPassword);
		v.DecryptOK = "yes";
		}	
	 catch(Any excpt) {
		v.DecryptOK = "no";
		}
</cfscript>


<cfif v.DecryptOK>

<!--- Construct XML Packet to Send --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0"?>
<AccessRequest>
     <AccessLicenseNumber>#v.Accesskey#</AccessLicenseNumber>
     <UserId>#v.UserId#</UserId>
     <Password>#v.UPSPassword#</Password>
</AccessRequest>
<?xml version="1.0"?>
<TrackRequest xml:lang="en-US"> 
  <Request> 
  <TransactionReference> 
    <CustomerContext></CustomerContext> 
    <XpciVersion>1.0001</XpciVersion> 
  </TransactionReference> 
  <RequestAction>Track</RequestAction> 
  <RequestOption>activity</RequestOption> 
  </Request> 
     <TrackingNumber>#arguments.TrackingNumber#</TrackingNumber> 
</TrackRequest>
</cfoutput>
</cfsavecontent>


    <cfhttp url="#variables.gateway#/Track" method="post"> 
       <cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
    </cfhttp>
 
<cfscript>
	
	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSSuccess = theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			v.theShipment = theResponse.Shipment;
			// Save the shipping information for the package
			Tracking.Address = StructNew();
			if (isDefined("v.theShipment.ShipTo.Address")) {
			Tracking.Address = v.theShipment.ShipTo.Address;
			}
			if (isDefined("v.theShipment.ShipmentWeight")) {
			Tracking.WeightUnit = v.theShipment.ShipmentWeight.UnitOfMeasurement.Code.XMLText;
			Tracking.Weight = v.theShipment.ShipmentWeight.Weight.XMLText;
			}
			Tracking.Service = v.theShipment.Service.Code.XMLText;
			Tracking.TrackNumber = v.theShipment.ShipmentIdentificationNumber.XMLText;
			if (isDefined("v.theShipment.PickupDate")) {
			Tracking.PickupDate = v.theShipment.PickupDate.XMLText;
			}
			if (isDefined("v.theShipment.ScheduledDeliveryDate")) {
			Tracking.ScheduledDeliveryDate = v.theShipment.ScheduledDeliveryDate.XMLText;
			}
			// Loop for each package in the shipment
			v.NumPacks = ArrayLen(v.theShipment.Package);
			if (v.NumPacks GT 0) {
				Tracking.Packages = ArrayNew(1);
				for (x=1; x LTE v.NumPacks; x=x+1) {
					v.thePackage = v.theShipment.Package[x];
					Tracking.Packages[x] = StructNew();
					if (isDefined("v.thePackage.RescheduledDeliveryDate")) {
					Tracking.Packages[x].RescheduledDeliveryDate = v.thePackage.RescheduledDeliveryDate.XMLText;
					}
					if (isDefined("v.thePackage.Message.Description")) {
					Tracking.Packages[x].Status = v.thePackage.Message.Description.XMLText;
					}
					//create an array to hold the activity information
					Tracking.Packages[x].Activity = XmlSearch(v.thePackage, "//Activity");
			  	}			
			}			
			Tracking.success = 1;
		}
		else
		{
			Tracking.errormessage = theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		Tracking.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
			
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
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

<!--- Decrypt of settings failed --->
<cfelse>
	<cfscript>
		Tracking.errormessage = 'There was an error in the setup for tracking, please contact the system admistrator for more assistance';
	</cfscript>

</cfif>

<cfreturn Tracking>

</cffunction>

<!-------------------------- END UPS TRACKING TOOL ------------------------------------->


<!-------------------- BEGIN UPS ADDRESS VERIFICATION TOOL ----------------------------->

<cffunction name="VerifyAddress" displayname="UPS Address Verification Tool" hint="This function takes a city, state, and zip and returns matching addresses from UPS." returntype="struct" access="public" output="No">

	<cfargument name="City" type="string" required="Yes" displayname="City" hint="The city for the shipping address to verify.">
	<cfargument name="State" type="string" required="Yes" displayname="State" hint="The state for the shipping address to verify.">
	<cfargument name="Zipcode" type="string" required="Yes" displayname="Zip Code" hint="The zip code for the shipping address to verify.">

	<cfargument name="Accesskey" type="string" required="Yes" displayname="Access Key" hint="The access key assigned by UPS.">
	<cfargument name="UserID" type="string" required="Yes" displayname="UserID" hint="The user ID assigned by UPS.">
	<cfargument name="UPSPassword" type="string" required="Yes" displayname="UPSPassword" hint="The password assigned by UPS.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
	//structure to hold all local vars
	var v = StructNew();
	
	var Validated = StructNew();
	var theResponse = StructNew();
	
	//default return values
	Validated.debug = '';
	Validated.success = 0;
	Validated.ValidAddress = 0;
	Validated.errormessage = '';
	
	// Decrypt the UPS settings 
	try {
		v.Accesskey = UPSDecrypt(arguments.Accesskey);
		v.UserID = UPSDecrypt(arguments.UserID);
		v.UPSPassword = UPSDecrypt(arguments.UPSPassword);
		v.DecryptOK = "yes";
		}	
	 catch(Any excpt) {
		v.DecryptOK = "no";
		}
</cfscript>


<cfif v.DecryptOK> 

<!--- Construct XML Packet to Send --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0"?>
<AccessRequest>
     <AccessLicenseNumber>#v.Accesskey#</AccessLicenseNumber>
     <UserId>#v.UserId#</UserId>
     <Password>#v.UPSPassword#</Password>
</AccessRequest>
<?xml version="1.0"?>
<AddressValidationRequest xml:lang="en-US"> 
  <Request> 
  <TransactionReference> 
    <CustomerContext></CustomerContext> 
    <XpciVersion>1.0001</XpciVersion> 
  </TransactionReference> 
  <RequestAction>AV</RequestAction> 
  </Request> 
   <Address>
   <City>#arguments.City#</City>
   <StateProvinceCode>#arguments.State#</StateProvinceCode>
   <PostalCode>#arguments.Zipcode#</PostalCode>
   </Address> 
</AddressValidationRequest>
</cfoutput>
</cfsavecontent>


 <cfhttp url="#variables.gateway#/AV" method="post"> 
    <cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
 </cfhttp>

<cfscript>
	
	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSSuccess = theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			//check if returns an address that is perfect match
			v.ValidAddress = theResponse.AddressValidationResult.Quality.xmlText;
			if (v.ValidAddress IS 1)
				Validated.ValidAddress = 1;
			else {
				v.NumAdds = ArrayLen(theResponse.AddressValidationResult);
				v.Addresses = ArrayNew(1);
				for (x=1; x LTE v.NumAdds; x=x+1) {
				  v.Addresses[x]=StructNew();
	              v.Addresses[x].city=theResponse.AddressValidationResult[x].Address.City.xmlText;
				  v.Addresses[x].state=theResponse.AddressValidationResult[x].Address.StateProvinceCode.xmlText;
				  v.Addresses[x].zip=theResponse.AddressValidationResult[x].PostalCodeHighEnd.xmlText;			
				}
				Validated.Addresses = v.Addresses;	
			}			
			Validated.success = 1;	
		}
		else
		{
			Validated.errormessage = theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		Validated.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
		
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
		</cfoutput>
		<cfdump var="#Validated#">
	</cfsavecontent>
	<cfset Validated.debug = v.debug>
</cfif>


<!--- Decrypt of settings failed --->
<cfelse>
	<cfscript>
		Validated.errormessage = 'There was an error in the setup for address verification, please contact the system admistrator for more assistance';
	</cfscript>

</cfif>


<cfreturn Validated>

</cffunction>

<cffunction name="StreetLevelAddressVerify" displayname="UPS Street Level Address Verification Tool" hint="This function takes a customer address and returns a success or suggested address from UPS." returntype="struct" access="public" output="No">

	<cfargument name="City" type="string" required="Yes" displayname="City" hint="The city for the shipping address to verify.">
	<cfargument name="Address" type="string" required="Yes" displayname="Address" hint="The address for the shipping address to verify.">
	<cfargument name="State" type="string" required="Yes" displayname="State" hint="The state for the shipping address to verify.">
	<cfargument name="Zipcode" type="string" required="Yes" displayname="Zip Code" hint="The zip code for the shipping address to verify.">
	<cfargument name="Country"    type="string" required="No" default="US" hint="The country code for the shipping address to verify.">
	
	<cfargument name="Accesskey" type="string" required="Yes" displayname="Access Key" hint="The access key assigned by UPS.">
	<cfargument name="UserID" type="string" required="Yes" displayname="UserID" hint="The user ID assigned by UPS.">
	<cfargument name="UPSPassword" type="string" required="Yes" displayname="UPSPassword" hint="The password assigned by UPS.">
	<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
	<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
	<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />
	
<cfscript>
	//structure to hold all local vars
	var v = StructNew();
	
	var Validated = StructNew();
	var theResponse = StructNew();
	
	//default return values
	Validated.debug = '';
	Validated.success = 0;
	Validated.ValidAddress = 0;
	Validated.errormessage = '';
	
	// Decrypt the UPS settings 
	try {
		v.Accesskey = UPSDecrypt(arguments.Accesskey);
		v.UserID = UPSDecrypt(arguments.UserID);
		v.UPSPassword = UPSDecrypt(arguments.UPSPassword);
		v.DecryptOK = "yes";
		}	
	 catch(Any excpt) {
		v.DecryptOK = "no";
		}
</cfscript>


<cfif v.DecryptOK> 

<!--- Construct XML Packet to Send --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0"?>
	<AccessRequest xml:lang="en-US">
	<AccessLicenseNumber>#arguments.License#</AccessLicenseNumber>
	<UserId>#arguments.UserId#</UserId>
	<Password>#arguments.Password#</Password>
  </AccessRequest>
  <?xml version="1.0"?>
  <AddressValidationRequest xml:lang="en-US">
<Request>
<TransactionReference>
<CustomerContext>Address Verification</CustomerContext>
<XpciVersion>1.0001</XpciVersion>
</TransactionReference>
<RequestAction>XAV</RequestAction>
<RequestOption>#arguments.Request#</RequestOption>
</Request>
<AddressKeyFormat>
<AddressLine>#arguments.address#</AddressLine> 
<PoliticalDivision2>#arguments.city#</PoliticalDivision2>
<PoliticalDivision1>#arguments.state#</PoliticalDivision1>
<PostcodePrimaryLow>#arguments.zipcode#</PostcodePrimaryLow>
<CountryCode>#arguments.country#</CountryCode>
</AddressKeyFormat>
  </AddressValidationRequest>
</cfoutput>
</cfsavecontent>


 <cfhttp url="#variables.gateway#/AV" method="post"> 
    <cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
 </cfhttp>

<cfscript>
	
	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSSuccess = theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			//check if returns an address that is perfect match
			v.ValidAddress = theResponse.AddressValidationResult.Quality.xmlText;
			if (v.ValidAddress IS 1)
				Validated.ValidAddress = 1;
			else {
				v.NumAdds = ArrayLen(theResponse.AddressValidationResult);
				v.Addresses = ArrayNew(1);
				for (x=1; x LTE v.NumAdds; x=x+1) {
				  v.Addresses[x]=StructNew();
	              v.Addresses[x].city=theResponse.AddressValidationResult[x].Address.City.xmlText;
				  v.Addresses[x].state=theResponse.AddressValidationResult[x].Address.StateProvinceCode.xmlText;
				  v.Addresses[x].zip=theResponse.AddressValidationResult[x].PostalCodeHighEnd.xmlText;			
				}
				Validated.Addresses = v.Addresses;	
			}			
			Validated.success = 1;	
		}
		else
		{
			Validated.errormessage = theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		Validated.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
		
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
		<H4>Response</H4>#htmleditformat(Replace(CFHTTP.FileContent,">", ">#Chr(10)#", "ALL"))#
		</cfoutput>
		<cfdump var="#Validated#">
	</cfsavecontent>
	<cfset Validated.debug = v.debug>
</cfif>


<!--- Decrypt of settings failed --->
<cfelse>
	<cfscript>
		Validated.errormessage = 'There was an error in the setup for address verification, please contact the system admistrator for more assistance';
	</cfscript>

</cfif>


<cfreturn Validated>

</cffunction>

<!-------------------- END UPS ADDRESS VERIFICATION TOOL ----------------------------->


<!-------------------- BEGIN DECRYPT FUNCTION ----------------------------->
<cffunction name="UPSDecrypt" returntype="string" hint="Used to return the decrypted strings for the UPS tools." access="public" output="No">

<cfargument name="stringin" default="" required="Yes">

<cfreturn Decrypt(URLDecode(arguments.stringin), variables.encryptkey)>

</cffunction>
<!-------------------- END DECRYPT FUNCTION ----------------------------->


</cfcomponent> 



