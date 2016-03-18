
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the state tax rates: add, edit and delete. Called by shopping.admin&taxes=state --->

<cfif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "stateTaxRate">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif attributes.Tax_ID is "0">

		<cfquery name="AddTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#StateTax
				(Code_ID, State, TaxRate, TaxShip)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_id#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.State)#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">, 
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#"> )
		</cfquery>
	
	<cfelse>
		
		<cfquery name="UpdateTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#StateTax
			SET 
			State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.State)#">, 
			TaxRate = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">,
			TaxShip = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#">
			WHERE Tax_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Tax_ID#">
		</cfquery>
		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<cfset keyname = "stateTaxList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#StateTax
		WHERE Tax_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>
</cfif>

<!----- RESET the cached taxes query ---->
<cfset Application.objCheckout.getStateTaxes('yes')>

