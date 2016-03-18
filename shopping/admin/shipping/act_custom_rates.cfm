
<!--- CFWebstore, version 6.50 --->

<!--- Runs the admin actions for the custom shipping rates table: add, edit, delete. Called by shopping.admin&shipping=custom --->

<!--- get proper ship settings --->
<cfif isdefined('session.ship_id')>
	<cfquery dbtype="query" name="ShipSettings">
    select *
    from ShipSettings
    where ID = #session.ship_id#
    </cfquery>
</cfif>

<cfif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "customRates">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif ListFind('Price,Weight,Items', ShipSettings.ShipType)>
		<cfset Amount = attributes.Amount>
	<cfelse>
		<cfset Amount = attributes.Amount / 100>
	</cfif>

	<cfif attributes.ID is "0">
		
		<cfquery name="AddShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Shipping 
			(MinOrder, MaxOrder, Amount)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MinOrder#">,
				<cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MaxOrder#">,
				<cfqueryparam cfsqltype="cf_sql_double" value="#Amount#"> )
		</cfquery>
	
	<cfelse>
		
		<cfquery name="UpdateShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Shipping
			SET 
			MinOrder = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MinOrder#">, 
			MaxOrder = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MaxOrder#">, 
			Amount = <cfqueryparam cfsqltype="cf_sql_double" value="#Amount#">
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<!--- CSRF Check --->
	<cfset keyname = "shipRateList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="DeleteShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Shipping
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>

</cfif>


