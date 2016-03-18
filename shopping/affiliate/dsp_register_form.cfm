<!--- CFWebstore, version 6.50 --->

<!--- Displays the registration form for new affiliates. Called by shopping.affiliate&do=register --->


<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<!-- start code added by affiliate/dsp_aff_register_form.cfm -->
<script type=""text/javascript"">
	<!--
		function CancelForm () {
		location.href = '#Request.SecureSelf#?fuseaction=users.manager&redirect=yes#Request.AddToken#';
		}
	//-->
	</script>
<!-- end code added by affiliate/dsp_aff_register_form.cfm -->
">
</cfprocessingdirective>

<cfoutput>
<!-- start shopping/affiliate/dsp_aff_register_form.cfm -->
<div id="dspaffregisterform" class="shopping">

<form name="editform" action="#XHTMLFormat('#self#?#cgi.query_string#')#" method="post">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "affiliateRegister">
	<cfinclude template="../../includes/act_add_csrf_key.cfm">

<cfmodule template="../../customtags/format_input_form.cfm"
	box_title="Affiliate Registration"
	width="480">
	
	
	<tr align="left">
		<td colspan="3">
<p>Thanks for your interest in our affiliate program! Simply add links to our store on your site and you'll earn a #(get_User_Settings.AffPercent*100)#% commission on every sale made when a user follows that link and makes a purchase.</p>
				
<p>To join, simply enter the URL for your site and click the "Join" button.</p>
</td>
</tr>

<tr align="left">
<td nowrap="nowrap">Your Site URL:</td>
<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
<td><input type="text" name="Aff_Site" size="50" maxlength="255" class="formfield"/></td>
</tr>
<tr align="left">
<td colspan="2"></td><td><br/>
<input type="submit" name="sub_affiliate" value="Join" class="formbutton"/> 
<input type="button" value="Cancel" class="formbutton" onclick="CancelForm();"/></td>
</tr>

</cfmodule>
</form>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
<!--
objForm = new qForm("editform");

objForm.required("Aff_Site");

objForm.Aff_Site.description = "Site URL";

qFormAPI.errorColor = "###Request.GetColors.formreq#";
//-->
</script>
</cfprocessingdirective>

</div>
<!-- end shopping/affiliate/dsp_aff_register_form.cfm -->
</cfoutput>