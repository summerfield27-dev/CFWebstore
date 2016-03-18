<!--- CFWebstore, version 6.50 --->

<!--- This template is used to output the the shipping table for the store. Called by dsp_basket.cfm --->

<cfquery name="GetShipping" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#Shipping
ORDER BY MinOrder
</cfquery>

<!--- Custom Shipping Settings --->
<cfset GetCustom = Application.objShipping.getCustomSettings()>

<cfif GetShipping.RecordCount AND GetCustom.ShowShipTable>
<!-- start shopping/basket/put_shiptable.cfm -->
<div id="putshiptable" class="shopping">
<cfoutput>
<p>
<table border="0" cellspacing="5" cellpadding="2" class="carttext" align="center">
<tr><td align="right" colspan="2"><b>Current Shipping Rates:</b><br/></td></tr>
<tr>
	<th align="center">Order Total</th>
	<th width="5">&nbsp;</th>
<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Weight" OR ShipSettings.ShipType IS "Items">
	<th>Amount <cfif ShipSettings.ShipType IS "Items">Per Item</cfif></th>
<cfelse>
	<th align="right">Shipping Cost</th>
</cfif>
	</tr>
	</cfoutput>
	
<cfoutput query="GetShipping">
<tr><td align="right">
<cfif ListFind("Price,Price2", ShipSettings.ShipType)>
#LSCurrencyFormat(MinOrder)# - #LSCurrencyFormat(MaxOrder)#
<cfelseif ShipSettings.ShipType IS "Items">
<!--- REPLACED FOR BLUEDRAGON #LSNumberFormat(MinOrder)# - #LSNumberFormat(MaxOrder)# Items --->
#MinOrder# - #MaxOrder# Items
<cfelse>#DecimalFormat(MinOrder)# - #DecimalFormat(MaxOrder)# #Request.AppSettings.WeightUnit#</cfif><br/>

</td>
<td width="25">&nbsp;</td>
	<td align="center">
	<cfif ListFind("Price,Weight", ShipSettings.ShipType) OR (ShipSettings.ShipType IS "Items" AND NOT GetCustom.MultPerItem)>
#LSCurrencyFormat(Amount+ShipSettings.ShipBase)#
<cfelseif ShipSettings.ShipType IS "Items" AND GetCustom.MultPerItem>
<cfif len(ShipSettings.ShipBase) AND ShipSettings.ShipBase IS NOT 0>#LSCurrencyFormat(ShipSettings.ShipBase)# + 
</cfif>#LSCurrencyFormat(Amount)#/item
<cfelse>
<cfif len(ShipSettings.ShipBase) AND ShipSettings.ShipBase IS NOT 0>#LSCurrencyFormat(ShipSettings.ShipBase)# + </cfif>#Evaluate(Amount*100)#%
</cfif>
</td></tr>
</cfoutput>

</table>

<cfif ShipSettings.ShipHand IS NOT 0>
<div align="center"><br/>
<cfoutput><b>A handling charge of #Evaluate(ShipSettings.ShipHand*100)#% will also be added to your order.</b></cfoutput></div>
</cfif>

</div>
<!-- end shopping/basket/put_shiptable.cfm -->
</cfif>

