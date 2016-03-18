<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the results of the shipping calculations and output the results. Called from dsp_ship_form.cfm  --->

<!--- Initialize variable to determine if any shipping available to that address --->
<cfset NoShipping = 1>

<!-- start shopping/checkout/shipping/put_shiprates.cfm -->
<div id="putshiprates" class="shopping">
	
<!--- If cart has items with shipping charges, then shipping calculations needed --->
<cfif TotalShip IS NOT 0>

	<!--- <cftry>  --->
	<!--- Initialize the rate counter and errormessage --->
	<cfset RateCount = 0>
	<cfset errorMessage = "">
	<cfset NoShipping = 1>
	
	<cfloop query="ShipSettings">
		<!--- Determine the shipping method to use --->
		<cfif NOT Compare(ShipSettings.ShipType, "Intershipper")>
			<cfinclude template="act_intershipper.cfm">
		<cfelseif NOT Compare(ShipSettings.ShipType, "USPS")>
			<cfinclude template="act_uspostal.cfm">
		<cfelseif NOT Compare(ShipSettings.ShipType, "UPS")>
			<cfinclude template="act_upstools.cfm">
		<cfelseif NOT Compare(ShipSettings.ShipType, "FedEx")>
			<cfinclude template="act_fedex.cfm">
		<cfelse>
			<cfinclude template="act_custom.cfm"> 
		</cfif> 
	</cfloop>
	
	<!--- Display option for in-store pickup --->
	<cfinclude template="dsp_pickup.cfm">
	
	<!--- Display disclaimer --->
	<cfif ListFind('UPS,FedEx',ShipSettings.ShipType)>
		<cfinclude template="dsp_disclaimer.cfm">
	</cfif>
	
<!--- 	<cfcatch type="Any">
		<cfset NoShipping = 1>
	</cfcatch> 
	
	</cftry>  --->
	
<cfelseif NOT ShipSettings.ShowFreight AND TotalFreight>
	

<cfelse>
	<!--- No Shipping Charges --->
	<cfscript>
		NoShipping = 0;
		NoShipInfo = 0;
		ShipCost = 0;
		if (NOT ShipSettings.ShowFreight AND TotalFreight) {
			WriteOutput(LSCurrencyFormat(TotalFreight) & '<br/><br/>');
		}
		else {
			WriteOutput('No Shipping Charges<br/><br/>');	
			}
	</cfscript>
</cfif>

<cfinclude template="put_noshipping.cfm">

</div>
<!-- end shopping/checkout/shipping/put_shiprates.cfm -->
