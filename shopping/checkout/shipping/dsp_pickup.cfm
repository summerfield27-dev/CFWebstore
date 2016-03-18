<!--- CFWebstore, version 6.50 --->

<!--- This page is used for all rate types to output the selection choice for instore pickup. Called by the various put_choose*.cfm pages  --->

<cfparam name="NoShipping" default="0">

<!--- Add the option for instore pickup if turned on --->
<cfif ShipSettings.InStorePickup AND NOT NoShipping>	
	<!-- start shopping/checkout/shipping/dsp_pickup.cfm -->
	<div id="dsppickup" class="shopping">
	<cfoutput>
	<br/>
	<input type="radio" name="RateID" value="NA" />In-Store Pickup - No Charge
	</cfoutput>
	</div>
	<!-- end shopping/checkout/shipping/dsp_pickup.cfm -->
</cfif> 	
	
	

