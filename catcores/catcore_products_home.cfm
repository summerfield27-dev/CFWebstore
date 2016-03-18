<!--- CFWebstore, version 6.50 --->

<!--- Default file used for the 'products department home' template page. --->

<!--- This page displays a list of subcategories and the product teaser box. A product search box is displayed at the bottom of the page. The products in the "best sellers" teaser box are the products that are assigned to the category being displayed.  --->

<!-- start catcores/catcore_products_home.cfm -->
<div id="catcoreproductshome" class="catcores">

<cfif request.qry_get_cat.ProdFirst>

	<cfset attributes.type = "product">
	<cfset attributes.box_title="best sellers">
	<cfset fusebox.nextaction="product.tease">
	<cfinclude template="../lbb_runaction.cfm">
	<br/>&nbsp;<br/>
	<div class="header">&nbsp;Departments</div>
	<cfinclude template="../category/dsp_subcats.cfm">
	
<cfelse>

	<cfinclude template="../category/dsp_subcats.cfm">
	<br/>
	<cfset attributes.type = "product">
	<cfset attributes.box_title="best sellers">
	<cfset fusebox.nextaction="product.tease">
	<cfinclude template="../lbb_runaction.cfm">
</cfif>
	
<br/>&nbsp;<br/>
	
	<cfset attributes.listing = "short">
	<cfset fusebox.nextaction="product.productofday">
	<cfinclude template="../lbb_runaction.cfm">
	
<br/>
<cfinclude template="../product/put_search_form.cfm">

</div>
<!-- end catcores/catcore_products_home.cfm -->