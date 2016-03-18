<!--- CFWebstore, version 6.50 --->

<!--- Product Permission 64 = product reviews admin --->
<cfmodule  
	template="../../access/secure.cfm"
	keyname="product"
	requiredPermission="64"
	>
	
<cfif isdefined("Review_ID")>
	<cfset adminlink = "#Request.SecureSelf#?fuseaction=product.admin&review_id=#review_id##Request.AddToken#">
	<cfoutput>
	<!-- start product/reviews/put_admin_menu.cfm -->
	<div class="menu_admin">[<a href="#XHTMLFormat('#adminlink#&review=edit&xfa_success=#URLEncodedFormat(cgi.query_string)#')#" #doAdmin()#>EDIT Review #Review_ID#</a> | 
	<cfset returnURL = "#self#?fuseaction=product.reviews&do=list&product_ID=#product_id#">
	<a href="#XHTMLFormat('#adminlink#&review=delete&xfa_success=#URLEncodedFormat(returnURL)#')#" #doAdmin()#>DELETE Review #Review_ID#</a> 
	]</div>
	<!-- end product/reviews/put_admin_menu.cfm -->
	</cfoutput>
</cfif>

</cfmodule>
	
	

