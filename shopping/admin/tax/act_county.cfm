
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the county tax rates: add, edit and delete. Called by shopping.admin&taxes=county --->

<cfif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "countyTaxRate">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<!--- Check that this state/county combination does not already exist --->
	<cfquery name="CheckCounty" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT County_ID FROM #Request.DB_Prefix#Counties
			WHERE Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">
			AND State= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.State)#">
			AND Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">
			AND County_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.County_ID#">
		</cfquery>

	<cfif attributes.County_ID is "0" AND NOT CheckCounty.Recordcount>

		<cfquery name="AddCounty" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Counties 
			(Code_ID, Name, State, TaxRate, TaxShip)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Code_ID#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.State)#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">, 
				 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#"> )
		</cfquery>
	
	<cfelseif NOT CheckCounty.Recordcount>
		
		<cfquery name="UpdateTax" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Counties
			SET 
			Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
			State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.State)#">,
			TaxRate = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.TaxRate/100)#">, 
			TaxShip = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxShip#">
			WHERE County_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.County_ID#">
		</cfquery>
		
	<cfelse>
		<cfset error_message = "This county has already been added to the state for this tax rate.<br/> Please edit the existing county instead.">		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<cfset keyname = "countyTaxList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Counties
		WHERE County_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>
</cfif>

<!----- RESET the cached taxes query ---->
<cfset Application.objCheckout.getCountyTaxes('yes')>


