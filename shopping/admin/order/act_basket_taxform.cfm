<!--- CFWebstore, version 6.50 --->

<!--- Updates Orders tax information from put_taxes_update.cfm template. Called by shopping.admin&order=display --->

<!--- CSRF Check --->
<cfset keyname = "orderTaxes">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Calculate the tax total --->

<cfset ProductTotal = iif(isNumeric(attributes.ProductTotal), attributes.ProductTotal, 0)>
<cfset AllUserTax = iif(isNumeric(attributes.AllUserTax), attributes.AllUserTax, 0)>
<cfset LocalTax = iif(isNumeric(attributes.LocalTax), attributes.LocalTax, 0)>
<cfset CountyTax = iif(isNumeric(attributes.CountyTax), attributes.CountyTax, 0)>
<cfset StateTax = iif(isNumeric(attributes.StateTax), attributes.StateTax, 0)>
<cfset CountryTax = iif(isNumeric(attributes.CountryTax), attributes.CountryTax, 0)>

<!--- Get the total Tax --->
<cfif NOT AllUserTax>
	<cfset TotalTax = LocalTax + CountyTax + StateTax + CountryTax>
<cfelse>
	<cfset TotalTax = AllUserTax>
</cfif>

<cfset AddTax = TotalTax - attributes.OrderTaxes>

<!--- Check if there is already a record for this order's taxes --->
<cfquery name="CheckTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">			
	SELECT Order_No FROM #Request.DB_Prefix#OrderTaxes
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

<cfif CheckTaxes.RecordCount>
	<!--- Update Taxes --->
	<cfquery name="UpdTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">			
		UPDATE #Request.DB_Prefix#OrderTaxes
		SET Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.TaxCode, 1, "^")#">,
		CodeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.TaxCode, 2, "^")#">,
		AddressUsed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AddressUsed#" null="#YesNoFormat(AllUserTax)#">,
		ProductTotal = <cfqueryparam cfsqltype="cf_sql_double" value="#ProductTotal#">, 
		AllUserTax = <cfqueryparam cfsqltype="cf_sql_double" value="#AllUserTax#">, 
		StateTax = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, StateTax)#">,
		CountyTax = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, CountyTax)#">,
		LocalTax = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, LocalTax)#">,
		CountryTax = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, CountryTax)#">
		WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>


<cfelse>
<!--- Add Taxes --->
<cfquery name="InsTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">			
	INSERT INTO #Request.DB_Prefix#OrderTaxes
	(Order_No, Code_ID, CodeName, ProductTotal, AddressUsed, 
		AllUserTax, StateTax, CountyTax, LocalTax, CountryTax)
	VALUES (
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">, 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.TaxCode, 1, "^")#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.TaxCode, 2, "^")#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#ProductTotal#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AddressUsed#" null="#YesNoFormat(AllUserTax)#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#AllUserTax#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, StateTax)#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, CountyTax)#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, LocalTax)#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#iif(AllUserTax, 0, CountryTax)#"> )
</cfquery>

</cfif>

<!--- Update Order_No Table ---->
<cfquery name="UpdateOrderNo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	UPDATE #Request.DB_Prefix#Order_No
	SET Tax = <cfqueryparam cfsqltype="cf_sql_double" value="#TotalTax#">,
	OrderTotal = OrderTotal + <cfqueryparam cfsqltype="cf_sql_double" value="#AddTax#">,
	Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
	Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

