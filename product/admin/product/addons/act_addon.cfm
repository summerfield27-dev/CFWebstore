
<!--- CFWebstore, version 6.50 --->

<!--- Performs the functions for a product addon: add, edit, delete. Called by product.admin&addon=act|delete --->

<!--- CSRF Check --->
<cfset keyname = "editAddon">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">
<cfparam name="attributes.std_id" default="0">
<cfset attributes.message = "Addon ">

<!---- prepare variables ------>
<cfif mode is not "d">

	<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
		<cfset attributes.Priority = 9999>
	</cfif>

	<cfif NOT attributes.std_ID><!---- for custom Addon ---->
	
		<!--- Set price and weight --->
		<cfscript>
		Price = attributes.Price;
		Price = iif(isNumeric(Price), trim(Price), 0);
		
		Weight = attributes.Weight;
		Weight = iif(isNumeric(Weight), trim(Weight), 0);
		</cfscript>

	</cfif>
	
</cfif>


<cfswitch expression="#mode#">
	<cfcase value="i">
		
		<cfset attributes.message = attributes.message & "added.">

		<cfif attributes.Std_ID>
		
			<cfquery name="InsertAddon" datasource="#Request.DS#" 
			username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#ProdAddons
				(Product_ID, Standard_ID, Prompt, AddonDesc, AddonType, Price, Weight,  
				Display, Priority, ProdMult, Required)
			VALUES
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">, 
				NULL, NULL, NULL, NULL, NULL,  
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Add_Display#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">, 0, 0)
			</cfquery>
	
		<cfelse><!---- custom Addon ---->
				
				<cfquery name="InsertAddon" datasource="#Request.DS#" 
				username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#ProdAddons
					(Product_ID, Standard_ID, Prompt, AddonDesc, AddonType, Price, Weight,  
					Display, Priority, ProdMult, Required)
				VALUES
					(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 0, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Prompt)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.AddonDesc)#">,	
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AddonType#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#Price#">, 
					<cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">, 
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Add_Display#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">, 
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProdMult#">, 
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#">)
				</cfquery>
	
		</cfif><!---- custom Addon ---->
		
	</cfcase>			
			
			
	<cfcase value="u">
		
		<cfset attributes.message = attributes.message & "updated.">
			
		<cfif attributes.Std_ID>
			
			<cfquery name="UpdateAddon" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#ProdAddons
			SET Standard_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">, 
			Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Add_Display#">,
			Priority =<cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.Priority#">
			WHERE Addon_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Addon_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
			</cfquery>	
								
		<cfelse><!---- custom option ---->
		
			<cfquery name="UpdateAddon" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#ProdAddons
			SET 
				Prompt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Prompt)#">,
				AddonDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.AddonDesc)#">,
				AddonType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AddonType#">,
				Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">,
				Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Add_Display#">,
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
				ProdMult = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProdMult#">,
				Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#">
			WHERE Addon_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Addon_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
			</cfquery>
			
		</cfif><!---- custom Addon check---->
		
	</cfcase>
		
	
	
	<cfcase value="d">
		
		<cfset attributes.message = attributes.message & "deleted.">

		<cfquery name="DeleteAddon" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#ProdAddons
			WHERE Addon_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Addon_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
			</cfquery>
			
	</cfcase>	

</cfswitch>	


<cfset attributes.XFA_success = "fuseaction=product.admin&do=addons&product_id=#attributes.product_id#">
<cfif attributes.cid is not "">
	<cfset attributes.XFA_success=attributes.XFA_success&"&cid=#attributes.cid#">
</cfif>
<cfinclude template="../../../../includes/admin_confirmation.cfm">

