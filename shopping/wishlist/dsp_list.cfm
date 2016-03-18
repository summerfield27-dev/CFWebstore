
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to display the user's wishlist. Called by shopping.wishlist --->

<!----- Set this page for Keep Shopping button ------->
<!--- Don't set if adding a product to the list --->
<cfif NOT isdefined("attributes.product_id")>
	<cfset Session.Page = Request.currentURL>
</cfif>

<cfset Webpage_title = "Wishlist">

<cfparam name="attributes.message" default="">

<!--- Define URL for pagethrough --->
<cfset addedpath="&fuseaction=#attributes.fuseaction#">

<!--- Create the page through links, max records set to 20 --->
<cfmodule template="../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_list.recordcount#" 
	currentpage="#attributes.currentpage#"
	templateurl="#thisSelf#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="20" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >


<!-- start shopping/wishlist/dsp_list.cfm -->
<div id="dsplist" class="shopping">
	
<!--- output listings --->
<cfif NOT qry_get_list.recordcount>
	<cfoutput>
	<div class="formtitle">Currently, there are no items on your wishlist.</div>
	</cfoutput>

<cfelse>	
	<cfoutput><br/>
	<cfif len(attributes.message)>
	<div class="formerror"><b>#attributes.message#</b><br/><br/></div>
	</cfif>
	<form action="#XHTMLFormat('#self#?fuseaction=shopping.wishlist#Request.Token2#')#" method="post">
	<input type="hidden" name="ProdList" value="#ProdList#"/>
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "wishlistEdit">
	<cfinclude template="../../includes/act_add_csrf_key.cfm">
	
	<table cellspacing="2" cellpadding="2" border="0" width="100%" class="formtext">
	<!--- Loop for each product to be output --->
	<cfloop query="qry_get_list" startrow="#pt_StartRow#" endrow="#pt_EndRow#">
	<cfset ImgLink = "#self#?fuseaction=product.display&Product_ID=#product_id##Request.Token2#">
	<tr>
	<!--- If product not in database or not turned on, display error message --->
	<cfif NOT len(Name) OR NOT Display> 
		<td valign="top" width="25">
		<b>#(pt_StartRow+Currentrow-1)#.</b>
		</td>
		<td colspan="2" valign="top" class="caution">This product is no longer available</td>
		<td align="center" valign="top">
		<input type="submit" name="Delete#Product_ID#" value="Delete" class="WishButton"/><br/><br/>
<!--- 		<input type="submit" name="Update" value="Update" class="WishButton"/> --->
		</td>
	<cfelse>
		<td valign="top" width="25">
		<b>#(pt_StartRow+Currentrow-1)#.</b>
		</td>
		<td valign="top">
		<cfif len(Sm_Image)>
			<cfmodule template="../../customtags/putimage.cfm" filename="#Sm_Image#" 
			filealt="#Name#" imglink="#XHTMLFormat(ImgLink)#"  hspace="4" vspace="0" User="#User_ID#" />
		</cfif>
		</td>
		<!--- Output product link and information --->
		<td align="left" valign="top" width="95%">
		<a href="#XHTMLFormat(ImgLink)#" class="prodname" #doMouseover(Name)#>#Name#</a><br/>
		<span class="smalltext"><cfif len(availability)>#availability#<br/></cfif>
		Date Added: #DateFormat(DateAdded, "mmmm d, yyyy")#</span><br/>
		
		<table border="0" width="200" class="FormText">
		<tr><td colspan="2"><cfmodule template="../../customtags/putline.cfm" linetype="thin" /></td></tr>
		<tr>
		<td>Desired:</td>
		<td> <input type="text" name="NumDesired#Product_ID#" size="3" value="#NumDesired#" maxlength="5" class="formfield"/>
		</td></tr> 
		<tr>
		<td>Comment: </td><td>
		<input type="text" name="Comment#Product_ID#" size="25" maxlength="255" value="#HTMLEditFormat(Comments)#" class="formfield"/>
		</td></tr></table>
		</td>
		<td align="center" valign="middle">
		<input type="submit" name="Delete#Product_ID#" value="Delete" class="WishButton"/><br/><br/>
		<input type="submit" name="Update" value="Update" class="WishButton"/>
		</td>

	</cfif>

	</tr>
	<cfif CurrentRow is NOT pt_EndRow>
	<tr><td colspan="4">
	<cfmodule template="../../customtags/putline.cfm" linetype="Thin" />
	</td></tr>
	</cfif>
	</cfloop>

<cfif isdefined("attributes.product_id")>
	<tr><td colspan="2" align="center"><br/><br/>
	<input type="button" name="Continue" value="Continue Shopping" class="WishButton" onclick="location.href='#Session.Page#&amp;redirect=yes'" />
	</td></tr>
</cfif>

	</table>
	</form>
	</cfoutput>
</cfif>

<cfoutput><div align="center">#pt_pagethru#</div><br/></cfoutput>

</div>
<!-- end shopping/wishlist/dsp_list.cfm -->

