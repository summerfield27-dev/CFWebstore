<!--- CFWebstore, version 6.50 --->

<!--- This page is used to output subcategories in full format. It is called by a variety of category template pages. --->
<cfparam name="attributes.thinline" default="1">
<cfparam name="attributes.CatCols" default="#request.appsettings.CColumns#">

<!-- start category/dsp_subcats.cfm -->
<div id="dspsubcats" class="category">
<cfloop query="request.qry_get_subcats">

<cfoutput>

<cfif Request.AppSettings.UseSES>
	<cfset catlink = "#Request.SESindex#category/#request.qry_get_subcats.Category_ID#/#SESFile(request.qry_get_subcats.Name)##Request.Token1#">
<cfelse>
	<cfset catlink = "#self#?fuseaction=category.display&category_ID=#request.qry_get_subcats.Category_ID##Request.Token2#">
</cfif>

<!--- Output category's name and description --->

<cfif attributes.CatCols LTE 1 OR request.qry_get_subcats.CurrentRow MOD attributes.CatCols IS 1>
<table cellspacing="0" cellpadding="6" border="0" width="100%"><tr>
</cfif> 
	<td valign="top" width="#(100/attributes.CatCols)#%">
	<table border="0" cellspacing="0" cellpadding="0"><tr><td valign="top">
	
	<cfif len(Sm_Image)>

	<cfmodule template="../customtags/putimage.cfm" filename="#Sm_Image#" filealt="#Name#" imglink="#XHTMLFormat(catlink)#" imgclass="listingimg">

	</cfif>
	</td>
		<td align="left" valign="top">
	
	<cfif len(Sm_Title)>

	<cfmodule template="../customtags/putimage.cfm" filename="#Sm_Title#" filealt="#Name#" imglink="#XHTMLFormat(catlink)#">

	<cfelse>

	<h2 class="category"><a href="#XHTMLFormat(catlink)#" #doMouseover(Name)#>#Name#</a></h2>

	</cfif>


	<cfif Sale>#Request.SaleImage#</cfif> 
	<cfif Highlight>#Request.NewImage#</cfif>


	<!--- Check for short description --->
	<cfif len(Short_Desc)>
	<div><cfmodule template="../customtags/puttext.cfm" Text="#Short_Desc#" Token="#Request.Token1#" class="cat_text_small"></div>
	</cfif>

	<!--- Category Permission 1 = category admin --->
	<cfmodule template="../access/secure.cfm"
		keyname="category"
		requiredPermission="1"
		>	
		<span class="menu_admin">[<a href="#XHTMLFormat('#Request.secureSelf#?fuseaction=Category.admin&Category=edit&CID=#request.qry_get_subcats.category_id##Request.AddToken#')#"  #doAdmin()#>EDIT CAT #request.qry_get_subcats.category_id#</a>]</span>
	</cfmodule>

</td></tr></table></td>

<cfset NumList = NumList - 1>


<cfif attributes.CatCols LTE 1 OR request.qry_get_subcats.CurrentRow MOD attributes.CatCols IS 0>
</tr></table>
<!----------------------------------->
<cfif NumList IS NOT 0  and attributes.thinline>
<cfmodule template="../customtags/putline.cfm" linetype="Thin">
</cfif>

<cfelseif request.qry_get_subcats.CurrentRow IS request.qry_get_subcats.RecordCount>
<cfloop index = "num" from="1" to="#(attributes.CatCols - request.qry_get_subcats.CurrentRow MOD attributes.CatCols)#">
<td>&nbsp;</td>
</cfloop>
</tr></table>

<!------------------------------------->
<cfif NumList IS NOT 0 and attributes.thinline>
<cfmodule template="../customtags/putline.cfm" linetype="Thin">
</cfif>

</cfif>	

</cfoutput>

</cfloop>

</div>
<!-- end category/dsp_subcats.cfm -->
