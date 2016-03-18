<!--- CFWebstore, version 6.50 --->

<!--- This template displays the message for downloading a file. Called by the access.download fuseaction --->

<!-- start access/dsp_download_file.cfm -->
<div id="dspdownloadfile" class="access">

<cfmodule template="../customtags/format_box.cfm"
	box_title="File Download"
	border="1"
	align="left"
	float="center"
	Width="480"
	HBgcolor="#Request.GetColors.InputHBGCOLOR#"
	Htext="#Request.GetColors.InputHtext#"
	TBgcolor="#Request.GetColors.InputTBgcolor#">
	
	<cfoutput><table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"
	style="color:###Request.GetColors.InputTText#">

	<cfif len(error_message)>
		<tr><td align="center" class="formtitle">
			<br/>#error_message#<br/><br/></td></tr>
			
	<cfelse>
		<tr><td align="center" class="formtitle">
			<br/>Your file is now ready, click below to download. <br/><br/>
			<strong><a href="tempdownloads/#newDirname#/#TheFile#" target="_blank">#qry_get_membership.Name#</a><br/><br/></strong>			
			</td></tr>
	</cfif>
	
	</table>
	</cfoutput>
	
</cfmodule>

</div>
<!-- end access/dsp_download_file.cfm -->
