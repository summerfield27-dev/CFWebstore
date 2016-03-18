<!--- CFWebstore, version 6.50 --->

<!--- Inserts the terms & conditions form fields. Called during user registration from the users\dsp_account_form.cfm, users\dsp_member_form.cfm and users\dsp_registration_form.cfm templates. 
NOTE: The form action must include the onsubmit parameter: <form action="#request.self#?#attributes.xfa_submit_login#" method="post"<cfif attributes.use_terms> onsubmit="return checkCheckBox(this)"</cfif>> --->

<cfif get_User_Settings.UseTerms>

<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<!-- start code added by users/formfields/put_terms.cfm -->
<script language=""JavaScript"">
	function checkCheckBox(f){
	if (form.agree.checked == false )
	{
	alert('You must read and agree to the Terms and Conditions to proceed.');
	return false;
	}else
	return true;
	}
	</script>
<!-- end code added by users/formfields/put_terms.cfm -->
">
</cfprocessingdirective>

<cfoutput>
	<!-- start users/formfields/put_terms.cfm -->
	<tr><td colspan="3"><img src="#Request.ImagePath#spacer.gif" alt="" height="6" width="1" /></td></tr>
	<tr><td valign="top" align="center" colspan="3">

<textarea cols="55" rows="6" class="formfield">#get_User_Settings.TermsText#</textarea>
	</td></tr>
	
	<tr>
	<td colspan="3" align="center"><input type="checkbox" value="1" name="agree" #doChecked(attributes.agree)# /> 
	I have read and agree to the above Terms and Conditions</td>
	</tr>
	<!-- start users/formfields/put_terms.cfm -->
</cfoutput>
</cfif>


