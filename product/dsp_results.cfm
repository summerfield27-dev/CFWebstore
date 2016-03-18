
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to list the results of a product search. Called by product.list|search --->

<!--- searchheader = 1; searchform = 1 ---->
<cfparam name="attributes.searchheader" default="1">
<cfparam name="attributes.searchform" default="1">
<cfparam name="attributes.searchfooter" default="1">
<cfparam name="attributes.thickline" default="1">
<cfparam name="attributes.thinline" default="1">
<cfparam name="attributes.listing" default="">	
<cfparam name="attributes.productCols" default="#request.appsettings.PColumns#">

<!--- Define URL for pagethrough --->
<cfset fieldlist = "category_id,search_string,name,mfg_account_id,displaycount,alphaSearch,sort,order">
<cfinclude template="../includes/act_setpathvars.cfm">

<cfparam name="attributes.displaycount" default="#Request.AppSettings.maxprods#">
<cfparam name="attributes.maxrows" default="#qry_get_products.recordcount#">

<!-- start product/dsp_results.cfm -->
<div id="dspresults" class="product">
<cfmodule template="../customtags/pagethru.cfm" 
	totalrecords="#attributes.maxrows#" 
	currentpage="#Val(attributes.currentpage)#"
	templateurl="#thisSelf#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="#Val(attributes.displaycount)#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >
	

<cfif qry_get_products.recordcount gt 0>

	<cfif attributes.searchheader is "form">
		<cfinclude template="put_search_header_form.cfm">
	<cfelseif attributes.searchheader IS NOT 0>
		<cfinclude template="put_search_header.cfm">
	</cfif>
			
	<cfinclude template="dsp_products.cfm">
	<cfif attributes.searchfooter IS NOT 0>
	<cfinclude template="put_search_footer.cfm">
	</cfif>

<cfelse>

	<cfoutput>
	<cfif isDefined("qry_Get_subCats.recordcount") and qry_get_subCats.recordcount>
		<p>
		Select a category to browse.
		<p>
		<cfmodule template="../customtags/putline.cfm" linetype="Thin"><p>
		
	<cfelseif trim(searchheader) is not "<b>All Products</b>" AND attributes.searchform is "1">
		<p class="ResultHead">No listings found for #searchheader#.<br/><br/>Please try another search...</p>
		
	<cfelseif attributes.searchform is "1">
		<p class="ResultHead">Please enter your search below...</p>
	</cfif>	
	
	</cfoutput>
</cfif>

<cfif attributes.searchform is "1">
	<cfinclude template="put_search_form.cfm">
</cfif>

</div>
<!-- end product/dsp_results.cfm -->
 

