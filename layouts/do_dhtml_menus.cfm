<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to call the CFCs for creating the site menus. Call from your layout pages --->
<!--- This version uses the new code for creating DHTML sytle cascading menus using XML trees --->

<!--- See the written documentation for information on using or modifying these menus. --->

<!--- Include menuing functions --->
<cfinclude template="../includes/menufunc.cfm">

<!--- Output the script for the menu and any styles used to the html page header --->
<cfhtmlhead text='
	<!-- start code added by layouts/do_dhtml_menus.cfm -->
	<script src="#Request.StorePath#includes/hiermenu/tmt_hiermenu/tmt_hiermenu.js" type="text/javascript"></script>
	<link href="#Request.StorePath#includes/hiermenu/tmt_hiermenu/css/blue_vertical.css" rel="stylesheet" type="text/css" />
	<link href="#Request.StorePath#includes/hiermenu/tmt_hiermenu/css/office2003_blue.css" rel="stylesheet" type="text/css" />	
	<!-- end code added by layouts/do_dhtml_menus.cfm -->
	'>	
		
<cfif NOT isDefined("Session.VertMenus") OR isDefined("URL.Refresh") OR isDefined("URL.redirect")>
		
	<!--- If you wish to change the default menus, such as the number of levels displayed, 
	starting point, or the classes used, modify these two files as needed --->
	<cfinclude template="do_catmenu.cfm">
	<cfinclude template="do_pagemenu.cfm">
	<cfscript>	
		TopMenus = PageMenu;
		VertMenus = CatMenu & '<div class="menu_page">&nbsp;</div>';
		
		Session.TopMenus = HTMLCompressFormat(TopMenus);
		Session.VertMenus = HTMLCompressFormat(VertMenus);
	</cfscript>

</cfif>
		
<!--- Alternative version if your menus change and need to be reloaded on different pages of the site 
<cfscript>	
	TopMenus = PageMenu & '<div class="menu_page">&nbsp;</div>';
	VertMenus = CatMenu & '<div class="menu_page">&nbsp;</div>';
	
	TopMenus = HTMLCompressFormat(TopMenus);
	VertMenus = HTMLCompressFormat(VertMenus);
</cfscript>
--->

</cfsilent>