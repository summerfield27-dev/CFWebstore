
<!--- CFWebstore, version 6.50 --->

<!--- This template displays form fields to create a new user. It is called during the shopping checkout process (shopping\checkout\do_checkout.cfm and shopping\checkout\act_save_order.cfm), user registration (users.register, users.newuser,  users.member and users.account circuits) as well as during affiliate sign-up (shopping\affiliate\index.cfm).
--->

<!--- form fields --->
<cfparam name="attributes.username" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.subscribe" default="1">
<cfparam name="attributes.groupcode" default="">
<cfparam name="attributes.birthdate" default="">
<cfparam name="attributes.agree" default="0">
<cfparam name="attributes.message" default="">

<!-- start users/manager/dsp_registration_form.cfm -->
<div id="dspregistrationform" class="users">

<cfoutput>
	<form name="editform" action="#XHTMLFormat('#request.self#?#attributes.xfa_submit_login##request.token2#')#" 
	method="post"<cfif get_User_Settings.UseTerms>  onsubmit="return checkCheckBox(editform)"</cfif>>
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "userRegistrationForm">
	<cfinclude template="../includes/act_add_csrf_key.cfm">
</cfoutput>
	
<cfmodule template="../customtags/format_input_form.cfm"
box_title="Sign In Information"
width="380">

<cfinclude template="../includes/form/put_message.cfm">
<cfinclude template="formfields/put_login.cfm">
<cfinclude template="formfields/put_subscribe.cfm">
<cfinclude template="formfields/put_groupcode.cfm">
<cfinclude template="formfields/put_birthdate.cfm">
<cfinclude template="formfields/put_terms.cfm">
<cfinclude template="../includes/form/put_space.cfm">
	
	<tr align="left">
	<td colspan="2"></td>
	<td><input type="submit" name="addlogin" value="Continue >>" class="formbutton"/> 			
	<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>	
	</td></tr>
</cfmodule>
</form>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
<!--//
objForm = new qForm("editform");

objForm.required("email,Username,password,Verify");
objForm.Username.description = "username";
objForm.Verify.description = "re-entered password";
objForm.password.validatePassword('Verify',6,20);
objForm.email.validateEmail();

<cfif get_User_Settings.EmailAsName>
	objForm.email.focus();
<cfelse>
	objForm.Username.focus();
</cfif>

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
//-->
</script>
</cfprocessingdirective>

</div>
<!-- end users/manager/dsp_registration_form.cfm -->

