
<!--- CFWebstore, version 6.50 --->

<!--- Runs the admin actions for FedEx shipping rates: add, edit, delete. Called by shopping.admin&shipping=fedex_method --->

<!--- CSRF Check --->
<cfset keyname = "fedexMethod">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<!--- Prepare priority --->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 99>
</cfif>

<cfif attributes.submit_method is "Delete">

	<cfquery name="DeleteShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#FedExMethods
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

<cfelseif attributes.ID IS 0>

	<cfquery name="AddMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#FedExMethods
		(Shipper, Name, Code, Priority, Used)
		VALUES
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipper#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,	
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Code)#">,	
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">)
	</cfquery>

<cfelse>

	<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#FedExMethods
		SET Shipper = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipper#">,
		Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,	
		Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Code)#">,
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
		Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

</cfif>


<cfinclude template="act_reset_fedex.cfm">

<cfset message = "Changes Saved">
<cfset attributes.XFA_success = "fuseaction=shopping.admin&shipping=fedex_methods">
<cfinclude template="../../../../includes/admin_confirmation.cfm">

