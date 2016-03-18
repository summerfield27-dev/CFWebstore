<!--- CFWebstore, version 6.50 --->

<!--- This template is called by any of the detail pages to output a list of categories that the detail item appears in. The output is a Category Listing. Called by category.related --->

<cfif Request.GetRelatedCats.recordcount>

<!-- start category/dsp_related_categories.cfm -->
<div id="dsprelatedcategories" class="category">
<div class="section_footer">
<cfoutput query="Request.GetRelatedCats">
<cfif Request.AppSettings.UseSES>
	<cfset catlink = "#Request.SESindex#category/#Category_ID#/#SESFile(Name)##Request.Token1#">
<cfelse>
	<cfset catlink = "#self#?fuseaction=category.display&category_ID=#Category_ID##Request.Token2#">
</cfif>
<img src="#Request.ImagePath#icons/lleft.gif" border="0" style="vertical-align: middle" alt="" hspace="2" vspace="0" /> <a href="#XHTMLFormat(catlink)#" class="section_footer" #doMouseover(Name)#>#name#</a><br/>
</cfoutput>	
</div>
<!-- end category/dsp_related_categories.cfm -->

</cfif>