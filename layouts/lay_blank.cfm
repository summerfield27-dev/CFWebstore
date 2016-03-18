<!--- CFWebstore, version 6.50 --->

<!--- The web page title is set dynamically to match category, page, product or feature name/title. Proper web page titles are important for search engine placement and ranking. --->

<!--- This layout is used for pages where no menus or other page elements are desired, generally for printable pages. You can customize this page with your own header or footer --->

<!-- start layouts/lay_blank.cfm -->

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
<cfinclude template="put_body.cfm">

	
		<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
		<!--- Compress to remove whitespace --->
		<cfoutput>#HTMLCompressFormat(fusebox.layout)#</cfoutput>
	
	
</body>
</html>

<!-- end layouts/lay_blank.cfm -->