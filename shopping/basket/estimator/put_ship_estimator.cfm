
<!--- CFWebstore, version 6.50 --->

<!--- Displays the shipping estimator on the shopping cart page. Called from dsp_basket.cfm --->
<!--- Preceeded by a call to act_ship_estimator.cfm --->

<!--- countrows needed --->
<cfset rowspan = 2>
<cfset showzip = "yes">
<cfset showstate = "no">
<cfset showmethods = "yes">

<cfif get_User_Settings.UseCountryList>
	<cfset showcountry = "yes">
	<cfset rowspan = rowspan + 1>
<cfelse>	
	<cfset showcountry = "no">
</cfif>

<cfif ListFindNoCase(ShippersList,"FedEx")>
	<cfset showstate = "yes">
	<cfset rowspan = rowspan + 1>
	
</cfif>

<cfif TotalMethods IS 0>
	<cfset showmethods = "no">
</cfif>

<!-- start shopping/basket/estimator/put_ship_estimator.cfm -->
<div id="putshipestimator" class="shopping">

<!--- Shipping Estimator --->
<cfif showzip OR showstate OR showmethods>
<tr>
	<td colspan="2" align="left"><b>Shipping Estimator</b></td>
	<td colspan="3">&nbsp;</td>
</tr>
</cfif>

<cfoutput>

	<!--- Output Estimator Fields --->
	<tr>
		<td colspan="2" rowspan="#rowspan#" align="left">
		<table width="100%" cellspacing="0" border="0" cellpadding="3" class="carttext" style="color: ###Request.GetColors.OutputTText#;">	
		<cfif showzip>
		<tr>
		<td nowrap="nowrap" align="left">Zip Code: </td>
		<td align="left">
		<input type="text" name="est_zipcode" size="10" class="formfield" value="#HTMLEditFormat(attributes.est_zipcode)#"/></td>
		</tr>
		<cfelse>
		<input type="hidden" name="est_zipcode" value="99999"/>
		</cfif>
		<cfif showstate>
		<cfinclude template="../../../queries/qry_getstates.cfm">
		<tr>
			<td nowrap="nowrap" align="left">State:</td>
			<td align="left"><select name="est_shipstate" size="1" class="formfield">
				<option value="Unlisted">Unlisted/None</option>
	   			<option value="Unlisted">___________________</option>
			<cfloop query="GetStates">
	   			<option value="#Abb#" #doSelected(attributes.est_shipstate,Abb)#>#Name# (#Abb#)</option>
			</cfloop></select>
			</TD></TR>
		</cfif>

		<cfif showcountry>
		<cfinclude template="../../../queries/qry_getcountries.cfm">
		<tr>
    	<td nowrap="nowrap" align="left">Country: </td>
    	<td align="left"><select name="est_shipcountry" size="1" class="formfield">
			<option value="#Request.AppSettings.HomeCountry#">#ListGetAt(Request.AppSettings.HomeCountry, 2, "^")#</option>
 			<option value="#Request.AppSettings.HomeCountry#">___________________</option>
		<cfloop query="GetCountries">
   			<option value="#Abbrev#^#Name#" #doSelected(attributes.est_shipcountry,"#Abbrev#^#Name#")#>#Left(Name,28)#</option>
		</cfloop>
		</select></td></tr>		
		</cfif>
		<cfif showmethods>
		<tr>
			<td nowrap="nowrap" align="left">Method:</td>
			<td align="left"><select name="est_shipmethod" size="1" class="formfield">
			<cfloop item="currtype" collection="#allMethods#">
				<cfset theMethods = allMethods[currtype].qryMethods>
				<cfset showcarrier = iif(ListFind("UPS,USPS",currtype),1,0)>
				<cfloop query="theMethods">
				<option value="#currtype#^#theMethods.ID#^#theMethods.Code#" #doSelected("#thetype#^#methodID#","#currtype#^#theMethods.ID#")#>
				<cfif showcarrier>#currtype#</cfif> #REReplace(theMethods.Name,"<[^>]*>","","ALL")#</option>
				</cfloop>
			</cfloop>
			</select></td>
		</tr>
		<cfelse>
		<tr><td>&nbsp;</td></tr>
		</cfif>
		</table></td>
	
		<td colspan="2" align="right" valign="top"><b>Subtotal:</b></td>
		<td align="right" valign="top">#LSCurrencyFormat(BasketTotals.SubTotal)#</td>
	</tr>
	<tr>
		<td colspan="2" align="right" valign="top"><b>Est. Shipping:</b></td>
			<td valign="top" align="right" nowrap="nowrap">
			<cfif isDefined("est_shipamount") AND est_shipamount IS 0>Free
			<cfelseif isDefined("est_shipamount")>#LSCurrencyFormat(est_shipamount)#
				<!--- If VAT tax, calculate shipping amount and add it --->
			<cfelseif isDefined("est_shipping")>N/A
			<cfelse>Pending</cfif>
			</td>
		</tr>
	<cfif isDefined("est_shipping") AND TotalFreight IS NOT 0>
		<tr><cfif rowspan GT 2>
				<cfset rowspan = rowspan -1>
				<td colspan="2" align="right" valign="top">
			<cfelse>
				<td colspan="4" align="right" valign="top">
			</cfif>
			<b>Est. Freight:</b></td>
			<td valign="top" align="right" nowrap="nowrap">#LSCurrencyFormat(TotalFreight)#</td>
		</tr>
	</cfif>
	<!--- If there is estimated tax, display it --->
	<cfif BasketTotals.EstTaxTotal IS NOT 0>
		<!--- If estimated shipping found and tax on shipping as well, add that to the estimated tax --->
		<cfif isDefined("est_shipamount") AND isNumeric(est_shipamount) AND qryProdTaxes.TaxShipping>
			<cfset ShippingTax = Round((est_shipamount+TotalFreight)*qryProdTaxes.TaxRate*100)/100>
			<cfset EstTaxTotal = EstTaxTotal + ShippingTax>
		</cfif>			
		<tr><cfif rowspan GT 2>
				<cfset rowspan = rowspan -1>
				<td colspan="2" align="right" valign="top">
			<cfelse>
				<td colspan="4" align="right" valign="top">
			</cfif>
			<b>Estimated #qryProdTaxes.DisplayName# Tax:</b></td>
				<td valign="top" align="right" nowrap="nowrap">#LSCurrencyFormat(EstTaxTotal)#</td>
			</tr>	
	</cfif>	
	
	<cfloop from="1" to="#rowspan-2#" index="num">
	<tr><td colspan="2">&nbsp;</td></tr>
	</cfloop>		
	
	<tr><td colspan="5" align="left">To use the shipping calculator, enter your address information, select the type of shipping and click Recalculate. If N/A is displayed, the shipping selected is not available to your address.<br/><br/></td></tr>
	
	<!--- For FedEx, show state list --->		
	<cfinclude template="../../../queries/qry_getcountries.cfm">

		
</cfoutput>

</div>
<!-- end shopping/basket/estimator/put_ship_estimator.cfm -->
