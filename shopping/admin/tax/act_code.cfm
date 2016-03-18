
<!--- CFWebstore, version 6.50 --->

<!--- Runs the admin actions for tax codes: add, edit, delete. Called by shopping.admin&taxes=editcode --->

<!--- CSRF Check --->
<cfset keyname = "taxCode">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfset TaxRate = iif(isNumeric(attributes.TaxRate), trim(attributes.TaxRate), 0)>

<cfif attributes.submit_code IS "Delete">

	<!--- Make sure this tax code is not currently in use on any orders --->
	<cfquery name="CheckTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">			
		SELECT Order_No FROM #Request.DB_Prefix#OrderTaxes
		WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
	</cfquery>

	<cfif CheckTaxes.RecordCount>
		<cfset attributes.error_message = "There are still orders in the system using this tax code. They must be removed before you can delete the code.">

	<cfelse>
		<!--- Remove all associated taxes first --->
		<cfquery name="DeleteTaxes1" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#LocalTax
			WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
		</cfquery>
		
		<cfquery name="DeleteTaxes2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#StateTax
			WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
		</cfquery>
		
		<cfquery name="DeleteTaxes3" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Counties
			WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
		</cfquery>
		
		<cfquery name="DeleteTaxes4" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#CountryTax
			WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
		</cfquery>
		
		<!--- Remove the tax code --->
		<cfquery name="DeleteCode" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#TaxCodes
			WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
		</cfquery>
	</cfif>


<cfelseif attributes.Code_ID IS 0>

	<cfquery name="AddCode" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	INSERT INTO #Request.DB_Prefix#TaxCodes
		(CodeName, DisplayName, TaxAll, ShowonProds, TaxRate, TaxShipping, TaxAddress, CalcOrder, Cumulative)
	VALUES(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.CodeName)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.DisplayName)#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxAll#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowonProds#">,
		<cfqueryparam cfsqltype="cf_sql_double" value="#(TaxRate/100)#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShipping#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.TaxAddress)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(CalcOrder),CalcOrder,0)#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Cumulative#"> )
	</cfquery>

<cfelse>

	<cfquery name="UpdateCode" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#TaxCodes
	SET CodeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.CodeName)#">,
	DisplayName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.DisplayName)#">,
	TaxAll = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxAll#">,
	ShowonProds = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowonProds#">,
	TaxRate= <cfqueryparam cfsqltype="cf_sql_double" value="#(TaxRate/100)#">,
	TaxShipping = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShipping#">,
	TaxAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.TaxAddress)#">,
	CalcOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(CalcOrder),CalcOrder,0)#">,
	Cumulative = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Cumulative#">
	WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
	</cfquery>

</cfif>

<!--- Update cached products taxes query --->
<cfset Application.objCart.getProdTaxes(reset='yes')>
	


