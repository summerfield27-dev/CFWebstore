
<!--- CFWebstore, version 6.50 --->

<!--- This is the layout page for the entire store. Edit it as much as you desire using the components below. Your store can use more than one layout page.  Lay_default.cfm will be the site's default layout. Additional layouts can be created and named. You can attach a custom layout page to a Palette that you create in the Palette Admin. The Palette can then be assigned to an individual Category, Product, Feature, or Page. --->

<!-- start layouts/lay_default.cfm -->

<!--- This file must be included at the top of all CFWebstore layout pages! Creates the header section and additional code needed by the software --->	
<cfinclude template="put_layouthead.cfm">

<cfoutput>
	<!--- Style sheet(s) for the layout --->	
	<link rel="stylesheet" href="#Request.StorePath#css/default.css" type="text/css" />
</cfoutput>

</head>

<!--- Creates the body tag with background image and colors set by the palette. --->
<cfinclude template="put_body.cfm">

<table border="0" cellspacing="0" cellpadding="0" width="620">

<!--- The page has three columns: left menu, spacer, and body 
The column widths are set in this first row. Change the spacer.gif width to adjust columns.----->
<cfoutput>
	<tr>  
		<td><img src="#Request.ImagePath#spacer.gif" height="1" alt="" width="160" border="0" /></td>
		<td><img src="#Request.ImagePath#spacer.gif" height="1" alt="" width="30" border="0" /></td>
		<td><img src="#Request.ImagePath#spacer.gif" height="1" alt="" width="575" border="0" /></td>
	</tr>
</cfoutput>

<!--- Logo/Store title row ------------------------------->
<tr>
 <td colspan="3">
 
 <table width="100%" border="0">
  <tr>
 
  <td align="left" width="50%">
  <span style="font-size: large;">
  <cfinclude template="put_sitelogo.cfm">
  </span>
  </td>
  <td align="right" width="50%">

  <!--- Output the storewide discounts and shopping cart totals --->
	<cfinclude template="put_topinfo.cfm">  

  </td> 
 </tr>
 </table>
 
 </td> 
</tr> 

<!--- Breadcrumb Trail Menu Row--------------->
<tr>
	<td></td>
	<td colspan="2"  class="menu_trail">
	<cfinclude template="put_breadcrumb.cfm">
	</td>
</tr>

<!---- SPACER ROW below trail menu. ------->
<cfoutput>
	<tr> 
	    <td colspan="3"><img src="#Request.ImagePath#spacer.gif" alt="" height="20" width="1" border="0" /></td>
	</tr>
</cfoutput>

<!---- Main Body Row -------->
<tr>
	<!---- MENU COLUMN------->
	<td valign="top" align="right">
				
		<!--- Menu of Top Level Categories and Pages ---->
		<cfinclude template="put_sidemenus.cfm">
			
		<!--- Links for admins --->		
		<cfinclude template="put_adminlinks.cfm">	
		
		<!--- An optional persistent search box --->		
		<cfinclude template="put_searchbox.cfm">	
		
		<!--- An optional persistent log-in box -- the site works perfectly well without --->
		<cfinclude template="put_loginbox.cfm">			
			
	</td>
	
	<!---- SPACER COLUMN between menu and content ------->
	<td>&nbsp;</td>
	
	<!---- PAGE CONTENT ------->
	<td valign="top" class="mainpage">
	
		<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
		<cfinclude template="put_storecontent.cfm">
	
	</td>
</tr>

<!---- Footer Menus ------->
<tr>
	<td valign="top" align="right"></td>
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
<!-- end layouts/lay_default.cfm -->
	