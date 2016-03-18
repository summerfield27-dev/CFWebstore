<!--- CFWebstore, version 6.50 --->

<!--- Outputs the form button to order through PayPal including the entire shopping cart. Includes fields required for IPN. Replace the link to put_paypal.cfm on checkout\dsp_payment_options.cfm with this file. --->

<!--- IMPORTANT NOTES FOR USEAGE
To ensure that the shipping amount is accepted, log into your PayPal account and then go to Profile - Shipping Calculations
Check the box at the bottom of the page that says 'Click here to allow transaction-based shipping values to override the profile shipping settings listed above (if profile settings are enabled).'
 --->
 
 
<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset PPServer = "https://www.paypal.com/cgi-bin/webscr" >
<cfelse>
	<cfset PPServer = "https://www.sandbox.paypal.com/cgi-bin/webscr" >
</cfif>	

<!--- Get the Address Information --->
<cfset strCustAddress = Application.objCheckout.doCustomerAddress(GetCustomer,GetShipTo)>


<!-- start shopping/checkout/paypal/put_paypal_cart.cfm -->

	<tr>
		<cfoutput>
		<td colspan="3">
		Use PayPal for secure online payment using your credit card or checking account! You will receive verification of your order after completing your transaction on the PayPal website.<br/><br/>
		<div align="center">
		<form action="#PPServer#" method="post" >
		<input type="hidden" name="cmd" value="_cart" />
		<input type="hidden" name="upload" value="1" />
		<input type="hidden" name="rm" value="2">
		<input type="hidden" name="bn" value="dogpatchsoft.cfwebstore" />
		<input type="hidden" name="business" value="#get_order_settings.PayPalEmail#" />
		<input type="hidden" name="currency_code" value="#Left(LSCurrencyFormat(10, "international"),3)#" />
		<input type="hidden" id="address_override" name="address_override" value="1" />
		<input type="hidden" id="no_shipping" name="no_shipping" value="1" />
		<input type="hidden" id="address1" name="address1" value="#strCustAddress.Shipping.Address#" />		
		<input type="hidden" id="address2" name="address2" value="#strCustAddress.Shipping.Address2#" />		
		<input type="hidden" id="city" name="city" value="#strCustAddress.Shipping.City#" />	
		<input type="hidden" id="state" name="state" value="#strCustAddress.Shipping.State#" />		
		<input type="hidden" id="zip" name="zip" value="#strCustAddress.Shipping.Zip#" />		
		<input type="hidden" id="country" name="country" value="#strCustAddress.Shipping.Country#" />		
		<input type="hidden" name="shipping_1" value="#(ShipCost+TotalFreight)#" />
		<input type="hidden" name="tax_cart" value="#Tax#" />		
		<input type="hidden" name="custom" value="#Session.BasketNum#" />
		<input type="hidden" name="notify_url" value="#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=ipn&redirect=yes&#UCase(Session.URLToken)#')#" />
		<input type="hidden" name="return" value="#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=ipn&redirect=yes&PayPalCust=Yes&#UCase(Session.URLToken)#')#" />
		<input type="hidden" name="cancel_return" value="#XHTMLFormat('#Request.StoreSelf#?fuseaction=shopping.basket&redirect=yes&#UCase(Session.URLToken)#')#" />
		</cfoutput>
		<!--- Output the basket items --->
		<cfset PromoTotal = 0>
		<cfoutput query="qry_Get_Basket">
		<cfset Amount = qry_Get_Basket.Price + qry_Get_Basket.OptPrice + qry_Get_Basket.AddonMultP>
		<cfset PromoTotal = PromoTotal + qry_Get_Basket.PromoAmount>
		<input type="hidden" name="amount_#CurrentRow#" value="#Amount-(qry_Get_Basket.QuantDisc + qry_Get_Basket.DiscAmount)#" />
		<input type="hidden" name="item_name_#CurrentRow#" value="#HTMLEditFormat(Left(qry_Get_Basket.Name, 127))#" />
		<input type="hidden" name="quantity_#CurrentRow#" value="#qry_Get_Basket.Quantity#" />
		<cfif Len(Trim(qry_Get_Basket.Options))>
		<input type="hidden" name="on0_#CurrentRow#" value="Options" />
		<input type="hidden" name="os0_#CurrentRow#" value="#Left(qry_Get_Basket.Options, 197)##iif(Len(qry_Get_Basket.Options) GT 197, DE('...'), DE(''))#" />
		</cfif>
		<cfif Len(Trim(qry_Get_Basket.Addons))>
		<cfif Len(Trim(qry_Get_Basket.Options))><cfset prefix = "1"><cfelse><cfset prefix = "0"></cfif>
		<!--- Set the output --->
		<cfset ppAddons = Left(Trim(qry_Get_Basket.Addons), Len(Trim(qry_Get_Basket.Addons))-6)>
		<cfset ppAddons = Left( Replace(ppAddons, '<br/>', ' || ', 'ALL'), 197) & iif(Len(ppAddons) GT 197, DE('...'), DE(''))>
		<input type="hidden" name="on#prefix#_#CurrentRow#" value="Addons" />
		<input type="hidden" name="os#prefix#_#CurrentRow#" value="#ppAddons#" />
		</cfif>		
		</cfoutput>
		<cfoutput>
		<cfset totalitems = qry_Get_Basket.Recordcount>
		<!--- Output additional items --->
		<cfif BasketTotals.AddonTotal IS NOT 0>
			<cfset totalitems = totalitems + 1>
			<input type="hidden" name="amount_#totalitems#" value="#BasketTotals.AddonTotal#" />
			<input type="hidden" name="item_name_#totalitems#" value="Additional Items" />
			<input type="hidden" name="quantity_#totalitems#" value="1" />
		</cfif>
		
		<input type="hidden" name="discount_amount_cart" value="#(PromoTotal+BasketTotals.OrderDiscount+Credits)#" />	
		</cfoutput>
		
		<input type="image" src="https://www.paypal.com/en_US/i/btn/x-click-but01.gif" name="submit" alt="Make payments with PayPal - it's fast, free and secure!" />
		</form></div>
		</td></tr>
	<!-- end shopping/checkout/paypal/put_paypal_cart.cfm -->
	