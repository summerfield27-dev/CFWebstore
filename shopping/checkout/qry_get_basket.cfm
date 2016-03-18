<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the shopping cart data from the temporary table. Called by do_checkout.cfm --->

<!--- Check for Paypal IPN transactions --->
<!--- <cfif IsDefined("attributes.txn_id") AND IsDefined("attributes.custom") AND ListLen(attributes.custom, "^") GT 1>
	<cfset Session.BasketNum=ListGetAt(attributes.custom, 1, "^")>
	<cfset Session.User_ID=ListGetAt(attributes.custom, 2, "^")>
</cfif> --->

<cfset qry_Get_Basket = Application.objCart.getBasket()>


</cfsilent>