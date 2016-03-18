<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the users.password circuit and used to process the password update form. --->

<!--- CSRF Check --->
<cfset keyname = "passwordUpdate">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.email" default="">
<cfparam name="attributes.xfa_success" default="fuseaction=users.manager">
<cfset attributes.Message="">
<cfset attributes.UID = Session.User_ID>

<cfinclude template="../qry_get_user.cfm">

<cfif get_User_Settings.EmailAsName>
	<cfset attributes.Username = attributes.email>	
</cfif>

<!--- Make sure required fields are not blank --->
<cfif len(attributes.verify) AND len(attributes.password) AND len(attributes.old_password) AND len(attributes.username) and (get_User_Settings.EmailAsName is 0 OR len(attributes.email) )>

	<!--- check passwords are same --->
	<cfif Compare(attributes.Password, attributes.Verify) IS 0>
	
		<!--- Check if old password is accurate --->
		<cfif Compare(qry_Get_User.Password, Hash(attributes.old_Password)) IS 0>
				
			<!--- If a new user name has been entered, it must be unique. --->
			<cfif (qry_get_user.username is not attributes.username)>
			
				<cfquery name="checkuser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT User_ID
					FROM #Request.DB_Prefix#Users
					WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#">
					<cfif get_User_Settings.EmailAsName>
						AND Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">
					</cfif>
				</cfquery>		
			
				<cfif not checkuser.recordcount>					
					
					<cfif get_User_Settings.EmailAsName>
						<cfset attributes.username = attributes.email>
						<cfset attributes.EmailIsBad = 0>
						<cfset attributes.EmailLock = "">
						<cfset attributes.edittype = "emailasname">
					<cfelse>
						<cfset attributes.edittype = "password">
					</cfif>
				
					<!--- update the user account --->
					<cfset Application.objUsers.UpdateUser(argumentcollection=attributes)>
				
				
					<cfif get_User_Settings.EmailAsName and get_User_Settings.UseEmailConf>
						<cfinclude template="../qry_get_user.cfm">
						<cfinclude template="../act_email_conf.cfm">
						<cfinclude template="../act_set_registration_permissions.cfm">	
					</cfif>
													
					<!--- log the user out to force them to re-login using their new username/password ---->
					<cflocation url="#self#?fuseaction=users.logout#Request.Token2#" addtoken="no">
			
				<cfelse>
					<cfset attributes.Message = "Sorry, this username already exists.">
				</cfif>
				
			<cfelseif NOT len(attributes.Message)>
				
				<cfset attributes.username = "">
				<cfset attributes.edittype = "password">
			
				<!--- update the user account --->
				<cfset Application.objUsers.UpdateUser(argumentcollection=attributes)>
	
				<cfinclude template="../act_set_registration_permissions.cfm">
				
				<cfset attributes.message = "Password Updated">		
				<cfset attributes.SecureURL = "Yes">
				<cfinclude template="../../includes/form_confirmation.cfm">

			</cfif>
		
		<cfelse>
			<cfset attributes.Message = "Sorry, current password is incorrect.">
		</cfif>
				
	<cfelse>
		<cfset attributes.Message = "You entered two different new passwords!">
	</cfif>

<cfelse>
	<cfset attributes.Message = "Please fill out all the required fields.">
</cfif>
		