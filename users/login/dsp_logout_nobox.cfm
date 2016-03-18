<!--- CFWebstore, version 6.50 --->

<!--- Called from users.loginbox to display the log out button when the user is logged in. This default style uses the input form box. --->

<!--- this box always returns to same page in case of login error. --->

<!-- start users/login/dsp_logout_nobox.cfm -->
<div id="dsplogoutnobox" class="users">

<cfoutput>	
<form action="#XHTMLFormat(Request.CurrentURL)#" method="post">

<cfmodule template="../../customtags/format_input_form.cfm"
box_title="Please Login"
width="180"
required_fields="0"
>
		<tr>
        	<td align="center">&nbsp;</td>
         	<td><input type="submit" name="submit_logout" value="Log Out" class="formbutton"/></td>
 		</tr>
</cfmodule>
</form>
</cfoutput>	

</div>
<!-- end users/login/dsp_logout_nobox.cfm -->
