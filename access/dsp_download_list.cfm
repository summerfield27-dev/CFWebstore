<!--- CFWebstore, version 6.50 --->

<!--- This template displays a user's memberships. It is linked from the user's account page. Called by the access.download fuseaction --->

<!-- start access/dsp_download_list.cfm -->
<div id="dspdownloadlist" class="access">

<cfmodule template="../customtags/format_box.cfm"
	box_title="Active Downloads"
	border="1"
	align="left"
	float="center"
	Width="480"
	HBgcolor="#Request.GetColors.InputHBGCOLOR#"
	Htext="#Request.GetColors.InputHtext#"
	TBgcolor="#Request.GetColors.InputTBgcolor#">
	
	<cfoutput><table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"
	style="color:###Request.GetColors.InputTText#"></cfoutput>

	<cfif NOT qry_get_Memberships.RecordCount>
		<tr><td align="center" colspan="3" class="formtitle">
			<p><br/>No active downloads found.</p></td></tr>
			
	<cfelse>
		<tr>
			<th align="left">Access To</th>
			<th align="left">Status</th>
			<th align="center">Start</th>
			<th align="center">Expires</th>
		</tr>

		<cfoutput query="qry_get_Memberships">
		<tr>
			<td align="left"><cfif access_count gt access_used AND Valid AND DateCompare(Expire, Now()) GT 0>
			<a href="#XHTMLFormat('#self#?fuseaction=access.download&ID=#membership_id##Request.Token2#')#">#product#</a>
			<cfelse>#product#</cfif></td>
			<!--- Output the current status for this download --->
			<td align="left"><cfif access_count lte access_used>DOWNLOADED<cfelseif NOT Valid>NOT APPROVED<cfelseif DateCompare(Expire, Now()) LTE 0>EXPIRED<cfelse>ACTIVE</cfif></td>
			<td align="center">#dateformat(Start, "mm/dd/yyyy")# </td>
			<td align="center">#dateformat(expire, "mm/dd/yyyy")# </td>
		</tr>
		</cfoutput>
		
	</cfif>
	
	<tr>
		<td align="center" colspan="4" class="formtitle">
			<cfoutput>
			<form action="#XHTMLFormat('#Request.secureSelf#?fuseaction=users.manager#Request.AddToken#')#" method="post" class="margins">
			</cfoutput>
			<input type="submit" value="Back to My Account" class="formbutton"/>
			</form>	
		</td>
	</tr>
	
	
	</table>

</cfmodule>

</div>
<!-- end access/dsp_download_list.cfm -->

