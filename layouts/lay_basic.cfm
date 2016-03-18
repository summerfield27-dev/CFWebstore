
<!--- CFWebstore, version 6.50 --->

<!--- This is an alternative layout page that uses a minimal amount of navigational elements. Edit it as much as you desire using the components below. You can use this by changing the assigned template in the Palette Admin. --->

<!-- start layouts/lay_basic.cfm -->
<!--- This file must be included at the top of all CFWebstore layout pages! Creates the header section and additional code needed by the software --->	
<cfinclude template="put_basic_head.cfm">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr align="right">
<td>
<!--- Output the storewide discounts and shopping cart totals --->
<cfoutput><a href="#Request.SecureSelf#?fuseaction=users.manager">My Account</a></cfoutput>&nbsp;&nbsp;&nbsp;
<cfinclude template="put_topinfo.cfm"> 
</td>
</tr>

<!--- Breadcrumb Trail Menu Row--------------->
<tr>
	<td class="menu_trail">
	<cfinclude template="put_breadcrumb.cfm">
	</td>
</tr>

<!---- SPACER ROW below trail menu. ------->
<tr> 
    <cfoutput>
	<td><img src="#Request.ImagePath#spacer.gif" alt="" height="20" width="1" border="0" /></td>
	</cfoutput>
</tr>

<!---- Main Body Row -------->
<tr>
<td valign="top" class="mainpage">	
	<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
	<cfinclude template="put_storecontent.cfm">	
	</td>
</tr>

<!---- Footer Menus ------->
<tr>
	<td colspan="2" align="center">		
		<p>&nbsp;</p>		
		<!--- horizontal category and page menus --->
		<!---<cfinclude template="put_bottommenus.cfm">--->	
	</td>	
</tr>
</table>
	
	</body>
</html>
	
<!--- Allow debug variables list to display only for Administrators when &debug=1 is included in URL. --->
<cfinclude template="put_debug.cfm">


<!-- end layouts/lay_basic.cfm -->


	