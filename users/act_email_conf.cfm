<!--- CFWebstore, version 6.50 --->

<!--- If email confirmations are enabled, this template will email the new user a code which must be entered into the site to verify that their email address is valid. This template is called from act_register.cfm and do_register.cfm as well as manager\act_email_update.cfm --->


<cfset new_password = qry_get_user.emailLock>

<cfif not len(new_password)>

	<!--- Create a random email validation code --->
	<cfset GetPass = Application.objGlobal.randomPassword(Length="6", AllowNums="no", Case="Upper") />

	<!--- Enter the new validation code into the user record --->
	<cfquery name="UpdateLock" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Users
		SET EmailIsBad = 0,
		EmailLock = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetPass.new_password#">
		WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
	</cfquery>

<cfelseif qry_get_user.emailLock is 'verified'>

	<cflocation url="#request.self#?fuseaction=users.manager#Request.Token2#" addtoken="No">

</cfif>


<!--- Email the new validation code to the user --->
<cfset Application.objGlobal.sendAutoEmail( UID="#qry_get_user.User_ID#", MailAction="EmailConfirmation") />
	
	
