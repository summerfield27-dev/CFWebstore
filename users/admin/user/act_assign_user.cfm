<!--- CFWebstore, version 6.50 --->

<!--- Assigns a user to a group. Called from fuseaction users.admin&user=list. --->

<!--- CSRF Check --->
<cfset keyname = "userGroupMove">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif isNumeric(attributes.assign) AND isNumeric(attributes.newgroup)>
	<cfquery name="assign_group" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Users
		SET Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.newgroup#">
		WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assign#">
	</cfquery>			
	
	<cflocation url="#self#?#attributes.addedpath##Request.Token2#" addtoken="No">
</cfif>	

