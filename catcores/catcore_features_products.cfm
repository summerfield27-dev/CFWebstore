
<!--- CFWebstore, version 6.50 --->

<!--- This is the default file used for the 'features + product' template page --->

<!--- This template puts features first, then products. --->

<!----- This template can accept a passparam attribute of listing = standard | short --->
<cfparam name="attributes.showType" default="0">
<cfparam name="attributes.listing" default="standard">
<cfparam name="attributes.thickline" default="1">
<cfparam name="attributes.thinline" default="1">

<cfinclude template="../feature/qry_get_features.cfm">	
<cfinclude template="../product/queries/qry_get_products.cfm">	

<cfset numlist = qry_get_features.recordcount + qry_get_products.recordcount + request.qry_get_subcats.recordcount>

<!----- Set this product page for Keep Shopping button ------->
<cfset Session.Page = Request.currentURL>

<!--- Define URL for pagethrough --->
<cfset fieldlist = "sort">
<cfset IDlist = "category_id">
<cfinclude template="../includes/act_setstorepath.cfm">

<!-------
<cfif not request.qry_get_cat.prodfirst and attributes.currentpage is "1">
	<cfset DISPLAYCOUNT = request.qry_get_SubCats.Recordcount + Request.AppSettings.maxprods>
<cfelse>
	<cfset DISPLAYCOUNT = Request.AppSettings.maxprods>
</cfif>
----->

<cfparam name="attributes.displaycount" default= "#Request.AppSettings.maxprods#">

<!--- Create the page through links, max records set by the display count --->
<cfmodule template="../customtags/pagethru.cfm" 
	totalrecords="#numlist#" 
	currentpage="#Val(attributes.currentpage)#"
	templateurl="#templatepath#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="#Val(attributes.displaycount)#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >


<!-- start catcores/catcore_features_products.cfm -->
<div id="catcorefeaturesproducts" class="catcores">

	
<!--- output listings --->
<cfif NumList IS 0>
	<cfoutput>
	<div>Currently, there are no listing for in this category. Check back soon for new additions!</div>
	</cfoutput>

<cfelse>
	<cfif request.qry_get_cat.ProdFirst>
	
		<cfinclude template="../feature/dsp_features.cfm">
		<cfinclude template="../product/dsp_products.cfm">
		<cfinclude template="../category/dsp_subcats.cfm">

	<cfelse>
		<cfif attributes.currentpage is 1>
			<cfinclude template="../category/dsp_subcats.cfm">
		</cfif>
		<cfinclude template="../feature/dsp_features.cfm">
		<cfinclude template="../product/dsp_products.cfm">
			
	</cfif>
</cfif>

<cfoutput><div align="center">#pt_pagethru#</div><br/></cfoutput>

</div>
<!-- end catcores/catcore_features_products.cfm -->

