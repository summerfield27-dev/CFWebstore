<!--- CFWebstore, version 6.50 --->

<!--- Starting screen for the UPS license and registration wizard. Called by shopping.admin&shipping=upswizard --->

<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<script language=""JavaScript"">
		function CancelForm () {
		location.href = ""#self#?fuseaction=shopping.admin&shipping=editsettings&redirect=yes#request.token2#"";
		}
	</script>
">
</cfprocessingdirective>


<cfmodule template="../../../../customtags/format_admin_form.cfm"
	box_title="UPS OnLine&reg; Tools Licensing & Registration Wizard - Step 1"
	width="480"
	required_Fields="0"
	>
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&shipping=upslicense#request.token2#"  method="post" name="ups">

	<cfinclude template="../../../../includes/form/put_space.cfm">

		<tr>
			<td align="center" valign="top" width="100">
			<img src="#Request.ImagePath#icons/ups_colorlogo.jpg" alt="" width="68" height="68" border="0" />
			</td>

			<td>
<b>UPS OnLine� Tools Licensing and Registration Wizard</b><br/><br/>

This wizard will assist you in completing the necessary licensing
and registration requirements to activate and use the UPS OnLine
Tools from this application.<br/><br/>

If you do not wish to use any of the functions that utilize the UPS
OnLine Tools, click the Cancel button and those functions will not
be enabled. If, at a later time, you wish to use the UPS OnLine
Tools, return to this section and complete the UPS OnLine Tools
licensing and registration process.<br/><br/>

<div align="center">
<input type="submit" name="submit" value="Next" class="formbutton"/> 
<input type="button" value="Cancel" onclick="javascript:CancelForm();" class="formbutton"/>
</div>
</td></tr>

<tr><td colspan="2" align="center"><br/>
<i>UPS, UPS brandmark, and the Color Brown are trademarks of<br/>
United Parcel Service of America, Inc. All Rights Reserved.</i></td></tr>

</form>
</cfoutput>	
</cfmodule>
