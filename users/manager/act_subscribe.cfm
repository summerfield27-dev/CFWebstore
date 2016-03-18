<!--- CFWebstore, version 6.50 --->

<!--- Called from the users.subscribe circuit this template toggles the users.subscribe field. --->

<cfparam name="attributes.xfa_success" default="fuseaction=users.manager">
<cfinclude template="../qry_get_user.cfm">

<!--- Set the default to be the opposite of the current setting. --->
<cfif qry_get_user.subscribe is 1>
	<cfparam name="attributes.set" default="0">
<cfelse>
	<cfparam name="attributes.set" default="1">
</cfif>

<cfquery name="UpdateSubscribe" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Users 
	SET Subscribe = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.set#">
	WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
</cfquery>		

<cfset attributes.message="Subscription Updated">
<cfset attributes.SecureURL = "Yes">	
<cfinclude template="../../includes/form_confirmation.cfm">
