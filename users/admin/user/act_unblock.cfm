
<!--- CFWebstore, version 6.50 --->

<!--- This is used to unblock an account that has been locked due to maximum failed logins or too many logins for the day. Called by fuseaction users.admin&user=unblock. --->

<!--- CSRF Check --->
<cfset keyname = "userEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="UpdateUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE Users
	SET FailedLogins = 0,
	LastAttempt = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	LoginsDay = 1
	WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
</cfquery>

