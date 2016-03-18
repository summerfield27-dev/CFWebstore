
<!--- CFWebstore, version 6.50 --->

<!--- This page is used by both features and products to add related products. It lists current related products with links to edit or remove them, and allows the admin to search and select for products to add as related. Called by feature.admin&feature=related_prod and product.admin&do=related --->

<!---
From Features:
<cfset startpath="fuseaction=feature.admin&feature=related_prod&feature_id=#attributes.feature_id#">
<cfset box_title="Update Feature - #qry_get_feature.name#">
<cfparam name = "menu" default="../../../feature/admin/dsp_tab_menu.cfm">

From Products
<cfparam name = "startpath" default="fuseaction=product.admin&do=related&product_id=#attributes.product_id#">
<cfparam name = "box_title" default="Update Product - #qry_get_product.name#">
<cfparam name = "menu" default="dsp_menu.cfm">

---->

<!--- Create the string with the filter parameters --->	
<cfset addedpath="&#startpath#">
<cfset fieldlist="name,sku,display_status,highlight,potd,sale,hot,type,cid,nocat">

<cfinclude template="../../../includes/act_setpathvars.cfm">
	
<cfparam name="currentpage" default="1">
<cfparam name="assoc_text" default="Related">
	
<!--- Set CSRF key check --->
<cfset formkey = CreateUUID()>
<cfset session.formKeys.productRelated = formkey>

<!--- Create the page through links, max records set to 20 --->
<cfmodule template="../../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_products.recordcount#" 
	currentpage="#currentpage#"
	templateurl="#thisSelf#"
	addedpath="#addedpath##request.token2#"
	displaycount="20" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilightcolor="###request.getcolors.mainlink#" 
	>
	
<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="#box_title#"
	Width="700"
	menutabs="yes">
	
	<cfinclude template="#menu#">

<cfoutput>

<cfif qry_get_Product_item.recordcount>
<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext"
style="color:###Request.GetColors.InputTText#">	
	<tr>
		<td class="formtitle" width="20%"><br/>Current&nbsp;#assoc_text#&nbsp;Products</td>
		<td><br/><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="###Request.GetColors.inputHBgcolor#" /></td>
	</tr>	
</table>
<table width="90%" cellspacing="4" border="0" cellpadding="0" class="formtext"style="color:###Request.GetColors.InputTText#">	
	<cfloop query="qry_get_Product_item">
	<tr>
		<td>#name#</td>
		<td>#sku#</td>
		<td>[<a href="#self#?#addedpath#&submit_related=#product_id#&formkey=#Hash(formkey,"SHA-256")##Request.Token2#">remove</a>]
		[<a href="#self#?fuseaction=product.admin&do=edit&product_id=#product_id##Request.Token2#">edit</a>]
		[<a href="#Request.StoreSelf#?fuseaction=product.display&product_id=#product_id##Request.Token2#" target="store">view</a>]
		</td>
	</tr>		
	</cfloop>
</table>

</cfif>	
	
<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext" style="color:###Request.GetColors.InputTText#">	
	<tr>
		<td class="formtitle" width="20%"><br/>Add&nbsp;#assoc_text#&nbsp;Products</td>
		<td><br/><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/></td>
	</tr>	
</table>	

<!-----------Search for more --------------->		
<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext" style="color:###Request.GetColors.InputTText#">	

	<tr>
		<td colspan="9"	align="right">#pt_pagethru#</td>
	</tr>

	<form action="#self#?#startpath##request.token2#" method="post">
	
	<tr>
		<td><span class="formtextsmall"><br/></span>
		<input type="submit" value="Search" class="formbutton"/></td>	
	
		<td><span class="formtextsmall">name<br/></span>
			<input type="text" name="name" size="18" maxlength="25" class="formfield" value="#HTMLEditFormat(attributes.name)#"/></td>				
	
		<td><span class="formtextsmall">sku<br/></span>
			<input type="text" name="sku" size="8" maxlength="25" class="formfield" value="#attributes.sku#"/></td>	
		
		<td><span class="formtextsmall">display<br/></span>
		<select name="display_status" class="formfield">
			<option value="" #doSelected(attributes.display_status,'')#>all</option>
			<option value="off" #doSelected(attributes.display_status,'off')#>off</option>
			<option value="current" #doSelected(attributes.display_status,'current')#>current</option>
			<option value="scheduled" #doSelected(attributes.display_status,'scheduled')#>scheduled</option>
			<option value="expired" #doSelected(attributes.display_status,'expired')#>expired</option>
		</select></td>			
	
		<td><span class="formtextsmall">POTD<br/></span>
		<select name="potd" class="formfield">
		<option value="" #doSelected(attributes.potd,'')#>All</option>
		<option value="0" #doSelected(attributes.potd,1)#>Yes</option>
		<option value="1" #doSelected(attributes.potd,0)#>No</option>
		</select></td>	
		
		<td><span class="formtextsmall">new<br/></span>
		<select name="highlight" class="formfield">
		<option value="" #doSelected(attributes.highlight,'')#>All</option>
		<option value="1" #doSelected(attributes.highlight,1)#>Yes</option>
		<option value="0" #doSelected(attributes.highlight,0)#>No</option>
		</select></td>				
	
		<td><span class="formtextsmall">sale<br/></span>
		<select name="sale" class="formfield">
		<option value="" #doSelected(attributes.sale,'')#>All</option>
		<option value="1" #doSelected(attributes.sale,1)#>Yes</option>
		<option value="0" #doSelected(attributes.sale,0)#>No</option>
		</select></td>	
					
		<td><span class="formtextsmall">hot<br/></span>
		<select name="hot" class="formfield">
		<option value="" #doSelected(attributes.hot,'')#>All</option>
		<option value="1" #doSelected(attributes.hot,1)#>Yes</option>
		<option value="0" #doSelected(attributes.hot,0)#>No</option>
		</select></td>	
		
		<td><span class="formtextsmall">type<br/></span>
		<select name="type" class="formfield">
		<option value="" #doSelected(attributes.type,'')#>All</option>
		<option value="product" #doSelected(attributes.type,'product')#>product</option>
		<option value="membership" #doSelected(attributes.type,'membership')#>membership</option>
		<option value="download" #doSelected(attributes.type,'download')#>download</option>
		<option value="certificate" #doSelected(attributes.type,'certificate')#>certificate</option>
		</select>
		</td>					
		
		<td><br/><a href="#self#?#startpath##Request.Token2#">ALL</a><br/>
		</td></tr>
		</form>

<!---- Category Browse --------->		
	<tr>
		<td colspan="9">
		<cfif attributes.cid is not "">
			in category <cfinclude template="../../../category/admin/dsp_parent_breadcrumb.cfm"><br/>
			<!---- include subcats ---->
			<cfset attributes.parent_ID = attributes.cid>
			<cfset all = 1>
			<cfinclude template="../../../category/qry_get_subcats.cfm">
			<cfinclude template="../../../category/admin/dsp_subcats_breadcrumb.cfm">
		<cfelse>
			<a href="#self#?cid=0#replace(addedpath,'&nocat=1','','ALL')##Request.Token2#">Browse Categories</a>
		</cfif>		
		</td>

		</tr>		
		
		<tr>
			<td colspan="9" style="BACKGROUND-COLOR: ###Request.GetColors.inputHBgcolor#;">
			<img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="1" /></td>
		</tr>

<cfif qry_get_products.recordcount gt 0>					

	<form action="#self#?#addedpath##request.token2#" method="post">
	<input type="hidden" name="formkey" value="#Hash(formkey,"SHA-256")#"/>
	
	<cfloop query="qry_get_products" startrow="#PT_StartRow#" endrow="#PT_EndRow#">
	<cfif not listfind("#valuelist(qry_get_Product_item.product_id)#","#product_id#") AND (NOT isDefined("attributes.product_ID") OR qry_get_products.product_ID IS NOT attributes.product_ID)>
		<tr>
			<td align="center">
			<input type="checkbox" name="add_related" value="#product_id#"/>
			</td>	

		<td><a href="#self#?fuseaction=Product.admin&do=edit&product_ID=#product_id##Request.Token2#">#name#</a></td>		

		<td>#sku#</td>		

		<td><cfif display is 1>Yes<cfelse>No</cfif></td>		

		<td><cfif notsold is 1>No<cfelse>Yes</cfif></td>	
		
		<td><cfif highlight is 1>Yes<cfelse>No</cfif></td>		

		<td><cfif sale is 1>Yes<cfelse>No</cfif></td>		

		<td>#prod_type#</td>		
		
		<td></td>
	</tr>		
	</cfif>
	</cfloop>
	
	</table>
	
	<div align="center"><input type="submit" name="submit_related" value="Add Products" class="formbutton"/></div>
	
	</form>		
			
	<div align="right" class="formtext">#pt_pagethru#</div>
		
	<cfelse>	
	
		<td colspan="9">
		<br/>
		No records selected
		</td>
	</tr>		
	</table>	
	
	</cfif>
	<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext">	
		<tr>
		<td align="center">
<cfif isDefined("attributes.do")>
<form action="#self#?fuseaction=product.admin&do=list&cid=#attributes.cid##request.token2#" method="post">
<cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/>	<br/>	
		<input type="hidden" name="act" value="choose"/>
		<input type="submit" name="DONE" value="Back to Product List" class="formbutton"/></form>	
<cfelseif isDefined("attributes.feature")>
<form action="#self#?fuseaction=feature.admin&feature=list&cid=#attributes.cid##request.token2#" method="post">
<cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/><br/>	
		<input type="hidden" name="act" value="choose"/>
		<input type="submit" name="DONE" value="Back to Feature List" class="formbutton"/></form>	
<cfelseif isDefined("attributes.discount")>
<form action="#self#?fuseaction=product.admin&discount=list#request.token2#" method="post">
<cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/><br/>	
		<input type="submit" name="DONE" value="Back to Discount List" class="formbutton"/></form>	
<cfelseif isDefined("attributes.promotion")>
<form action="#self#?fuseaction=product.admin&promotion=list#request.token2#" method="post">
<cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/><br/>	
		<input type="submit" name="DONE" value="Back to Promotion List" class="formbutton"/></form>	
</cfif>
		</td>
    </tr>
	</table> 
</cfoutput>
<!---- CLOSE MODULE ----->
</cfmodule>

		
