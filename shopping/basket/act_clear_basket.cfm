
<!--- CFWebstore, version 6.50 --->

<!--- Clears the shopping cart information and returns the customer to the store. Called by shopping.clear --->

<cfparam name="attributes.clear" default="No">

<cfif trim(attributes.Clear) is "Yes" >
	
	<cfscript>
		Application.objCheckout.clearTempTables();
		//Reset basket totals
		qryBasket = Application.objCart.getBasket();
		Application.objCart.doBasketTotals(qryBasket);	
	</cfscript>

	<cflocation url="#Session.Page#" addtoken="No">
	
</cfif>



