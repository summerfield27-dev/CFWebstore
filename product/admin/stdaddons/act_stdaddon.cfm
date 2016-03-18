
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on standard addons: add, edit and delete. Asks for confirmation for deletions. Called by product.admin&stdaddon=act --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, and is not adding an option, make sure they have access to this option --->
<cfif NOT ispermitted AND mode IS NOT "i">
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Std_ID#" type="stdaddon">
	<cfset editaddon = useraccess>
<cfelse>
	<cfset editaddon = "yes">
</cfif>

<cfif editaddon>

	<!--- CSRF Check --->
	<cfset keyname = "stdaddonEdit">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	<!--- Set price and weight --->
	<cfscript>
	Price = attributes.Std_Price;
	Price = iif(isNumeric(Price), trim(Price), 0);
	
	Weight = attributes.Std_Weight;
	Weight = iif(isNumeric(Weight), trim(Weight), 0);	
	</cfscript>	
	
	<cfswitch expression="#mode#">
	
		<cfcase value="i">
			
			<cfquery name="Insertaddon" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#StdAddons
			(Std_Name, Std_Prompt, Std_Desc, Std_Type, Std_Price, Std_Weight, Std_Display, Std_ProdMult, Std_Required, User_ID)
			VALUES(	
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Name)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Prompt)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Desc)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Type)#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#Price#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_Display#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_ProdMult#">, 
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.StdRequired#">,
				<cfif ispermitted>0
					<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
				</cfif>
				)
			 </cfquery>	
				
			</cfcase>
				
			<cfcase value="u">
				<cfif submit is not "Delete">
					
					<cfquery name="UpdateOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						UPDATE #Request.DB_Prefix#StdAddons
						SET 
						Std_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Name)#">, 
						Std_Prompt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Prompt)#">, 
						Std_Desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Desc)#">,
						Std_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Type)#">, 
						Std_Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">, 
						Std_Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
						Std_Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_Display#">,
						Std_ProdMult = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_ProdMult#">, 
						Std_Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.StdRequired#">
						WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
						<cfif NOT ispermitted>
							AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
						</cfif>
					</cfquery>
	
				</cfif>
			
			</cfcase>
	
		</cfswitch>	
		
		<cfinclude template="dsp_stdaddon_confirm.cfm">	
					
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to edit this standard addon.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdaddon=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>
			
