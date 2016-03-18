<!--- CFWebstore, version 6.50 --->

<!--- Saves the paypal express processing settings for the store. Called by shopping.admin&payment=paypal --->

<!--- CSRF Check --->
<cfset keyname = "paypalSettings">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfquery name="EditExpressSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CCProcess
	SET Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Password#" null="#CheckNull(attributes.Password)#">,
	Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Username#" null="#CheckNull(attributes.Username)#">,
	Transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Transtype)#" null="#CheckNull(attributes.Transtype)#">,
	Setting1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Setting1)#" null="#CheckNull(attributes.Setting1)#">
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="PayPalExpress">
</cfquery>

