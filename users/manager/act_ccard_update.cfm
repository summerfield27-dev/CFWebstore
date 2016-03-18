
<!--- CFWebstore, version 6.50 --->

<!--- Called from the users.ccard circuit. This template processes the dsp_ccard_update form to update the user's credit card information stored in the user table. --->

<!--- CSRF Check --->
<cfset keyname = "ccardUpdate">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.xfa_success" default="fuseaction=users.manager">	
<cfparam name="attributes.CVV2" default="">
	
<!--- Update the user account --->
<cfset attributes.UID = Session.User_ID>
<cfset attributes.CardisValid = 1>
<cfset attributes.edittype = "cc">
	
<cfset Application.objUsers.UpdateUser(argumentcollection=attributes)>

<cfinclude template="../qry_get_user.cfm">	
<cfinclude template="../act_use_ccard.cfm">	

<cfinclude template="../act_set_registration_permissions.cfm">

<cfset attributes.message = "Card Information Updated">		
<cfset attributes.SecureURL = "Yes">
<cfinclude template="../../includes/form_confirmation.cfm">
	
