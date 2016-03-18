
<!--- CFWebstore, version 6.50 --->

<!--- This is the standard footer that goes at the bottom of product listings. It is called by catcore_product.cfm and dsp_results.cfm. --->

<!-- start product/put_search_footer.cfm -->	
<div id="putsearchfooter" class="product">
	<cfif attributes.thickline>
		<cfmodule template="../customtags/putline.cfm" linetype="thick">
	</cfif>
			
	<cfif len(pt_pagethru)>		
		<cfoutput><div align="center">#pt_pagethru#</div><br/></cfoutput>
	</cfif>

</div>
<!-- end product/put_search_footer.cfm -->