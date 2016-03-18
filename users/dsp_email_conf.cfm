<!--- CFWebstore, version 6.50 --->

<!--- Users Email Lock Upgrade - This page presents a message to the user when they request an email with a new unlock code. --->

<!-- start users/manager/dsp_email_conf.cfm -->
<div id="dspemailconf" class="users">

<cfmodule template="../customtags/format_output_box.cfm"
box_title="Email Confirmation Sent"
width="400"
align="Left"
>
<div class="formtitle" style="margin: 9px 9px 9px 9px;">
<cfoutput>
A confirmation email has been sent to #qry_get_user.Email#. 
<p>
<button class="formbutton" onclick="javascript:window.location.href='#request.self#?fuseaction=users.unlock&amp;redirect=yes#request.token2#';">&nbsp; Continue &nbsp;</button>
</p></div>
</cfoutput>
</cfmodule>

</div>
<!-- end users/manager/dsp_email_conf.cfm -->
