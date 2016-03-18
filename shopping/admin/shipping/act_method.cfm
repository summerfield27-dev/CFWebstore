
<!--- CFWebstore, version 6.50 --->

<!--- Runs the admin actions for custom shipping methods: add, edit, delete. Called by shopping.admin&shipping=methods --->

<!--- CSRF Check --->
<cfset keyname = "customMethod">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Prepare priority --->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 99>
</cfif>

<cfif attributes.submit_method is "Delete">

	<cfquery name="DeleteShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#CustomMethods
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

<cfelseif attributes.ID IS 0>

	<cfquery name="AddMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#CustomMethods
			(Name, Amount, Used, Domestic, International, Priority)
		VALUES(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
			<cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Amount#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Domestic#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.International#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">)
	</cfquery>

<cfelse>

	<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#CustomMethods
		SET Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">, 
		Amount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Amount#">,
		Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Used#">,
		Domestic = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Domestic#">,
		International = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.International#">,
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>

</cfif>

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getCustomMethods()>



	


