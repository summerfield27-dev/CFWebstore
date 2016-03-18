
<!--- CFWebstore, version 6.50 --->

<!--- Runs the admin actions for U.S.P.S. shipping rates: add, edit, delete. Called by shopping.admin&shipping=usps_method --->

<!--- CSRF Check --->
<cfset keyname = "uspsMethod">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<!--- Prepare priority --->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 99>
</cfif>

<cfif attributes.submit_method is "Delete">

	<cfquery name="DeleteShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#USPSMethods
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

<cfelseif attributes.ID IS 0>

	<cfquery name="AddMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#USPSMethods
		(Type, Name, Code, Priority, Used)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Type#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,	
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Code)#">,	
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">)
	</cfquery>

<cfelse>

	<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#USPSMethods
		SET Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Type#">,
		Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,	
		Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Code)#">,	
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
		Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

</cfif>


<cfinclude template="act_reset_uspostal.cfm">
	
<cfset message = "Changes Saved">
<cfset attributes.XFA_success = "fuseaction=shopping.admin&shipping=usps_methods">
<cfinclude template="../../../../includes/admin_confirmation.cfm">

	