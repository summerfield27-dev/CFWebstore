
<!--- CFWebstore, version 6.50 --->

<!--- This template presents user or group permission key form and processes it.
	IN:
		Type			Set permissions for user | group
		ID				for user_id | group_id 
		XFA_success
	
	This tag has 3 parts: select circut, select permissions, process.
	--->
	
<cfscript>
	function AddList(thelist) {
		var i = 0;
		var theList_len = ListLen(theList);
		var total = 0;
		
		for (i=1; i LTE theList_len; i=i+1) {
			total = total + ListGetAt(thelist, i);
		}

	return total;
	}
</cfscript>

<cfparam name="attributes.type" default=""> 
<cfparam name="attributes.ID" default="">	

<cfif isdefined("attributes.group") and attributes.group is "permissions">
	<cfset attributes.type = "Group">
	<cfset theID = "GID">
	<cfset attributes.ID = attributes.gid>
<cfelseif isdefined("attributes.user") and attributes.user is "permissions">
	<cfset attributes.type = "User">
	<cfset theID = "UID">
	<cfset attributes.ID = attributes.uid>
</cfif>

<cfset attributes.type = Trim(sanitize(attributes.type))>

<cfparam name="attributes.XFA_Success" default="fuseaction=users.admin&#attributes.type#=list"> 

<!--- Get the list of permissions groups --->
<cfinclude template="qry_get_permissions_groups.cfm">
	
<!--- Make sure this is not the admin group and in demo mode --->
<cfif Request.DemoMode AND attributes.type IS "Group" AND attributes.ID IS 1>
	<cfset attributes.box_title="Permission">
	<cfset attributes.message="Administrator group cannot be edited in demo mode.">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

<cfelseif isdefined("attributes.submit_key")>

	<!--- CSRF Check --->
	<cfset keyname = "permissionsEdit">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<!--- Initialize the permission string --->	
	<cfset Permissions = "">
	
	<cfif attributes.registration_key IS NOT 0>
		<cfset Permissions = ListAppend(Permissions,"registration^#attributes.registration_key#", ";")>
	</cfif>
	
	<cfif isDefined("attributes.contentkey_list")>
		<cfset Permissions = ListAppend(Permissions,"contentkey_list^#attributes.contentkey_list#", ";")>
	</cfif>
	
	<!--- Loop through the list of permissions groups --->
	<cfloop query="qry_get_groups">
		<cfif isDefined("attributes.#qry_get_groups.name#_Bits")>
			<cfset currentPerm = AddList(attributes[qry_get_groups.name & '_Bits'])>
			<cfif len(currentPerm) AND currentPerm IS NOT 0>
				<cfset Permissions = ListAppend(Permissions,"#LCase(qry_get_groups.name)#^#currentPerm#", ";")>
			</cfif>
		</cfif>	
	</cfloop>


	<!--- update table with new permission --->
	<cfquery name="Update_permissions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" >
		UPDATE #Request.DB_Prefix##attributes.type#s
		SET Permissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Permissions#">
		WHERE #attributes.type#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>
	
	<cfset attributes.box_title="Permission">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

<cfelse><!--- Display form --->

	<!--- Get type_ID.Permission --->	
	<cfinclude template="qry_get_permissions.cfm">
	<cfinclude template="qry_get_type.cfm">
	
	<!--- Permission Form --->
	<cfinclude template="dsp_priv_form.cfm">
	
</cfif>

<!--- </cfif> ---><!--- circuit check --->




