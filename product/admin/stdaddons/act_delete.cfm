
<!--- CFWebstore, version 6.50 --->

<!--- Deletes a standard addon. Removes from any products using it, and then deletes the standard addon. Called by product.admin&stdaddon=delete --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this option --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Std_ID#" type="stdaddon">
	<cfset editaddon = useraccess>
<cfelse>
	<cfset editaddon = "yes">
</cfif>

<cfif editaddon>
	
	<!--- CSRF Check --->
	<cfset keyname = "stdaddonDelete">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<!--- Delete the addons --->
	<cfquery name="DeleteProdaddons" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#ProdAddons
	WHERE Standard_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
	</cfquery>
	
	<cfquery name="Deleteaddons" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#StdAddons
	WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
	</cfquery>
	
	<cfset attributes.message = "Addon Deleted.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdaddon=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">
				
			
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to edit this standard addon.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdaddon=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>
			
