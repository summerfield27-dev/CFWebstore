
<!--- CFWebstore, version 6.50 --->

<!--- This page outputs a text description of the search criteria above a product list. Used by dsp_products.cfm and catcore_products.cfm ---->

<!-- start product/put_search_header.cfm -->	
<div id="putsearchheader" class="product">

<cfoutput>
<!--- Output search header --->
<cfif attributes.searchheader>
	<div class="ResultHead">
	<span class="resultheadtext">#qry_Get_products.recordcount# listings for #searchheader#</span>
	<cfif isDefined("qry_Account") AND len(qry_Account.Logo)>
		<div class="acclogoimg">
			<img src="#Request.ImagePath##qry_Account.Logo#">
		</div>
	</cfif>
	<hr>
	</div>
</cfif>

<cfif len(pt_pagethru)>	
	<div align="right" class="section_footer" style="margin:5px;">#pt_pagethru#</div>
</cfif>

<cfif attributes.thickline and (attributes.searchheader OR len(pt_pagethru))>
	<cfmodule template="../customtags/putline.cfm" linetype="thick">
</cfif>

</cfoutput>
</div>
<!-- end product/put_search_header.cfm -->	