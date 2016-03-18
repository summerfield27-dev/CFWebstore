
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the complete list of FedEx methods, to set which ones are being used by the store. Called by shopping.admin&shipping=fedex_methods --->

<!--- CSRF Check --->
<cfset keyname = "fedexMethodList">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfquery name="GetMethods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT ID FROM #Request.DB_Prefix#FedExMethods
</cfquery>

<cfloop query="GetMethods">
	
	<cfset Priority = attributes['Priority' & ID]>
		
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 99>
	</cfif>
	
	<cfif StructKeyExists(attributes,'Used' & ID)>
		<cfset Used = 1>
		
		<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#FedExMethods
			SET Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Used#">,
			Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>
	
	<cfelse>
		<cfquery name="UpdateMethod2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#FedExMethods
			SET Used = 0,
			Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>
	</cfif>

</cfloop>

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="act_reset_fedex.cfm">

<cfset message = "Changes Saved">
<cfset attributes.XFA_success = "fuseaction=shopping.admin&shipping=fedex_methods">
<cfinclude template="../../../../includes/admin_confirmation.cfm">





