
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the complete list of U.S.P.S. methods, to set which ones are being used by the store. Called by shopping.admin&shipping=usps_methods --->

<!--- CSRF Check --->
<cfset keyname = "uspsMethodList">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfquery name="GetMethods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Type, ID FROM #Request.DB_Prefix#USPSMethods
</cfquery>

<cfloop query="GetMethods">

	<cfset Priority = attributes['Priority' & ID]>
		
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 99>
	</cfif>

	<cfif StructKeyExists(attributes,'Used' & ID)>
		<cfset Used = 1>
		
		<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#USPSMethods
		SET Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Used#">, 
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>
	
	<cfelse>
		<cfquery name="UpdateMethod2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#USPSMethods
		SET Used = 0,
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>
	</cfif>

</cfloop>

<cfinclude template="act_reset_uspostal.cfm">

<cfset message = "Changes Saved">
<cfset attributes.XFA_success = "fuseaction=shopping.admin&shipping=usps_methods">
<cfinclude template="../../../../includes/admin_confirmation.cfm">



