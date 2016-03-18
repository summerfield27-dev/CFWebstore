<cfsilent>

<!--- This is coded for the styles in the blue_vertical.css file --->

<!--- Called by the do_dhtml_menus.cfm page which includes the additonal menu functions and 
outputs the scripts and styles sheets needed for the menu
 --->

<!---
MenuAsList
This is the callback function, this one creates a nested
unordered list, it can be replaced with any other function
(the name of which must be passed as a parameter to
BuildMenu().
When called three parameters will be passed to it:
 TYPE: One of the following:
		MENU_START = start of menu
		MENU_END = end of menu
		SUBMENU_START = start of submenu
		SUBMENU_END = end of submenu
		ITEM = menu item
 TEXT:  Item text (only for SUBMENU_START and ITEM)
 LINK:  Link URL (only for ITEM)
--->
<CFFUNCTION NAME="doCatMenu" RETURNTYPE="string" OUTPUT="no">
	<CFARGUMENT NAME="type" TYPE="string" DEFAULT="">
	<CFARGUMENT NAME="text" TYPE="string" DEFAULT="">
	<CFARGUMENT NAME="link" TYPE="string" DEFAULT="">

	<!--- Local variable for result --->	
	<CFSET var result="">
	
	<!--- Build result based on type --->
	<CFSWITCH EXPRESSION="#type#">
		<CFCASE VALUE="menu_start">
			<CFSET result="<div class=""tmtHierbarV""><ul>">
		</CFCASE>
		<CFCASE VALUE="menu_end">
			<CFSET result="</ul></div>">
		</CFCASE>
		<CFCASE VALUE="submenu_start">
			<CFSET result="<li class=""tmtHiermenuV""><a href=""#link#"" onmouseover=""tmt_showHiermenu(this)"" onmouseout=""tmt_hideHiermenu(this)"">#text#</a><ul>">
		</CFCASE>
		<CFCASE VALUE="submenu_end">
			<CFSET result="</ul>">
		</CFCASE>
		<CFCASE VALUE="item">
			<CFSET result="<li><a href=""#link#"">#text#</a></li>">
		</CFCASE>
	</CFSWITCH>

	<!--- And return it --->
	<CFRETURN result>
</CFFUNCTION>

<!--- Call the function that retrieves the category tree and creates the XML string for it --->
<!--- This function accepts two parameters, the Parent_ID for the menu and the number of levels to show --->
<cfset xmlstring = Application.objMenus.xmlCatTreeCreator(0,10)>
<!--- Do it --->
<cfset CatMenu = BuildMenu(xmlString, doCatMenu)>

</cfsilent>

