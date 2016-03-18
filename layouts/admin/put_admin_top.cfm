
<style>
TD {
	FONT-SIZE: 11px; COLOR: #777777; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif;
}
P {
	FONT-SIZE: 12px; COLOR: #777777; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif;
}
</style>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<cfoutput>
<td colspan="2" valign="top"><img src="#Request.ImagePath#admin/logo_cfwebstore.gif" width="240" height="63" alt="" border="0" /></td>
</tr>
<tr>
	<td width="195" valign="top" background="#Request.ImagePath#admin/uppernav_bkgd_purple.gif"><!--- <img src="#Request.ImagePath#uppernav_bkgd_purple.gif" width="195" height="25" alt="" border="0" />---><img src="#Request.ImagePath#admin/spacer.gif" width="195" height="25" alt="" border="0" /></td>
	<td valign="top" background="#Request.ImagePath#admin/uppernav_bkgd.gif">
	<table border="0" cellspacing="0" cellpadding="3" width="100%">
		<tr>
		<td align="center" valign="middle">
		<!--- Main Admin Navigation Here --->
		<b><a href="#request.self#?fuseaction=home.admin&inframes=Yes#Request.Token2#" target="AdminContent">Admin Home</a>  |  <a href="#Request.StoreSelf##Request.Token1#" target="store">View Store</a>  |  <a href="#request.self#?fuseaction=users.logout&submit_logout=yes#Request.Token2#" target="_top">Logout</a>  |  <a href="#Request.StorePath#documentation\cfwebstore.pdf" target="helpfile">Help/Documentation</a></b>
		</td>
		</tr>
	</table>

	</td>
</cfoutput>
</tr>
</table>

