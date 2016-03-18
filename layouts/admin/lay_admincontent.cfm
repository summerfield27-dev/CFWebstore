<!--- CFWebstore, version 6.50 --->

<!--- The web page title is set dynamically to match category, page, product or feature name/title. Proper web page titles are important for search engine placement and ranking. --->

<!--- This file must be included at the top of all CFWebstore layout pages! Creates the header section and additional code needed by the software --->	
<cfinclude template="../put_layouthead.cfm">

<cfoutput>
<!--- Style sheet(s) for the layout --->
<link rel="stylesheet" href="#Request.StorePath#css/adminstyle.css" type="text/css">

<!--- Makes sure this page is not being loaded outside the admin frameset --->
<script type="text/javascript">
if( self == top ) { top.location.href = '#request.self#?fuseaction=home.admin#Request.Token2#'; }
</script>

<noscript>
	<meta http-equiv="refresh" CONTENT="0; URL=#self#?fuseaction=home.nojs#Request.Token2#">
</noscript>
</cfoutput>

<!--- Include color picker color for Color Palette page --->
<cfif isDefined("attributes.Colors") AND isDefined("attributes.Color_ID")>
	<cfoutput><link rel="stylesheet" href="#Request.StorePath#css/default.css" type="text/css"></cfoutput>
	<cfinclude template="../../includes/colorpicker/colorpicker_head.cfm">
	</head>
	<body text="#333333" link="#666699" vlink="#666699" alink="#666699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="colorinit();">
	
<cfelse>
	</head>
	
	<!--- Creates the body tag with background image and colors set by store. --->
	<body text="#333333" link="#666699" vlink="#666699" alink="#666699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

</cfif>
		
		<div class="admincontent">
	
		<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
		<!-- Compress to remove whitespace -->
		<!--- Outputs a div holder for form submission results --->
		<cfparam name="session.result_message" default="">
		
		<cfoutput>
		<cfif len(session.result_message)>
			<br/><br/>
			<div id="messages" class="messages">
				#session.result_message#
			</div>
			
			<cfset Session.result_message = "">
		</cfif>
		
		#HTMLCompressFormat(fusebox.layout)#
		</cfoutput>
	</div>
	<br/><br/>&nbsp;<br/>
	
</body>
</html>

	