
<!--- CFWebstore, version 6.50 --->

<!--- Called from dsp_products.cfm and other various pages that output product listings. This outputs a short product listing with just the teaser image and text, no orderbox.  --->

<cfset Product_ID = qry_get_products.Product_ID>
<cfinclude template="do_prodlinks.cfm">

<cfparam name="attributes.showicons" default="1">

<!-- start product/listings/put_short.cfm -->
<div id="putshort" class="product">

<!--- Output product's name and description --->
<cfoutput>
<table border="0" width="100%" cellspacing="0" cellpadding="0" class="mainpage">
<tr>

<td valign="top">

<!--- If there's a small image, get image info and put image in first cell of table row --->	
<cfif len(Sm_Image)>
	<cfmodule template="../../customtags/putimage.cfm" filename="#Sm_Image#" filealt="#Name#" imglink="#XHTMLFormat(prodlink)#" imgclass="listingimg" User="#qry_get_products.User_ID#">
</cfif>

</td><td align="left" valign="top" width="90%">
<a name="Prod#Product_ID#"></a>

<cfif len(Sm_Title)>
	<cfmodule template="../../customtags/putimage.cfm" filename="#Sm_Title#" imglink="#XHTMLFormat(prodlink)#" filealt="#Name#" User="#qry_get_products.User_ID#">
<cfelse>
	<h2 class="product"><a href="#XHTMLFormat(prodlink)#" #doMouseover(Name)#>#Name#</a></h2> &nbsp;
</cfif>

<cfif Sale AND attributes.showicons>#request.SaleImage#</cfif> 
<cfif Highlight AND attributes.showicons>#request.NewImage#</cfif>
<cfif Hot AND attributes.showicons>#request.HotImage#</cfif>
<br/>

<!--- Check for short description --->
<cfif len(Short_Desc)>
	<cfmodule template="../../customtags/puttext.cfm" Text="#Short_Desc#" Token="#Request.Token1#" ptag="no" class="cat_text_small">

	<cfif len(Long_Desc) OR len(Lg_Image)>
	<a href="#XHTMLFormat(prodlink)#" class="cat_text_small">More...</a><br/>
	</cfif>

	<cfif ShowPrice>
		<!--- Uncomment this section to show the base user price for the item
			<cfset AllPrices = "no">
			<cfinclude template="../queries/qry_get_prod_info.cfm">
			<cfinclude template="put_price.cfm">
			<br/> --->
	</cfif>


</cfif>

</td>

</tr></table>
</cfoutput>

</div>
<!-- end product/listings/put_short.cfm -->
