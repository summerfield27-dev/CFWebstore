<!--- CFWebstore, version 6.50 --->

<!--- This page is used to estimate a Intershipper shipping rate. Calls the Intershipper API to determine the selected rate and returns it to the calculator. Called from shopping/basket/act_ship_estimator.cfm  --->

<cfscript>
	thisType = "Intershipper";
	
	//Get Intershipper Settings
	GetIntShip = Application.objShipping.getIntShipSettings();
	
	MerchantInfo = StructNew();
	MerchantInfo.Zip = GetIntShip.Merchantzip;	
	MerchantInfo.Country = ListGetAt(Request.AppSettings.HomeCountry, 1, "^");
	
	//Create the structure with customer address information
	AddressInfo = Application.objCheckout.doAddresses(GetCustomer,GetShipTo);	
	
</cfscript>

<cftry>
	<!--- Create the array of shippers and packages --->
	<cfset ShippingData = Application.objShipping.doShippingData(MerchantInfo, GetIntShip.MaxWeight)>
	
	<cfcatch type="DropShipError">
		<cfset est_shipping = "no">
	</cfcatch>

</cftry>

<!--- Continue if no errors so far --->
<cfif NOT isDefined("est_shipping")>

			
	<!--- Run the Intershipper request --->
	<cfinvoke component="#Request.CFCMapping#.shipping.intershipper" 
		returnvariable="Result" method="getAllRates"
		Userid="#GetIntShip.Userid#"
		int_password="#GetIntShip.Password#"
		carriers="#GetIntShip.Carriers#"
	    ServiceClasses="#GetIntShip.Classes#"
		units="#GetIntShip.UnitsofMeasure#"
		AddressInfo="#AddressInfo#"
		ShipArray="#ShippingData#"
		logging="#YesNoFormat(GetIntShip.Logging)#"
		debug="#YesNoFormat(GetIntShip.Debug)#">
		
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


