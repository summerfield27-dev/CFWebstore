<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to create the bottom level menus for the site. Call from your layout pages --->

<cfif NOT isDefined("Session.BottomMenus") OR isDefined("URL.Refresh") OR isDefined("URL.redirect")>

	<cfscript>
		CatMenu = Application.objMenus.dspCatMenu(menu_orientation:'horizontal', menu_class:'menu_footer');
		PageMenu = Application.objMenus.dspPageMenu(menu_orientation:'horizontal', menu_class:'menu_footer', parent_id: 0);
	
		BottomMenus = CatMenu & PageMenu;
	</cfscript>
	
	<cfset Session.BottomMenus = HTMLCompressFormat(BottomMenus)>

</cfif>		

</cfsilent>

<cfoutput>
	<!-- start layouts/put_bottommenus.cfm -->
	<div id="putbottommenus" class="layouts">
	#Session.BottomMenus#
	</div>
	<!-- end layouts/put_bottommenus.cfm -->
</cfoutput>
			