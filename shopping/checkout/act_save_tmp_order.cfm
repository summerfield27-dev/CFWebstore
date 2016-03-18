
<!--- CFWebstore, version 6.50 --->

<!--- Saves the order totals to the temporary table. Called by shopping.checkout (step=payment) --->

<!--- Store totals for this order in database --->
<cfquery name="UpdTotals" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#TempOrder
	SET 
	OrderTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#Total#">,
	Tax = 		<cfqueryparam cfsqltype="cf_sql_double" value="#Tax#">,
	ShipType = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ShipType#">, 
	Shipping = 	<cfqueryparam cfsqltype="cf_sql_double" value="#ShipCost#">, 
	Freight =   <cfqueryparam cfsqltype="cf_sql_double" value="#TotalFreight#">,
	OrderDisc = <cfqueryparam cfsqltype="cf_sql_double" value="#BasketTotals.OrderDiscount#">,
	Credits = 	<cfqueryparam cfsqltype="cf_sql_double" value="#Credits#">,
	AddonTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#BasketTotals.AddonTotal#">
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<cfinclude template="qry_get_temporder.cfm">


