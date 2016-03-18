<!--- CFWebstore, version 6.50 --->

<!--- Saves the credit card processing settings for the store. Includes 5 fields which can be used by the processor form pages. Called by shopping.admin&payment=cards --->

<!--- CSRF Check --->
<cfset keyname = "gatewaySettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.CCServer" default="">
<cfparam name="attributes.Password" default="">
<cfparam name="attributes.Transtype" default="">
<cfparam name="attributes.Username" default="">
<cfparam name="attributes.Setting1" default="">
<cfparam name="attributes.Setting2" default="">
<cfparam name="attributes.Setting3" default="">

<!--- BEGIN MOD - added SMS: 04/10/2007 --->
<cfif get_Order_Settings.CCProcess IS "Shift4OTN">
	<cfinclude template="gateways/act_shift4otn.cfm">
</cfif>
<!--- END MOD --->

<cfquery name="EditCCProcess" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CCProcess
	SET CCServer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.CCServer)#" null="#CheckNull(attributes.CCServer)#">,
	Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Password#" null="#CheckNull(attributes.Password)#">,
	Transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Transtype)#" null="#CheckNull(attributes.Transtype)#">,
	Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Username#" null="#CheckNull(attributes.Username)#">,
	Setting1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Setting1)#" null="#CheckNull(attributes.Setting1)#">,
	Setting2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Setting2)#" null="#CheckNull(attributes.Setting2)#">,
	Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Setting3)#" null="#CheckNull(attributes.Setting3)#">
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfif IsDefined("form.ProcessPost")>
	<cfset variables.ConfigProcess="Postprocess.Post">
	<cfinclude template="#form.ProcessPost#">
</cfif>


