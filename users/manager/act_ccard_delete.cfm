
<!--- CFWebstore, version 6.50 --->

<!--- Called from the users.ccard circuit. This template processes the dsp_ccard_update form to update the user's credit card information stored in the user table. --->

<cfparam name="attributes.xfa_success" default="fuseaction=users.manager">	
	
<!--- Update the user account --->
<cfset attributes.UID = Session.User_ID>
<cfset attributes.CardType = "">
<cfset attributes.NameOnCard = "">
<cfset attributes.CardNumber = "">
<cfset attributes.CardZip = "">
<cfset attributes.Month = "">
<cfset attributes.Year = "">
<cfset attributes.CardisValid = 0>
<cfset attributes.edittype = "cc">
	
<cfset Application.objUsers.UpdateUser(argumentcollection=attributes)>

<cfinclude template="../qry_get_user.cfm">	

<cfinclude template="../act_set_registration_permissions.cfm">

<cfset attributes.message = "Card Information Deleted">		
<cfset attributes.SecureURL = "Yes">
<cfinclude template="../../includes/form_confirmation.cfm">
