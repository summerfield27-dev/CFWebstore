<!--- CFWebstore, version 6.50 --->

<!--- This page is used for all rate types to process options when the shipping was not calculated. Called by the various shipping\act_*.cfm pages  --->

<cfparam name="errorMessage" default="">

<cfscript>

	if (NoShipping) {
		NoShipInfo = 1;
		ShipCost = 0;
		
		WriteOutput('<!-- start shopping/checkout/shipping/put_noshipping.cfm -->');
		WriteOutput('<div id="putnoshipping" class="shopping">');
		WriteOutput('<span class="formerror"><br/>');
		if (len(errorMessage))
			WriteOutput(errorMessage& '<br/><br/>');
		WriteOutput(ShipSettings.NoShipMess & '<br/><br/></span>');
		
		if (ShipSettings.AllowNoShip IS 0) 
			ShowForm = "no";
		else 
			WriteOutput('<input type="hidden" name="shiptype" value="#ShipSettings.NoShipType#" />');
			
		WriteOutput('</div><!-- end shopping/checkout/shipping/put_noshipping.cfm -->');
	}
	else
		NoShipInfo = 0;

</cfscript>

<!--- Update the session variable for NoShipInfo --->
<cflock scope="SESSION" timeout="15" type="EXCLUSIVE">
	<cfset Session.CheckoutVars.NoShipInfo = NoShipInfo>
</cflock>

		