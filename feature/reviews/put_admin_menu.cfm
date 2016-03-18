<!--- CFWebstore, version 6.50 --->

<!--- Feature Permission 8 = feature reviews admin --->

<!-- start feature/reviews/put_admin_menu.cfm -->
<div id="putadminmneu" class="feature">

<cfmodule  template="../../access/secure.cfm"
	keyname="feature"
	requiredPermission="8"
	>
	<cfset adminlink = "#Request.SecureSelf#?fuseaction=feature.admin&Review_ID=#Review_ID##Request.AddToken#">
	
	<cfoutput><div class="menu_admin">[<a href="#XHTMLFormat('#adminlink#&review=edit&XFA_success=#URLEncodedFormat(cgi.query_string)#')#" #doAdmin()#>EDIT Review #Review_ID#</a> | 
<cfset returnURL = "fuseaction=feature.reviews&do=list&feature_ID=#feature_id#">
<a href="#XHTMLFormat('#adminlink#&review=delete&XFA_success=#URLEncodedFormat(returnURL)#')#" #doAdmin()#>DELETE Review #Review_ID#</a> 
]</div></cfoutput>

</cfmodule>
	
</div>
<!-- end feature/reviews/put_admin_menu.cfm -->
