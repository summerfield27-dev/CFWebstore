<!--- CFWebstore, version 6.50 --->

<!--- This template is used to output the shopping cart during checkout. Called by do_checkout.cfm --->

<cfset variables.checkout = 1>
<cfset BasketTotals = Application.objCart.doBasketTotals(qry_Get_Basket)>
	
<!--- Calculate Taxes ------->
<cfinclude template="act_calc_tax.cfm">
<!--- Check for gift certificate --->
<cfinclude template="act_calc_giftcert.cfm">
	
<cfscript>
	Total = BasketTotals.SubTotal + Tax + ShipCost + TotalFreight;
	
	if (Credits GT Total)
		Credits = Total;
		
	Total = Total - Credits;

</cfscript>

	
<cfinclude template="do_basket.cfm">

