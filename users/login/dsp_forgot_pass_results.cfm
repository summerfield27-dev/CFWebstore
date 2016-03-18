
<!--- CFWebstore, version 6.50 --->

<cfparam name="errormess" default="">

<!-- start users/login/dsp_forgot_pass_results.cfm -->
<div id="dspforgotpassresults" class="users">

<!--- Display results form ---->
<cfmodule template="../../customtags/format_input_form.cfm"
box_title="Password Help"
width="350"
border="1"
align="center"
required_fields="0"
>

<cfoutput>
<tr><td align="center" class="formtitle">
<cfif NOT GetCustInfo.RecordCount>
	<p class="formerror">Email not found.</p>
	<form action="#XHTMLFormat('#self#?fuseaction=users.forgot#Request.Token2#')#" method="post">
		<input type="submit" value="Try Another Address" class="formbutton"/>
	</form>

	<form action="#XHTMLFormat('#self#?fuseaction=users.#request.reg_form##Request.Token2#')#" method="post">
		<input type="submit" value="Register Now" class="formbutton"/>
	</form>	
	
<cfelseif len(errormess)>
	<p class="formerror">#errormess#</p>
	<form action="#XHTMLFormat('#self#?fuseaction=users.forgot#Request.Token2#')#" method="post">
		<input type="submit" value="Try Another Address" class="formbutton"/>
	</form>

	<form action="#XHTMLFormat('#session.page#')#" method="post">
		<input type="submit" value="Return to Store" class="formbutton"/>
	</form>	

<cfelse>
	<p>Your password has been reset and emailed to you.</p>
</cfif>
	<form action="#XHTMLFormat('#self##request.token1#')#" method="post" class="margins">
		<input type="submit" value="Back to Site" class="formbutton"/>
	</form>	
	</td></tr>
</cfoutput>
</cfmodule>

</div>
<!-- end users/login/dsp_forgot_pass_results.cfm -->
