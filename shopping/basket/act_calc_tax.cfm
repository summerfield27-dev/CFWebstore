
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to calculate the tax cost for the order, called from do_checkout_basket.cfm --->

<!--- First check if the user is tax exempt --->
<cfquery name="CheckExempt" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT TaxExempt FROM #Request.DB_Prefix#Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Group_ID#">
</cfquery>

<cfset TaxExempt = iif(CheckExempt.RecordCount, CheckExempt.TaxExempt, 0)>

<cfscript>
	TaxInfo = StructNew();
	TaxInfo.arrTaxCodes = Session.CheckoutVars.TaxTotals;
	TaxInfo.strCustAddress = Application.objCheckout.doCustomerAddress(GetCustomer,GetShipTo);
	TaxInfo.ShipAmount = ShipCost + TotalFreight;
	TaxInfo.TaxExempt = TaxExempt;
	
	arrTaxTotals = Application.objCheckout.calcOrderTax(argumentcollection=TaxInfo);
	
	//loop through the array and total up the taxes
	Tax = 0;
	
	for (i=1; i lte ArrayLen(arrTaxTotals); i=i+1) {
		Tax = Tax + arrTaxTotals[i].TotalTax;
	}
</cfscript>

<!--- Replace previous session tax info --->
<cflock scope="SESSION" timeout="10">
	<cfset Session.CheckoutVars.TaxTotals = arrTaxTotals>
</cflock>

