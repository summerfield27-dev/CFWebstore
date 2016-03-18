<!--- CFWebstore, version 6.50 --->

<!--- Performs all the functions for adding an item to the shopping cart. Called by shopping.order and from act_quickorder.cfm --->

<cfparam name="attributes.product_id" default="0">

<cfset Application.objCart.doAddCartItem(argumentcollection=attributes)>
