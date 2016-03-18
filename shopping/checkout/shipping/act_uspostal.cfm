<!--- CFWebstore, version 6.50 --->

<!--- This page is used to output USPS shipping rates. Calls the USPS API to determine rates available and outputs ones selected for the store. Called from put_shiprates.cfm  --->

<cfscript>
	thisType = "USPS";
	
	//Get USPS Shipping Methods
	qryUSPSMethods = Application.objShipping.getUSPSMethods();
	
	// Get USPS Settings
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
		<cfset errormessage = cfcatch.message>	
	</cfcatch>

</cftry>

<!--- Continue if no errors so far --->
<cfif NOT len(errormessage)>
	
	<!--- Determine whether to run domestic or international rates --->
	<cfif AddressInfo.Country IS "US">
		<cfset ratetype = "Domestic">
	<cfelse>
		<cfset ratetype = "International">
	
		<!--- Get USPS Country Name --->
		<cfquery name="USPScountry" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows=1>
			SELECT Name FROM #Request.DB_Prefix#USPSCountries 
			WHERE Abbrev = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#AddressInfo.Country#">
		</CFQUERY>
		
		<cfset AddressInfo.Country = iif(USPSCountry.RecordCount, "USPScountry.Name", DE("NotFound"))>
	</cfif>
	
	<!--- get subset of rates as needed --->
	<cfquery name="StoreRates" dbtype="query">
		SELECT * FROM qryUSPSMethods
		WHERE Type = '#ratetype#'
	</cfquery>
	
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
			
	<cfif Result.Success>
	
		<!--- Get the USPS specific shipping settings --->
		<cfquery name="TypeSettings" dbtype="query">
			SELECT * FROM ShipSettings
			WHERE ShipType = '#thisType#'
		</cfquery>
		
		<cfscript>
		//Set variables for rate selection output
			RateStuff = StructNew();
			RateStuff.RateStruct = Result.Rates;
			RateStuff.Methods = qryUSPSMethods;
			RateStuff.ShipType = thisType;
			RateStuff.Settings = TypeSettings;
			RateStuff.RateCount = RateCount;
			
			//set amount of freight to add
			if(NOT ShipSettings.ShowFreight) 
				RateStuff.AddFreight = TotalFreight;
			else 
				RateStuff.AddFreight = 0;
			
			//Output the selected rates to the shipping page
			RateOutput = Application.objShipping.doRateOutput(argumentcollection=RateStuff);
			
			//If rates output, turn off the No Shipping Flag
			if (NOT RateOutput.NoShipping)
				NoShipping = RateOutput.NoShipping;
			
			//Update the rate counter
			RateCount = RateOutput.RateCount;	
		
		</cfscript>
	
	
	<cfelse>
		<cfset errorMessage = Result.errormessage>
		
	</cfif><!--- success --->
	
</cfif>


