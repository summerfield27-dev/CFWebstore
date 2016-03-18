<!--- This template provide a "stationery" for order, po and packing list pages. Customize it with your logo and address below. ---->
<cfparam name="attributes.action" default="">

<cfif Not ListFindNoCase("shopping.checkout,feature.display,product.display",attributes.action)>
<!--- START --------------------------------------------------------->
<cfif thistag.ExecutionMode is "Start">
<!-- start customtags/format_letterhead.cfm (start tag) -->
<div id="formatletterhead" class="customtags">
<table height="820" width="620" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse" align="center">
  <tr><cfoutput>

	 <cfif len(request.appsettings.sitelogo)>
		<td class="formtext">
			<img src="#Request.ImagePath##request.appsettings.sitelogo#" alt="#Request.AppSettings.SiteName#" />
		</td><td align="right" valign="bottom" class="formtext">
	<cfelse>
		<td colspan="2" valign="bottom" class="formtext">
	</cfif>
		<!--- ======= Type your address, fax and phone number here ======= ---->
		<table><tr><td align="left" class="formtext">#Request.AppSettings.Merchant#</td></tr></table>
		</cfoutput>

	</td></tr>
	<!--- Top border line ---->
  <tr>
    <td valign="top" width="618" align="left" colspan="2" class="printregistry">
<!-- end customtags/format_letterhead.cfm (start tag) -->
<cfelse><!--- END -------------------------------------------------->
<!-- start customtags/format_letterhead.cfm (end tag) -->
	  </td>
	</tr>
	</table>
	</div>
	<!-- end customtags/format_letterhead.cfm (end tag) -->
</cfif><!---- TAG END ------------------------------------------------>
</cfif>