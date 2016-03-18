<!--- CFWebstore, version 6.50 --->

<!--- Updates Orders dropshipping information from put_basket_shipform.cfm template. Called by shopping.admin&order=display --->

<!--- CSRF Check --->
<cfset keyname = "basketShipping">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfloop index="Order_ID" list="#attributes.Orderslist#">

	<cfset dropship_Account_ID = attributes['dropship_Account_ID' & Order_ID]>
	<cfset dropship_qty = attributes['dropship_qty' & Order_ID]>
	<cfset dropship_sku = attributes['dropship_sku' & Order_ID]>
	<cfset dropship_note = attributes['dropship_note' & Order_ID]>
	<cfset dropship_cost = attributes['dropship_cost' & Order_ID]>
	<cfif NOT len(Trim(dropship_cost))>
		<cfset dropship_cost = 0>
	</cfif>
	
	<cfquery name="UpdateOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Order_Items
		SET Dropship_Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#dropship_Account_ID#" null="#YesNoFormat(NOT len(dropship_Account_ID))#">,
		Dropship_Qty = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(dropship_qty) AND len(dropship_Account_ID),dropship_qty,0)#">,
		Dropship_SKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dropship_sku#">,
		Dropship_Cost = <cfqueryparam cfsqltype="cf_sql_double" value="#dropship_cost#">,
		Dropship_Note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dropship_note#">
		WHERE Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_ID#">
		AND Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
</cfloop>