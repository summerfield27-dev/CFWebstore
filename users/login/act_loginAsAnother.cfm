<!--- CFWebstore, version 6.50 --->

<!--- Runs the actions needed to log the user in as another. Called by users.loginAsAnother --->

<!--- CSRF Check --->
<cfset keyname = "loginAsAnother">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!--- This session variable keeps the login link available for multiple login actions, and also tracks the admin user name --->
<cfif not isdefined("Session.AnotherUserLogin")>
	<cfset Session.AnotherUserLogin = Session.Realname> 
	<cfset Session.OrigUserID = Session.User_ID> 
</cfif>

<cfset attributes.submit_login="login">

<!--- Clear the shopping cart --->
<cfscript>

	Application.objCheckout.clearTempTables();
	//Reset basket totals
	qryBasket = Application.objCart.getBasket();
	Application.objCart.doBasketTotals(qryBasket);	
</cfscript>

<!--- Get the user's hashed password --->

<cfquery name="qry_get_pass" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Password
	FROM #Request.DB_Prefix#Users 
	WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UserName#">
</cfquery>

<cfset hashed_password = qry_get_pass.Password>
<cfset attributes.password = "">

<cfinclude template="act_login.cfm">

<!--- If we logged back in as the original user, remove the session vars --->
<cfif Session.User_ID IS Session.OrigUserID>
	<cfset StructDelete( Session, "AnotherUserLogin" ) />
	<cfset StructDelete( Session, "OrigUserID" ) />
</cfif>