<!--- CFWebstore, version 6.50 --->

<!--- A style of login box for inclusion in a standard 3 column form. This style is used in checkout's customer information form. 

This template is can be called by users.login, users.loginbox and users.logout circuits. --->
<!--- Set variables and messages for login page --->
<cfinclude template="act_set_login_vars.cfm">

<!-- start users/login/dsp_login_formfield.cfm -->

<!--- this box always returns to same page in case of login error. --->
<tr><td colspan="3" align="center" class="formtext">
<cfoutput>
<form name="login" action="#XHTMLFormat('#doReturn(Request.LoginURL)##Request.AddToken#')#" method="post" id="loginform">
<input type="hidden" name="rememberme" value="#attributes.rememberme#"/>

<table width="100%" border="0" cellpadding="0" cellspacing="3" class="formtext">
	
	<tr>
		<td colspan="3" class="formtitle">
		Returning Customers, Please Sign In
		</td>
	</tr>
	<tr>
		<td colspan="3" class="formtext" align="center">
			<cfif len(Message)>
 				<span class="formerror">#Message#</span><br/>
 	 		<cfelse>
			Returning customers should sign in to auto-fill this form.	
	 		</cfif>
		</td>
	</tr>
	<tr align="left">
    	<td align="right">
			<cfif get_User_Settings.EmailAsName>
				Email Address:
			<cfelse>
				Username: 
			</cfif>
		</td>
		<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
		<td><input type="text" name="Username" size="30" maxlength="50" value="#HTMLEditFormat(attributes.Username)#" class="formfield"/></td>
	</tr>
 	<tr align="left">
       	<td align="right">Password:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
       	<td><input type="password" name="password" size="30" maxlength="50" value="#HTMLEditFormat(attributes.password)#" class="formfield"/></td>
 	</tr>
	<tr>
	<td colspan="2">&nbsp;</td>
	<td><a href="#XHTMLFormat('#Request.SecureSelf#?fuseaction=users.forgot#Request.AddToken#')#">Password Help</a></td>
	</tr>
	<tr align="left">
       	<td colspan="2">&nbsp;</td>
       	<td>
		<!--- Hidden field to keep track of SSL status of page --->
		<input type="hidden" name="Server_Port" value="#CGI.SERVER_PORT#"/>
		<input type="submit" name="submit_login" value="Login" class="formbutton"/></td>
 	</tr>
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

	</td></tr>
	
<!-- end users/login/dsp_login_formfield.cfm -->

