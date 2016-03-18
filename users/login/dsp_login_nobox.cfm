<!--- CFWebstore, version 6.50 --->

<!--- This is style of login box is exactly like dsp_login.cfm without any border. It is the standard style used when the users.login is called from dsp_login_required.cfm called from secure.cfm.
This template can be called by users.login, users.loginbox and users.logout circuits. --->
<!--- Set variables and messages for login page --->
<cfinclude template="act_set_login_vars.cfm">
	
<!--- this box always returns to same page in case of login error. --->

<!-- start users/login/dsp_login_nobox.cfm -->
<div id="dsploginnobox" class="users">

<cfoutput>
<form action="#XHTMLFormat('#doReturn(Request.LoginURL)##Request.AddToken#')#" method="post" name="login">

<table class="mainpage">
	<cfif len(Message)>
		<tr>
			<td colspan="2" align="CENTER">
				<div align="center" class="formerror"><b>#Message#</b></div><p>
			</td>
		</tr>
	</cfif>
		<tr>
    		<td align="right">
				<cfif get_User_Settings.EmailAsName>
					Email Address:
				<cfelse>
					Username: 
				</cfif>
			</td>
			<td><input type="text" name="Username" size="20" maxlength="50" value="#HTMLEditFormat(attributes.Username)#" class="formfieldlogin"/></td>
		</tr>
 		<tr>
        	<td align="right">Password:</td>
         	<td><input type="password" name="password" size="20" maxlength="25" value="#HTMLEditFormat(attributes.password)#"  class="formfieldlogin"/></td>
 		</tr>
		
<!--- <cfif get_User_Settings.UseRememberMe>
 		<tr>
			<td align="right" nowrap="nowrap">remember me:</td>
	    	<td><input type="checkbox" name="rememberme" value="1"  class="formfieldcheckbox" #doChecked(attributes.rememberme)# /></td>
 		</tr>
</cfif>	 --->	
		
		<tr>
        	<td>&nbsp;</td>
         	<td>
			<!--- Hidden field to keep track of SSL status of page --->
			<input type="hidden" name="Server_Port" value="#CGI.SERVER_PORT#"/>
			<input type="submit" name="submit_login" value="Login" class="formbutton"/></td>
 		</tr>

<!--- <cfif get_User_Settings.UseRememberMe and Session.User_ID and attributes.rememberme>
	<form action="#XHTMLFormat('#Request.SecureURL##self#?fuseaction=users.logout#Request.AddToken#')#" method="post">
 		<tr>
			<td><input type="hidden" name="submit_logout" value="Clear"/>&nbsp;</td>
			<td align="center" colspan="2" class="smallformtext">
		 	<input type="submit" name="submit" value="Clear Form" class="formbutton"/>
			</td>
		</tr>
	</form>

<cfelse> --->
	 	<tr>
			<td align="center" colspan="2" class="formtext">
		 		<br/>
				<a href="#XHTMLFormat('#Request.SecureSelf#?fuseaction=users.forgot#Request.AddToken#')#">forgot your login?</a>
				<cfif attributes.use_register and request.reg_form is not "none">
					<br/>
			 		<a href="#XHTMLFormat('#Request.SecureSelf#?fuseaction=users.#request.reg_form##Request.AddToken#&xfa_success=#URLEncodedFormat(attributes.xfa_LoginAction)#')#">register now!</a>						
				</cfif>
			</td>
		</tr>
<!--- </cfif> --->

</cfoutput>
</table>
</form>
	
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
<!--
objForm = new qForm("login");

objForm.required("Username,password");

objForm.Username.focus();

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
//-->
</script>
</cfprocessingdirective>

</div>
<!-- end users/login/dsp_login_nobox.cfm -->

