<!--- CFWebstore, version 6.50 --->

<!-- start layouts/lay_alt.cfm -->
<!--- This file must be included at the top of all CFWebstore layout pages! Creates the header section and additional code needed by the software --->	
<cfinclude template="put_layouthead.cfm">

<cfoutput>
	<!--- Style sheet(s) for the layout --->	
<link rel="stylesheet" href="#Request.StorePath#css/alt.css" type="text/css"/>
</cfoutput>

</head>

<!--- Creates the body tag with background image and colors set by the palette. --->
<cfinclude template="put_body.cfm">

<table border="0" cellspacing="0" cellpadding="0" width="620">
<cfoutput>
<tr> 
	<td><img height="1" alt="" src="#Request.ImagePath#spacer.gif" width="70" border="0" /></td>
	<td><img height="1" alt="" src="#Request.ImagePath#spacer.gif" width="130" border="0" /></td>
	<td><img height="1" alt="" src="#Request.ImagePath#spacer.gif" width="20" border="0" /></td>
	<td><img height="1" alt="" src="#Request.ImagePath#spacer.gif" width="570" border="0" /></td>
</tr>

<!--- Logo/Store title row ------------------------------->
<tr>
	<td></td>
	<td height="50" colspan="3">
		<a href="#self##Request.Token1#">
		<img src="#Request.ImagePath#demostore/cfwebstore_hand.gif" alt="" border="0" /></a>
	</td>
</tr>

<!--- Breadcrumb Trail Menu Row--------------->
<tr>
	<td></td>
	<td></td>
	<td colspan="2">
	<cfinclude template="put_breadcrumb.cfm">
	</td>
</tr>

<!---- SPACER ROW below trail menu ------->
<tr> 
    <td colspan="4"><img height="20" src="#Request.ImagePath#spacer.gif" alt="" width="1" border="0" /></td>
</tr>

</cfoutput>

<tr>
	<!---- MENU COLUMN------->
	<td></td>
	<td valign="top" align="left" class="menu_page">
				
		<!--- Menu of Top Level Categories and Pages ---->
		<cfinclude template="put_sidemenus.cfm">
				
		<!--- Links for admins --->		
		<cfinclude template="put_adminlinks.cfm">			
			
	</td>
	
	<!---- SPACER COLUMN------->
	<td>&nbsp;</td>
	
	<!---- PAGE CONTENT ------->
	<td valign="top" class="mainpage">
	
		<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
		<cfinclude template="put_storecontent.cfm">
	
	</td>
</tr>

<!---- Footer Menus ------->
<tr>
	<td></td>
	<td valign="top"></td>
	<td colspan="2" align="center">
		
		<p>&nbsp;</p>
		
		<!--- horizontal category and page menus --->
		<cfinclude template="put_bottommenus.cfm">
			
			<!--- copyright/merchant line --->	
			<cfinclude template="put_copyright.cfm">
			
	</td>	
</tr>
</table>
		
<!--- Allow debug variables list to display only for Administrators when &debug=1 is included in URL. --->
<cfinclude template="put_debug.cfm">
	
</body>
</html>
<!-- end layouts/lay_alt.cfm -->
	