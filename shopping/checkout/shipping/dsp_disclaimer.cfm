<!--- CFWebstore, version 6.50 --->

<!--- This page is used to output the disclaimer for automated rates. Called by the various put_choose*.cfm pages  --->

<cfparam name="thisType" default="UPS">

<cfif (ShipSettings.ShipBase OR ShipSettings.ShipHand) AND NOT NoShipping>
	<!-- start shopping/checkout/shipping/dsp_disclaimer.cfm -->
	<div id="dspdisclaimer" class="shopping">
	<cfoutput>
	<br/><br/>
	NOTICE: These fees do not necessarily represent #thisType# published rates and may include charges levied by #Request.AppSettings.SiteName#.
	<br/><br/></cfoutput>
	</div>
	<!-- end shopping/checkout/shipping/dsp_disclaimer.cfm -->
</cfif>	
	
	

