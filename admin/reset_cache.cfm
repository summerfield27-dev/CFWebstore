<!--- CFWebstore, version 6.50 --->

<!--- This page is used to reset all the cached data --->

<!--- Clear cached data --->
<cfobjectcache action = "clear">

<cfscript>
	// Clear Application data
	StructDelete(Application, "Reload_CFCs");
	
	if (structKeyExists(Application,"Info")) {
		StructDelete(Application, "Info");
	}
	if (structKeyExists(Application,"ExchangeRates")) {
		StructDelete(Application, "ExchangeRates");
	}
	if (structKeyExists(Application,"SQLChecker")) {
		StructDelete(Application, "SQLChecker");
	}
	if (structKeyExists(Application,"XSSChecker")) {
		StructDelete(Application, "XSSChecker");
	}
	if (structKeyExists(Application,"ProdofDay")) {
		StructDelete(Application, "ProdofDay");
	}
	
	// Also clear the menus, if stored in session memory, so they reload for the admin 
	if (structKeyExists(Session,"SideMenus")) {
		StructDelete(Session, "SideMenus");
	}
	if (structKeyExists(Session,"BottomMenus")) {
		StructDelete(Session, "BottomMenus");
	}
	if (structKeyExists(Session,"TopMenus")) {
		StructDelete(Session, "TopMenus");
	}
	if (structKeyExists(Session,"VertMenus")) {
		StructDelete(Session, "VertMenus");
	}

</cfscript>

<cflocation url="#self#?fuseaction=home.admin&adminmenu=yes&xfa_admin_link=#URLEncodedFormat(cgi.query_string)##Request.Token2#" addtoken="No">

