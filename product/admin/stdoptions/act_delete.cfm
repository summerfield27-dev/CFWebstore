
<!--- CFWebstore, version 6.50 --->

<!--- Deletes a standard option. Removes from any products using it, and then deletes the standard option. Called by product.admin&stdoption=delete --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this option --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Std_ID#" type="stdoption">
	<cfset editoption = useraccess>
<cfelse>
	<cfset editoption = "yes">
</cfif>

<cfif editoption>
	
	<!--- CSRF Check --->
	<cfset keyname = "stdoptionDelete">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	<!--- Delete the Product Choices for this Option --->
	<cfquery name="DeleteProdChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#ProdOpt_Choices		
		WHERE Option_ID IN (SELECT Option_ID FROM #Request.DB_Prefix#Product_Options 
								WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">)
	</cfquery>
					
	<cfquery name="DeleteProdOpts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Product_Options
		WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
	</cfquery>
	
	<!--- Delete the Standard Choices for this Option --->
	<cfquery name="DeleteStdChoices" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#StdOpt_Choices
		WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
	</cfquery>
	
	<cfquery name="DeleteOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#StdOptions
		WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
	</cfquery>
	
	
	
	<cfset attributes.message = "Option Deleted.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdoption=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">
		
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to delete this standard option.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdoption=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>
		
			
				
