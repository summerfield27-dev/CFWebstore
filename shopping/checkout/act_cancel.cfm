<!--- CFWebstore, version 6.50 --->

<!--- Clears all the temporary session vars used during checkout and returns users to shopping cart. Called by shopping.checkout (various steps) --->

<!--- Delete checkout session variable check --->
<cflock scope="SESSION" timeout="20">
	<cfif isDefined("Session.CheckingOut")>
		<cfset StructDelete(Session, "CheckingOut")>
	</cfif>
	<cfif isDefined("Session.ShippingRates")>
		<cfset StructDelete(Session, "ShippingRates")>
	</cfif>
	<cfif isDefined("Session.CheckoutVars")>
		<cfset StructDelete(Session, "CheckoutVars")>
	</cfif>
</cflock>


<cflocation url="#Request.StoreSelf#?fuseaction=shopping.basket#Request.AddToken#" addtoken="no">
