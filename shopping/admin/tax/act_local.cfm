
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the local tax rates: add, edit and delete. Called by shopping.admin&taxes=local --->

<cfif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "localTaxRate">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif attributes.Local_ID is "0">

		<cfquery name="AddTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#LocalTax 
				(Code_ID, Zipcode, EndZip, Tax, TaxShip)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_id#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.zipcode)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.endzip)#">,
				<cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.tax/100)#">, 
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#"> )
		</cfquery>
	
	<cfelse>
		
		<cfquery name="UpdateTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#LocalTax
			SET 
			ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.zipcode)#">, 
			EndZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.endzip)#">,
			Tax = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.tax/100)#">, 
			TaxShip = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#"> 
			WHERE Local_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Local_ID#">
		</cfquery>
			
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<cfset keyname = "localTaxList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#LocalTax
		WHERE Local_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>
	
</cfif>

<!----- RESET the cached taxes query ---->
<cfset Application.objCheckout.getLocalTaxes('yes')>

