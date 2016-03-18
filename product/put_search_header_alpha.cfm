<!--- CFWebstore, version 6.50 --->

<!--- This page outputs a alphabetic search header above a product list. Used by catcore_products.cfm ---->

<cfif Request.AppSettings.UseSES>
	<cfset catlink = "#Request.SESindex#category/#request.qry_get_cat.Category_ID#/#SESFile(request.qry_get_cat.Name)#?alphasearch=">
<cfelse>
	<cfset catlink = "#self#?fuseaction=category.display&category_ID=#request.qry_get_cat.Category_ID#&alphasearch=">
</cfif>


<cfparam name="attributes.alphasearch" default="all">
<!-- start product/put_search_header_alpha.cfm -->	
<div id="putsearchheaderalpha" class="product">
<table border="0" width="100%" align="center">
<tr>
	<td>
		<cfoutput>
			<div align="center" style="font-size: 7pt;">
			<a href="#XHTMLFormat('#catlink#Num#request.token2#')#" class="<cfif attributes.alphaSearch eq "Num">alphaon<cfelse>alphaoff</cfif>">##'s</a> |
			<cfloop from="65" to="90" index="num">
			<a href="#XHTMLFormat('#catlink##Chr(num)##request.token2#')#" class="<cfif attributes.alphaSearch eq Chr(num)>alphaon<cfelse>alphaoff</cfif>">#Chr(num)#</a> |
			</cfloop>
			<a href="#XHTMLFormat('#catlink#All#request.token2#')#" class="<cfif attributes.alphaSearch eq "All">alphaon<cfelse>alphaoff</cfif>">All</a>
			</div>
		</cfoutput>
	</td>
</tr>
</table>

<cfif len(pt_pagethru)>	
<cfoutput><div align="right" class="section_footer" style="margin:5px;">#pt_pagethru#</div></cfoutput>
</cfif>

<cfif attributes.thickline>
	<cfmodule template="../customtags/putline.cfm" linetype="thick">
</cfif>
</div>
<!-- end product/put_search_header_alpha.cfm -->