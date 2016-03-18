<!--- CFWebstore, version 6.50 --->

<!--- This page is used to output custom shipping rates. Uses the shipping methods table to provide the custom shipping rates options. Called from put_shiprates.cfm  --->

<cfscript>
	// Get Custom Settings
	GetCustom = Application.objShipping.getCustomSettings();
	
	//Create the structure with customer address information
	AddressInfo = Application.objCheckout.doAddresses(GetCustomer,GetShipTo);	

	qryMethods = allMethods[ShipSettings.ShipType].qryMethods;
</cfscript>

	
<!--- Get Custom Shipping Rates --->
<cfinvoke component="#Request.CFCMapping#.shipping.custom" 
	returnvariable="Result" method="doCustomRates"
	TotalShip="#Session.CheckoutVars.TotalShip#"
	ShipType="#ShipSettings.ShipType#"
	MultPerItem="#GetCustom.MultPerItem#"
	CumulativeAmounts="#GetCustom.CumulativeAmounts#"
	MultMethods="#GetCustom.MultMethods#"
	ShipLocation="#ShipLocation#"
	AddressInfo="#AddressInfo#"
	Methods="#qryMethods#"
	debug="#YesNoFormat(GetCustom.Debug)#">	

<cfif Result.Success AND structKeyExists(Result.Rates,"#theMethod#")>
	
	<cfset est_shipamount = Result.Rates[theMethod]>	

<cfelse>
	<cfset est_shipping = "no">
	
</cfif><!--- success --->

