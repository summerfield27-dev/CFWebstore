
<!--- CFWebstore, version 6.50 --->

<!--- Displays the shopping cart summary. Called by shopping.basketstats --->

<cfparam name="attributes.class" default="basketStats">

<cfscript>
	if (isStruct(Session.BasketTotals)) {
		CartItems = Session.BasketTotals.Items;
		CartTotal = Session.BasketTotals.Total;
	}
	else {
		CartItems = 0;
		CartTotal = 0;	
	}
</cfscript>

<cfoutput>
<!-- start shopping/basket/dsp_basketstats.cfm -->
<div id="#attributes.class#"><a href="#XHTMLFormat('#Request.StoreSelf#?fuseaction=shopping.basket#Request.Token2#')#" #doMouseover('Shopping Cart')#>Cart items: #CartItems# &nbsp;Total: #LSCurrencyFormat(CartTotal)#</a></div>
<!-- end shopping/basket/dsp_basketstats.cfm -->
</cfoutput>	
	
	

