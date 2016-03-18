
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the country tax rates: add, edit and delete. Called by shopping.admin&taxes=country --->

<cfif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "countryTaxRate">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif attributes.Tax_ID is "0">

		<cfquery name="AddTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#CountryTax
			(Code_ID, Country_ID, TaxRate, TaxShip)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_id#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Country_ID#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">, 
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#"> )
		</cfquery>
	
	<cfelse>
		
		<cfquery name="UpdateTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#CountryTax
			SET 
			Country_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Country_ID#">, 
			TaxRate = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">, 
			TaxShip = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#">
			WHERE Tax_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Tax_ID#">
		</cfquery>
		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<!--- CSRF Check --->
	<cfset keyname = "CountryTaxList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#CountryTax
		WHERE Tax_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>
</cfif>


<!----- RESET the cached taxes query ---->
<cfset Application.objCheckout.getCountryTaxes('yes')>

