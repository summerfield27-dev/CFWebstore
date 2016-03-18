<!--- CFWebstore, version 6.50 --->


<!--- This page is used to estimate a USPS shipping rate. Calls the USPS API to determine the selected rate and returns it to the calculator. Called from shopping/basket/act_ship_estimator.cfm  --->

<cfscript>
	thisType = "USPS";
	
	// Get UPS Settings
	GetUSPS = Application.objShipping.getUSPSSettings();
	
	MerchantInfo = StructNew();
	MerchantInfo.Zip = GetUSPS.Merchantzip;
	MerchantInfo.Country = "US^United States";
	
	//Create the structure with customer address information
	AddressInfo = Application.objCheckout.doAddresses(GetCustomer,GetShipTo);	

</cfscript>

<cftry>
	<!--- Create the array of shippers and packages --->
	<cfset ShippingData = Application.objShipping.doShippingData(MerchantInfo, GetUSPS.MaxWeight)>
	
	<cfcatch type="DropShipError">
		<cfset est_shipping = "no">
	</cfcatch>

</cftry>

<!--- Continue if no errors so far --->
<cfif NOT isDefined("est_shipping")>

	
	<!--- Determine whether to run domestic or international rates --->
	<cfif AddressInfo.Country IS "US">
		<cfset ratetype = "Domestic">
	<cfelse>
		<cfset ratetype = "International">
	
		<!--- Get USPS Country Name --->
		<cfquery name="USPScountry" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
			SELECT Name FROM #Request.DB_Prefix#USPSCountries 
			WHERE Abbrev = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AddressInfo.Country#">
		</cfquery>
			<cfset AddressInfo.Country = iif(USPSCountry.RecordCount, "USPScountry.Name", DE("NotFound"))>
	</cfif>
	
	<!--- Run the USPS request --->
	<cfinvoke component="#Request.CFCMapping#.shipping.uspostal" 
		returnvariable="Result" method="getAllRates"
		userid="#GetUSPS.Userid#" 
		AddressInfo="#AddressInfo#"
		ShipArray="#ShippingData#"
		logging="#YesNoFormat(GetUSPS.Logging)#"
		debug="#YesNoFormat(GetUSPS.Debug)#">
	
		<!--- Output debug if returned --->
	<cfif len(Result.Debug)>
		<cfoutput>#putDebug(Result.Debug)#</cfoutput>
	</cfif>		
		
	<cfif Result.Success AND structKeyExists(Result.Rates,"#theMethod#")>
		
		<cfset est_shipamount = Result.Rates[theMethod]>
	
	<cfelse>
	
		<cfset est_shipping = "no">
		
	</cfif><!--- success --->

</cfif>


