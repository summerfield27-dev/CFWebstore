<!--- CFWebstore, version 6.50 --->

<!--- Used to output a menu of subcategories. Called by category.subcatmenu --->

<cfparam name="attributes.class" default="menu_category">

<cfif Request.AppSettings.UseSES>
	<cfset catlink = "#Request.StoreSelf#category/#request.qry_get_subcats.Category_ID#/#SESFile(request.qry_get_subcats.Name)##Request.Token1#">
<cfelse>
	<cfset catlink = "#Request.StoreSelf#?fuseaction=category.display&category_ID=#request.qry_get_subcats.Category_ID##Request.Token2#">
</cfif>

<!-- start category/dsp_subcat_menu.cfm -->
<div id="dspsubcatmenu" class="category">
<cfloop query="request.qry_get_subcats">
	<cfif len(Sm_Title) and not attributes.menu_text>
		<cfmodule template="../customtags/putimage.cfm" filename="#Sm_Title#" filealt="#Name#" imglink="#XHTMLFormat(catlink)#">
	<cfelse>
		<cfoutput>
		<a href="#XHTMLFormat(catlink)#" class="#attributes.class#" #doMouseover(request.qry_get_subcats.Name)#>#request.qry_get_subcats.Name#</a>
		</cfoutput>
	</cfif><br/>
</cfloop>

</div>
<!-- end category/dsp_subcat_menu.cfm -->