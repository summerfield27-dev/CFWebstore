
<!--- CFWebstore, version 6.50 --->

<!--- Called from the users.birthdate circuit. This template processes the dsp_birthdate_update form used to edit a user's birthday information.  --->

<!--- CSRF Check --->
<cfset keyname = "birthdayUpdate">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.xfa_success" default="fuseaction=users.manager">
	
	<!--- reconstruct the birthdate from select lists --->	
	<cfmodule template="../../customtags/form/dropdown.cfm"
	mode = "assemble_date"
	year = "#attributes.bday_year#"
	month = "#attributes.bday_month#"
	date = "#attributes.bday_date#">
	
	<cfset attributes.birthdate = assembled_date>
	
	<!--- Update the user account --->
	<cfset attributes.UID = Session.User_ID>
	<cfset attributes.edittype = "birthdate">
		
	<cfset Application.objUsers.UpdateUser(argumentcollection=attributes)>

	<cfinclude template="../act_set_registration_permissions.cfm">
	
	<cfset attributes.message="Birthdate Updated.">	
	<cfset attributes.SecureURL = "Yes">
	<cfinclude template="../../includes/form_confirmation.cfm">

