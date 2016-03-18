<!--- CFWebstore, version 6.50 --->

<!--- Order Product Editing Upgrade - This form updates or deletes the products in the basket from the Order Manager.  --->

<!--- CSRF Check --->
<cfset keyname = "orderBasketEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Make sure attributes.Quantity is a whole number; if not, set to 1 --->
<cfparam name="attributes.Quantity" default="1">

<cfif NOT isNumeric(attributes.Quantity)>
	<cfset attributes.Quantity = 1>
<cfelse>
	<cfset attributes.Quantity = Round(attributes.Quantity)>
</cfif>

<cfif attributes.Quantity LT 0>
	<cfset attributes.Quantity = 0>
</cfif>

<!--- Process Options---->
<cfset OptChoice = attributes.OptChoice>

<cfif attributes.productform_submit is "Update">

	<cfset HTMLBreak = Chr(60) & 'br' & Chr(62)>
	<cfset LineBreak = Chr(13) & Chr(10)>
	
	<cfset Addons = Replace(attributes.Addons, LineBreak, HTMLBreak, "All")>

	
	<!--- Update Orders Table  ---->
	<cfquery name="UpdateOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	UPDATE #Request.DB_Prefix#Order_Items
	SET
	OptQuant = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(attributes.OptChoice),attributes.OptQuant,0)#">,
	OptChoice = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(attributes.OptChoice),attributes.OptChoice,0)#">,
	Options	= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Options#">,
	<cfif NOT isDefined("attributes.NoAddonUpdate")>
		Addons = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Addons#">,
		AddonMultP = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.AddonMultP#">,
		AddonNonMultP = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.AddonNonMultP#">,
	</cfif>
	Quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Quantity#">, 
	Price = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Price#">,
	OptPrice = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.OptPrice#">,
	DiscAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.DiscAmount#">
	WHERE Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Orders_ID#">
	AND Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>

<cfelseif attributes.productform_submit is "Delete">

	<!--- Delete Order Record --->
	<cfquery name="DeleteOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Order_Items
		WHERE Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Orders_ID#"> 
		AND Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
	<cfset attributes.Quantity = 0>
	
</cfif>

<!--- Update product inventory amounts --->
<cfset quantity =  attributes.quantity - attributes.Orig_Quantity>

<cfinclude template="act_basket_inventory.cfm">
	

<!--- Recalculate whole order & update Order_No table totals --->
	
	<!--- Get the order product information --->
	<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Order_Items
		WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
	<!--- Calculate new AddonTotal & Order Total ---->
	<cfset SubTotal = 0>
	<cfset AddonTotal = 0>

	<cfloop query="GetOrders">
		<cfset ProdPrice = GetOrders.Price + GetOrders.OptPrice + GetOrders.AddonMultP - GetOrders.DiscAmount>
		<cfset ProdTotal = (ProdPrice * GetOrders.Quantity) - GetOrders.PromoAmount>
		<cfset SubTotal = SubTotal + ProdTotal>
		<cfset AddonTotal = AddonTotal + GetOrders.AddonNonMultP>
	</cfloop>	

	<!--- Get the order total information --->
	<cfquery name="GetOrderNo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Order_No
		WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
	<cfset OrderTotal = SubTotal + AddonTotal - GetOrderNo.OrderDisc - GetOrderNo.Credits + GetOrderNo.Tax + GetOrderNo.Shipping + GetOrderNo.Freight - GetOrderNo.AdminCredit>
	
		
	<!--- Update Order_No Table with new totals  ---->
	<cfquery name="UpdateOrderNo" datasource="#Request.DS#" username="#Request.DSuser#" 	password="#Request.DSpass#">	
		UPDATE #Request.DB_Prefix#Order_No
		SET
		AddonTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#AddonTotal#">,
		OrderTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#OrderTotal#">,
		Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
		Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>

	