<!--- CFWebstore, version 6.50 --->

<!--- Outputs the footer for the accounts listings, called by catcore_accounts.cfm and dsp_results.cfm --->

<!-- start users/account/put_searchfooter.cfm -->
<div id="putsearchfooter" class="users">

<cfmodule template="../../customtags/putline.cfm" linetype="thick" width="100%">

<cfoutput>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td class="section_footer"><img src="#Request.ImagePath#icons/up.gif" border="0" valign="baseline" alt="" hspace="2" vspace="0" /><a href="#XHTMLFormat(Request.currentURL)###top" class="section_footer" #doMouseover('top of page')#>top</a> 
<!---
|<img src="#Request.ImagePath#icons/left.gif" border="0" valign="middle" alt="" hspace="2" vspace="0" /><a href="#self#?fuseaction=category.display&category_id=#listlast(request.qry_get_cat.parentids)#" class="section_footer"  onmouseover=" window.status='back'; return true" onmouseout="window.status=' '; return true">#listlast(request.qry_get_cat.parentnames,":")#</a>
--->
		</td>
		
		<td align="right" class="section_footer">
		#pt_pagethru#
		</td>
	</tr>
</table>
</cfoutput>

</div>
<!-- end users/account/put_searchfooter.cfm -->
