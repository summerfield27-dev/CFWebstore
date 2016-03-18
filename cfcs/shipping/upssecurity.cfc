<!--- CFWebstore, version 6.50 --->

<cfcomponent displayname="UPS Licensing & Registration Tool" hint="This component is used for handling the UPS Security elements for licensing and registration." output="No">
<!--- This component developed by Mary Jo Sminkey maryjo@cfwebstore.com --->
<!--- This tag was developed using the XML Tools provided by the UPS --->
<!--- Originally developed for use with CFWebstore e-commerce (www.cfwebstore.com) --->

<!--- Requires CFMX 6 or higher --->

<cfscript>
	variables.encryptkey = "cfweb256";

	// Set UPI API gateway server address
	variables.gateway = "https://onlinetools.ups.com/ups.app/xml";
	//test server
	variables.testgateway = "https://wwwcie.ups.com/ups.app/xml";
</cfscript>

<!------------------------- COMPONENT INITIALIZATION ----------------------------------->
<cffunction name="init" access="public" output="no" returntype="upssecurity">
    <cfreturn this>
  </cffunction>

<!------------------------- BEGIN UPS LICENSE FUNCTION ----------------------------------->
<cffunction name="getUPSLicense" returntype="struct" displayname="Get the UPS License" hint="This function retrieves the UPS license, used for registering a new user." access="public" output="No">

<!--- Optional Attributes
	country - if not US
	language - if not English 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if license returned, otherwise 0 --->
<!--- If Success, returns license text --->
<!--- If Error, returns ErrorMessage --->

<!--- Initialize Parameters --->

<cfargument name="country" type="string" required="No" default="US">
<cfargument name="language" type="string" required="No" default="EN">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<!--- structure to hold all local vars --->
<cfset var v = StructNew()>

<!--- Build the XML string --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0" encoding = "ISO-8859-1"?>
<AccessLicenseAgreementRequest>
	<Request>
		<RequestAction>AccessLicense</RequestAction>
		<RequestOption>AllTools</RequestOption>
	</Request>
	<DeveloperLicenseNumber>4BCD38E4292A8404</DeveloperLicenseNumber>
	<AccessLicenseProfile>
		<CountryCode>#arguments.country#</CountryCode>
		<LanguageCode>#arguments.language#</LanguageCode>
	</AccessLicenseProfile>
</AccessLicenseAgreementRequest>
</cfoutput>
</cfsavecontent>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="post" url="#gatewayURL#/License" RESOLVEURL="false" TIMEOUT="#arguments.timeout#" charset="iso-8859-1">
	<cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
</CFHTTP>


<cfscript>

	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		v.theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSLicense = StructNew();
		
		v.UPSSuccess = v.theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			v.UPSLicense.success = 1;
			v.UPSLicense.text = v.theResponse.AccessLicenseText.XmlText;
			v.UPSLicense.errormessage = '';
		}
		else
		{
			v.UPSLicense.success = 0;
			v.UPSLicense.text = '';
			v.UPSLicense.errormessage = v.theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		v.UPSLicense.success = 0;
		v.UPSLicense.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
	
</cfscript>


<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(ToString(v.temprequest))#<br />
		<H4>Response</H4>#htmleditformat(CFHTTP.FileContent)# 
		</cfoutput>
	</cfsavecontent>
	<cfset v.UPSLicense.debug = v.debug>
<cfelse>
	<cfset v.UPSLicense.debug = "">
</cfif>

<cfreturn v.UPSLicense>

</cffunction>
<!------------------------- END UPS LICENSE FUNCTION ----------------------------------->



<!------------------------- BEGIN UPS ACCESS KEY FUNCTION ----------------------------------->
<cffunction name="getAccessKey" returntype="struct" displayname="Register the user for a UPS Access Key" hint="This function sends the registration information to UPS and retrieves an accesskey." access="public" output="No">
<!--- Optional Attributes
	title - contact title
	address2 - Line 2 of address
	country - if not US
	accountno - UPS account number
	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if registration accepted, otherwise 0 --->
<!--- If Success, returns username --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="ContactName" required="Yes" type="string">
<cfargument name="Title" required="Yes" type="string">
<cfargument name="Company" required="Yes" type="string">
<cfargument name="Address1" required="Yes" type="string">
<cfargument name="Address2" required="No" type="string" default="">
<cfargument name="City" required="Yes" type="string">
<cfargument name="State" required="Yes" type="string">
<cfargument name="Zip" required="Yes" type="string">
<cfargument name="Country" required="No" type="string" default="US">
<cfargument name="Phone" required="Yes" type="string">
<cfargument name="Website" required="Yes" type="string">
<cfargument name="Email" required="Yes" type="string">
<cfargument name="AccountNo" required="No" type="string" default="">
<cfargument name="contactme" type="boolean" required="No" default="0">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<!--- structure to hold all local vars --->
<cfset var v = StructNew()>

<!--- Remove dashes and parens from Phone --->
<cfset v.PhoneNum = reReplace(arguments.Phone,"[^[:digit:]]","","all")>

<cflock scope="SESSION" timeout="10">
	<cfparam name="Session.License" default="">
	<cfset v.UPSLicense = Session.License>
</cflock>


<!--- Build the XML string --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0" encoding = "ISO-8859-1"?>
<AccessLicenseRequest xml:lang="en-US">
	<Request>
		<RequestAction>AccessLicense</RequestAction>
		<RequestOption>AllTools</RequestOption>
	</Request>
	<CompanyName>#arguments.Company#</CompanyName>
	<Address>
		<AddressLine1>#arguments.Address1#</AddressLine1>
		<cfif len(arguments.Address2)><AddressLine2>#arguments.Address2#</AddressLine2></cfif>
		<City>#arguments.City#</City>
		<StateProvinceCode>#arguments.State#</StateProvinceCode>
		<PostalCode>#arguments.Zip#</PostalCode>
		<CountryCode>#arguments.Country#</CountryCode>
	</Address>
	<PrimaryContact>
		<Name>#arguments.ContactName#</Name>
		<Title>#arguments.Title#</Title>
		<EMailAddress>#arguments.Email#</EMailAddress>
		<PhoneNumber>#v.PhoneNum#</PhoneNumber>
	</PrimaryContact>
	<CompanyURL>#arguments.Website#</CompanyURL>
	<cfif len(arguments.AccountNo)><ShipperNumber>#arguments.AccountNo#</ShipperNumber></cfif>
	<DeveloperLicenseNumber>4BCD38E4292A8404</DeveloperLicenseNumber>
	<AccessLicenseProfile>
		<CountryCode>US</CountryCode>
		<LanguageCode>EN</LanguageCode>
		<AccessLicenseText>#XMLFormat(v.UPSLicense)#</AccessLicenseText>
	</AccessLicenseProfile>
	<OnLineTool>
		<ToolID></ToolID>
		<ToolVersion></ToolVersion>
	</OnLineTool>
	<ClientSoftwareProfile>
		<SoftwareInstaller>#arguments.ContactMe#</SoftwareInstaller>
		<SoftwareProductName>CFWebstore</SoftwareProductName>
		<SoftwareProvider>Dogpatch Software</SoftwareProvider>
		<SoftwareVersionNumber>6.0</SoftwareVersionNumber>
	</ClientSoftwareProfile>
</AccessLicenseRequest>
</cfoutput>
</cfsavecontent>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="post" url="#gatewayURL#/License" RESOLVEURL="false" TIMEOUT="#arguments.timeout#" charset="iso-8859-1">
	<cfhttpparam type="HEADER" name="Content-Type" value="text/xml; charset=iso-8859-1">
	<cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
</CFHTTP>


<cfscript>

	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		v.theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSRegister = StructNew();
		
		v.UPSSuccess = v.theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			v.UPSRegister.success = 1;
			v.AccessKey = v.theResponse.AccessLicenseNumber.XmlText;
			v.UPSRegister.AccessKey = UPSEncrypt(v.AccessKey);
			v.UPSRegister.errormessage = '';
		}
		else
		{
			v.UPSRegister.success = 0;
			v.UPSRegister.AccessKey = '';
			v.UPSRegister.errormessage = v.theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		v.UPSRegister.success = 0;
		v.UPSRegister.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
	
</cfscript>

<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
		<H4>Response</H4>#htmleditformat(CFHTTP.FileContent)#
		</cfoutput>
	</cfsavecontent>
	<cfset v.UPSRegister.debug = v.debug>
<cfelse>
	<cfset v.UPSRegister.debug = "">
</cfif>

<cfreturn v.UPSRegister>

</cffunction>

<!------------------------- END UPS ACCESS KEY FUNCTION ----------------------------------->


<!------------------------- BEGIN UPS REGISTRATION FUNCTION ----------------------------------->
<cffunction name="doUPSRegister" returntype="struct" displayname="Process the UPS Registration" hint="This function processes the UPS registration information." output="No" access="public">
<!--- Optional Attributes
	title - contact title
	address2 - Line 2 of address
	country - if not US
	accountno - UPS account number
	contactme - request to be contacted by UPS
	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if registration accepted, otherwise 0 --->
<!--- If Success, returns username --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="ContactName" required="Yes" type="string">
<cfargument name="Title" required="No" type="string" default="">
<cfargument name="Company" required="Yes" type="string">
<cfargument name="Address1" required="Yes" type="string">
<cfargument name="Address2" required="No" type="string" default="">
<cfargument name="City" required="Yes" type="string">
<cfargument name="State" required="Yes" type="string">
<cfargument name="Zip" required="Yes" type="string">
<cfargument name="Country" required="No" type="string" default="US">
<cfargument name="Phone" required="Yes" type="string">
<cfargument name="Email" required="Yes" type="string">
<cfargument name="AccountNo" required="No" type="string" default="">
<cfargument name="contactme" type="boolean" required="No" default="0">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="yes" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<!--- structure to hold all local vars --->
<cfset var v = StructNew()>

<!--- Generate a userid and password --->
<cfinvoke component="#Request.CFCMapping#.global" method="randomPassword" 
	returnvariable="v.Password" Length="8">

<cfscript>

	if (v.Password.Success) {
	arguments.password = v.Password.new_password;
	v.firstinit = LCase(Left(arguments.ContactName, 1));
	v.lastname = LCase(ListLast(arguments.ContactName, " "));
	
	arguments.username = v.firstinit & v.lastname & RandRange(111,999);
	}

else {
	v.UserID = "None";
	v.Register = StructNew();
	v.Register.Success = 0;
	v.Register.ErrorMessage = v.Password.ErrorMessage;
	
}

</cfscript>
	
<cfparam name="v.UserID" default="">


<!--- Loop until a valid username is received back --->
<cfloop condition="NOT len(v.UserID)">

	<cfinvoke component="upssecurity" 
	method="sendUPSRegister" 
	returnvariable="v.Register" 
	argumentcollection="#Arguments#">
	
	<cfscript>
	// Success and username accepted 	
	if (v.Register.Success AND v.Register.Username IS arguments.username) {
		v.UserID = v.Register.Username;
		v.Register.Username = UPSEncrypt(v.Register.Username);
		v.Register.password = UPSEncrypt(v.Register.password);
		v.Register.AccountNo = arguments.AccountNo;
		}
	//Success, but new username suggested 
	else if (v.Register.Success) 
		arguments.username = v.Register.Username;
	
	// Error received 
	else
		v.UserID = "None";
	</cfscript>

</cfloop>

<cfreturn v.Register>

</cffunction>

<!------------------------- END UPS REGISTRATION FUNCTION ----------------------------------->


<!------------------------- BEGIN UPS REGISTRATION XML FUNCTION ----------------------------->
<cffunction name="sendUPSRegister" returntype="struct" access="package" displayname="Run the XML UPS Registration Tool" hint="This function sends the XML request to UPS and returns either success or a suggested username if the requested one was not available." output="No">
<!--- Optional Attributes
	title - contact title
	address2 - Line 2 of address
	country - if not US
	accountno - UPS account number
	 
	Debug (set to Yes or True to see output of request sent and full response received)
 --->

<!--- Returned Values --->
<!--- Success = 1 if registration accepted, otherwise 0 --->
<!--- If username accepted, returns blank. Otherwise returns suggested username --->
<!--- If Error, returns ErrorMessage --->

<cfargument name="Username" required="Yes" type="string">
<cfargument name="Password" required="Yes" type="string">
<cfargument name="ContactName" required="Yes" type="string">
<cfargument name="Title" required="No" type="string" default="">
<cfargument name="Company" required="Yes" type="string">
<cfargument name="Address1" required="Yes" type="string">
<cfargument name="Address2" required="No" type="string" default="">
<cfargument name="City" required="Yes" type="string">
<cfargument name="State" required="Yes" type="string">
<cfargument name="Zip" required="Yes" type="string">
<cfargument name="Country" required="No" type="string" default="US">
<cfargument name="Phone" required="Yes" type="string">
<cfargument name="Email" required="Yes" type="string">
<cfargument name="AccountNo" required="No" type="string" default="">

<cfargument name="timeout" type="numeric" required="No" default="10" displayname="Tag Timeout" hint="Amount of time to allow before timing out the http request. Default is 10 seconds.">
<cfargument name="debug" type="boolean" default="no" displayname="Output Debug" hint="Toggles whether to display debug information or not.">
<cfargument name="test" type="boolean" default="No" hint="Sets whether to use the test server" />

<!--- structure to hold all local vars --->
<cfset var v = StructNew()>

<cftry> 

<!--- Build the XML string --->
<cfsavecontent variable="v.temprequest">
<cfoutput>
<?xml version="1.0" encoding = "ISO-8859-1"?>
<RegistrationRequest>
	<Request>
		<RequestAction>Register</RequestAction>
		<RequestOption>suggest</RequestOption>
	</Request>
	<UserId>#arguments.Username#</UserId>
	<Password>#arguments.password#</Password>
	<RegistrationInformation>
		<UserName>#XMLFormat(arguments.ContactName)#</UserName>
		<CompanyName>#XMLFormat(arguments.Company)#</CompanyName>
		<cfif len(arguments.Title)><Title>#XMLFormat(arguments.Title)#</Title></cfif>
		<cfif len(arguments.AccountNo)>
			<ShipperNumber>#arguments.AccountNo#</ShipperNumber>
			<PickupPostalCode>#arguments.Zip#</PickupPostalCode>
			<PickupCountryCode>#arguments.Country#</PickupCountryCode>
		</cfif>
		<Address>
			<AddressLine1>#XMLFormat(arguments.Address1)#</AddressLine1>
			<cfif len(arguments.Address2)><AddressLine2>#XMLFormat(arguments.Address2)#</AddressLine2></cfif>
			<City>#XMLFormat(arguments.City)#</City>
			<StateProvinceCode>#arguments.State#</StateProvinceCode>
			<PostalCode>#arguments.Zip#</PostalCode>
			<CountryCode>#arguments.Country#</CountryCode>
		</Address>
		<PhoneNumber>#arguments.Phone#</PhoneNumber>
		<EMailAddress>#XMLFormat(arguments.Email)#</EMailAddress>
	</RegistrationInformation>
</RegistrationRequest>
</cfoutput>
</cfsavecontent>

<cfif arguments.test>
	<cfset gatewayURL = variables.testgateway>
<cfelse>
	<cfset gatewayURL = variables.gateway>
</cfif>

<cfhttp method="post" url="#gatewayURL#/Register" RESOLVEURL="false" TIMEOUT="#arguments.timeout#">
	<cfhttpparam type="XML" name="XML" value="#v.temprequest#"> 
</CFHTTP>

<cfscript>

	try {
		v.UPSResponse = XmlParse(CFHTTP.FileContent);
		v.theResponse = v.UPSResponse.XmlRoot;
		
		v.UPSRegister = StructNew();
		
		v.UPSSuccess = v.theResponse.Response.ResponseStatusDescription.XMLText;
		
		if (v.UPSSuccess IS "Success") 
		{
			v.UPSRegister.success = 1;
			v.UPSRegister.errormessage = '';
			v.UPSRegister.password = arguments.password;
			if (StructKeyExists(v.theResponse, "UserId"))
				v.UPSRegister.Username = v.theResponse.UserId.XMLText;
			else
				v.UPSRegister.Username = arguments.Username;		
		}
		else
		{
			v.UPSRegister.success = 0;
			v.UPSRegister.UserName = '';
			v.UPSRegister.Password = '';
			v.UPSRegister.errormessage = v.theResponse.Response.Error.ErrorDescription.XmlText;
		}
	}
		
	catch(Any excpt) {
		v.UPSRegister.success = 0;
		v.UPSRegister.errormessage = 'Invalid response received from UPS. #CFHTTP.FileContent#';		
	}
	
</cfscript>

<cfcatch>
	
	<cfscript>
		v.UPSRegister = StructNew();
		v.UPSRegister.success = 0;
		v.UPSRegister.UserName = '';
		v.UPSRegister.Password = '';
		v.UPSRegister.errormessage = 'There was an error in the UPS registration request';
	</cfscript>

</cfcatch>
</cftry> 


<!--- Debugging Output --->
<cfif arguments.debug>
	<cfsavecontent variable="v.debug">
		<cfoutput>
		<H4>Request</H4>#htmleditformat(v.temprequest)#<br />
		<H4>Response</H4>#htmleditformat(CFHTTP.FileContent)#
		</cfoutput>
	</cfsavecontent>
	<cfset v.UPSRegister.debug = v.debug>
<cfelse>
	<cfset v.UPSRegister.debug = "">
</cfif>


<cfreturn v.UPSRegister>

</cffunction>

<cffunction name="UPSInfo" returntype="Struct" hint="Used to return encrypted strings for the UPS account information." access="public" output="No">

<cfargument name="accesskey" default="" required="Yes">
<cfargument name="username" default="" required="Yes">
<cfargument name="password" default="" required="Yes">

<cfscript>

	var UPSInfo = StructNew();
	
	UPSInfo.AccessKey = UPSEncrypt(arguments.accesskey);
	UPSInfo.Username = UPSEncrypt(arguments.username);
	UPSInfo.Password = UPSEncrypt(arguments.password);
	
</cfscript>

<cfreturn UPSInfo>

</cffunction>


<cffunction name="UPSEncrypt" returntype="string" hint="Used to return the encrypted strings for all the UPS functions." access="public" output="No">

<cfargument name="stringin" default="" required="Yes">

<cfreturn URLEncodedFormat(Encrypt(arguments.stringin, variables.encryptkey))>

</cffunction>

<!------------------------- END UPS REGISTRATION XML FUNCTION ------------------------------>

</cfcomponent> 





