<!--- CFWebstore, version 6.50 --->

<!--- Displays the welcome message for new affiliates, with information on their affiliate code and how to create links. Called by shopping.affiliate&do=register --->

<!-- start shopping/affiliate/dsp_aff_register.cfm -->
<div id="dspaffregister" class="shopping">
<cfmodule template="../../customtags/format_box.cfm"
	box_title="Affiliate Center"
	border="1"
	align="left"
	float="center"
	Width="650"
	HBgcolor="#Request.GetColors.InputHBGCOLOR#"
	Htext="#Request.GetColors.InputHtext#"
	TBgcolor="#Request.GetColors.InputTBgcolor#">

	
	<cfinclude template="dsp_menu.cfm">
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"
	style="color:###Request.GetColors.InputTText#"></cfoutput>
		
		<tr>
			<td align="center" class="formtitle">
				<p>Welcome to the Affiliate Center</p>
			</td>
		</tr>
		
		<tr>
			<td>
<cfoutput>
<blockquote>
<p>You have been enrolled in our affiliate program! You will earn #(get_User_Settings.AffPercent*100)#% commission on every sale made when a user follows a link from your web site to ours and makes a purchase!</p>
				
<p>To start, you simply need to put links on your web site that contain your affiliate code. Your code number is <strong>#Code#</strong>. So for example, a link to our homepage would be:</p>

<div align="center">
#Request.StoreSelf#?aff=#Code#<br/><br/>
</div>		

<p>For more detailed information creating links to individual products and pages of our site, select the "Creating Links" tab at the top of this page.</p>	

<p>You can login to your account at any time to check your current affiliate sales totals which will be listed on this page. Commissions are calculated on total sales for orders that have been completed and filled.</p>	

<p>Feel free to contact us at any time if you have questions about our affiliate program.</p>

</blockquote>
</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfoutput><form action="#Request.SecureSelf#?fuseaction=users.manager#Request.AddToken#" method="post" class="margins"></cfoutput>
			<input type="submit" name="Action" value="Back to My Account" class="formbutton" /> 
			</form>
			</td>
		</tr>
	
	
	</table>

</cfmodule>

</div>
<!-- end shopping/affiliate/dsp_aff_register.cfm -->