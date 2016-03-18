
<!--- CFWebstore, version 6.50 --->

<!--- Updates the country shipping information and resets the cached query for countries. Called by shopping.admin&shipping=country --->

<!--- Set all the country rates --->
<cfif isdefined("attributes.AddAll") AND attributes.AddAll IS "yes">
	<!--- CSRF Check --->
	<cfset keyname = "countryRates">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	<cfquery name="DoAll" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Countries	
		SET Shipping = 1,
		AddShipAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.AllRate/100)#">
	</cfquery>

<!--- Set an individual country rate --->
<cfelseif isdefined("attributes.submit_rate")>

	<!--- CSRF Check --->
	<cfset keyname = "countryRates">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif attributes.ID is "0">
		
		<cfquery name="AddShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Countries	
			SET Shipping = 1,
			AddShipAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.AddShipAmount/100)#">
			WHERE Abbrev = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.Country,1,"^")#">
		</cfquery>
	
	<cfelse>
	
		<cfquery name="UpdateShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Countries
			SET 
			AddShipAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#(attributes.AddShipAmount/100)#">
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
		</cfquery>
		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<!--- CSRF Check --->
	<cfset keyname = "countryRateList">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfquery name="DeleteShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Countries
		SET Shipping = 0, 
			AddShipAmount = 0
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
	</cfquery>
	
</cfif>

<!--- Reset cached countries query --->
<cfquery name="GetCountries" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#CreateTimeSpan(0, 0, 0, 0)#">
	SELECT * FROM #Request.DB_Prefix#Countries
	ORDER BY Name
</cfquery>


