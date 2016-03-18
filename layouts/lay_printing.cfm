<!--- CFWebstore, version 6.50 --->

<!--- The web page title is set dynamically to match category, page, product or feature name/title. Proper web page titles are important for search engine placement and ranking. --->

<!--- This layout is used for pages where no menus or other page elements are desired, generally for printable pages. You can customize this page with your own header or footer --->

<!-- start layouts/lay_printing.cfm -->

<!--- This file must be included at the top of all CFWebstore layout pages! Creates the header section and additional code needed by the software --->	
<cfinclude template="put_layouthead.cfm">

<!--- Style sheet(s) for the layout --->
<cfoutput>
	<cfif fusebox.fuseaction is "admin">
		<link rel="stylesheet" href="#Request.StorePath#css/adminstyle.css" type="text/css"/>
	<cfelse>
		<link rel="stylesheet" href="#Request.StorePath#css/default.css" type="text/css"/>
	</cfif>
</cfoutput>
	
</head>

<!--- Creates the body tag with background image and colors set by store. --->
<body text="#000000" bgcolor="#FFFFFF">

	
		<cfinclude template="put_storecontent.cfm">
	
	
</body>
</html>

<!-- end layouts/lay_printing.cfm -->