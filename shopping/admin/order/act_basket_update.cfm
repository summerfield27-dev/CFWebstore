<!--- CFWebstore, version 6.50 --->

<!--- This template updates the administrative basket edits. Called by shopping.admin&order=display ---->

<!--- CSRF Check --->
<cfset keyname = "orderBasketUpdate">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Calculate the basket subtotal ---->
<cfset SubTotal = 0>

<cfloop query="GetOrder">
	<cfset SubTotal = SubTotal + GetOrder.PromoAmount + ((GetOrder.Price + GetOrder.OptPrice + AddonMultP - GetOrder.DiscAmount) * GetOrder.Quantity)>
</cfloop>

<cfset subtotal = subTotal+GetOrder.AddonTotal+GetOrder.Tax-GetOrder.OrderDisc-GetOrder.Credits>

<cfset attributes.Freight = val(attributes.Freight)>
<cfset attributes.ShippingTotal = val(attributes.ShippingTotal)>
<cfset attributes.AdminCredit = val(attributes.AdminCredit)>

<cfset OrderTotal = subtotal + attributes.Freight + attributes.ShippingTotal - attributes.AdminCredit>

<!---- Debug 
<cfoutput>subtotal:#subtotal#  total:#ordertotal#</cfoutput>
<cfabort>
----->

<!--- Update Order_No Table ---->
<cfquery name="UpdateOrderNo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	UPDATE #Request.DB_Prefix#Order_No
	SET Freight = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Freight#">,
	Shipping = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.shippingTotal#">,
	ShipType= <cfqueryparam cfsqltype="cf_sql_varchar" value="#iif(len(attributes.shiptype),'attributes.shiptype',DE('No Shipping'))#">,
	AdminCredit = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.admincredit#">,
	AdminCreditText= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.admincredittext#">,
	OrderTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#OrderTotal#">,
	Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
	Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>


