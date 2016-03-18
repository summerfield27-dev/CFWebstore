<!--- CFWebstore, version 6.50 --->

<!--- Called from users.birthdate circuit, displays a form to allow the user to update their birthdate information. --->

	<cfparam name="attributes.message" default="">
	<cfparam name="attributes.xfa_submit_birthdate" default="fuseaction=users.birthdate">
	
	<cfinclude template="../qry_get_user.cfm">
	<cfset attributes.birthdate=qry_get_user.birthdate>
	
<cfhtmlhead text="
 <script type=""text/javascript"">
 <!--
 function CancelForm() {
 location.href='#self#?fuseaction=users.manager&redirect=yes#request.token2#';
 }
 // --> 
 </script>
">

<!-- start users/manager/dsp_birthdate_update.cfm -->
<div id="dspbirthdateupdate" class="users">
	
<cfoutput>
<form action="#XHTMLFormat('#request.self#?#attributes.xfa_submit_birthdate##request.token2#')#" method="post">
<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
<cfset keyname = "birthdayUpdate">
<cfinclude template="../../includes/act_add_csrf_key.cfm">
</cfoutput>
	
<cfmodule template="../../customtags/format_input_form.cfm"
box_title="Update Birth Date"
width="400"
>
	
	<cfinclude template="../../includes/form/put_message.cfm">
	
	<cfinclude template="../../includes/form/put_space.cfm">
	<cfinclude template="../formfields/put_birthdate.cfm">
	<cfinclude template="../../includes/form/put_space.cfm">
	
	<tr align="left">
    	<td></td><td></td>
		<td>
		<cfoutput><input type="hidden" name="subscribe" value="#qry_Get_User.Subscribe#"/></cfoutput>
		<input type="submit" name="submit_birthdate" value="Update" class="formbutton"/>
		<input type="button" name="Cancel" value="Cancel" onclick="CancelForm();" class="formbutton"/></td>
    </tr>

</cfmodule>
</form>

</div>
<!-- end users/manager/dsp_birthdate_update.cfm -->

