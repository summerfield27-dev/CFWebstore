<!--- CFWebstore, version 6.50 --->

<!--- This page is used to estimate a FedEx shipping rate. Calls the FedEx API to determine the selected rate and returns it to the calculator. Called from shopping/basket/act_ship_estimator.cfm  --->

<cfscript>
	thisType = "FedEx";
	
	// Get FedEx Settings
	GetFedEx = Application.objShipping.getFedExSettings();
	
	MerchantInfo = StructNew();
	MerchantInfo.Zip = GetFedEx.Origzip;	
	MerchantInfo.State = GetFedEx.Origstate;		
	MerchantInfo.Country = GetFedEx.Origcountry;	
	
	//Create the structure with customer address information
	AddressInfo = Application.objCheckout.doAddresses(GetCustomer,GetShipTo);	
	
	ShippersList = '';

	if (GetFedEx.UseGround)
		ShippersList = ListAppend(ShippersList, "FDXG");
		
	if (GetFedEx.UseExpress)
		ShippersList = ListAppend(ShippersList, "FDXE");	
		
	//if (GetFedEx.UseSmartPost)
		//ShippersList = ListAppend(ShippersList, "FXSP");	
</cfscript>

<cftry>
	<!--- Create the array of shippers and packages --->
	<cfset ShippingData = Application.objShipping.doShippingData(MerchantInfo, GetFedEx.MaxWeight)>
	
	<cfcatch type="DropShipError">
		<cfset est_shipping = "no">
	</cfcatch>

</cftry>

<!--- Continue if no errors so far --->
<cfif NOT isDefined("est_shipping")>
		
	<!--- Get the FedEx Shipping rate --->
	<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
		returnvariable="Result" method="getAllRates"
		accountno="#GetFedEx.AccountNo#"
		meternum="#GetFedEx.MeterNum#"
		userkey="#GetFedEx.UserKey#"
		userpass="#GetFedEx.Password#"
		carriers="#ShippersList#"
		AddressInfo="#AddressInfo#"
		dropoff="#GetFedEx.Dropoff#"
		packaging="#GetFedEx.Packaging#"
		addinsurance="#GetFedEx.AddInsurance#"
		units="#GetFedEx.UnitsofMeasure#"
		ShipArray="#ShippingData#"
		service="#theMethod#"
		logging="#YesNoFormat(GetFedEx.Logging)#"
		debug="#YesNoFormat(GetFedEx.Debug)#"
		test="#YesNoFormat(Request.DemoMode)#">
		
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


