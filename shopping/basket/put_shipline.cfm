<!--- CFWebstore, version 6.50 --->

<!--- This template is called to output the line with the shipping cost. Called by dsp_basket.cfm --->

<!--- If store is set to combine shipping and freight, add freight amount to shipping --->
<cfif NOT ShipSettings.ShowFreight AND TotalFreight IS NOT 0>
	<cfset ShipCost = ShipCost + TotalFreight>
	<cfset TotalFreight = 0>
</cfif>

<!-- start shopping/basket/put_shipline.cfm -->

<cfif ShipCost>
<cfoutput>
<tr>
	<td colspan="3" align="right"><strong><cfif ListFind('UPS,FedEx,USPS',ShipSettings.ShipType)>#ShipSettings.ShipType# </cfif>Shipping:</strong></td>
	<td align="right">#LSCurrencyFormat(ShipCost)#</td>
</tr>
</cfoutput>
</cfif>

<cfif TotalFreight>
<cfoutput>
<tr>
	<td colspan="3" align="right"><strong>Freight Costs:</strong></td>
	<td align="right">#LSCurrencyFormat(TotalFreight)#</td>
</tr>
</cfoutput>
</cfif>

<!-- end shopping/basket/put_shipline.cfm -->
