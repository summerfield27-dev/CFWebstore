<!--- CFWebstore, version 6.50 --->

<!--- Saves the cre secure processing settings for the store. Called by shopping.admin&payment=cresecure --->

<!--- CSRF Check --->
<cfset keyname = "creSettings">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfquery name="EditCRESettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CCProcess
	SET CCServer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.CCServer)#" null="#CheckNull(attributes.CCServer)#">,
	Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Password#" null="#CheckNull(attributes.Password)#">,
	Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Username#" null="#CheckNull(attributes.Username)#">
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="CRESecure">
</cfquery>

