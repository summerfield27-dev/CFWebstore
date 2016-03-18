
<!--- CFWebstore, version 6.50 --->

<!--- This page processes the shipping method selection. Called by shopping.checkout (step=shipping) --->

<!--- Error check that a selection has been made. If not, noship will provide error message  --->
<cfif NOT isDefined("attributes.RateID") OR NOT isDefined("Session.ShippingRates")>
	
	<cfscript>
	attributes.noship="yes";
	
	// no shipping selection was made... if one is not needed, move on! 
	if (totalship is "0") {
		Session.CheckoutVars.NoShipInfo = 0;
		ShipCost = 0;
		ShipType = "No Shipping";
		attributes.step = "payment";
	}
	</cfscript>
	
<cfelse>

	<cfscript>	
	if (Not isNumeric(attributes.RateID)) {
		ShipName = "In-Store Pickup";
		Shipper = '';
		ShipType = ShipName;
		ShipCost = 0;
	}
	else {
	//get rate from the session array
		SelectedRate = Session.ShippingRates[attributes.RateID];
		ShipName = SelectedRate.Name;
		Shipper = SelectedRate.Carrier;
		ShipCost = SelectedRate.Amount;
		if (NOT ListFind("FedEx,Intershipper,Price,Weight,Items,Price2,Weight2",Shipper)) 
			ShipType = Shipper & " " & ShipName;
		else
			ShipType = ShipName;
	}	
	</cfscript>
	
	<cfset attributes.step = "payment">

</cfif>


