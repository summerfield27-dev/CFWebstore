<!--- CFWebstore, version 6.50 --->

<!--- This template calculates the page-through for reveiw listings. --->

<cfparam name="attributes.currentpage" default="1">
<cfparam name="attributes.displaycount" default="10">

<!--- Set this page as the session.page for "helpful" and "flag" processing ---->
<cfset Session.Page = Request.currentURL>

<!--- Define URL for pagethrough --->
<cfset fieldlist="do,product_ID,UID,sortby,order,recent_days,format,editorial">
<cfinclude template="../../includes/act_setpathvars.cfm">

<!--- Create the page through links, max records set by the display count --->	
<cfmodule template="../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_reviews.recordcount#" 
	currentpage="#Val(attributes.currentpage)#"
	templateurl="#thisSelf#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="#Val(attributes.displaycount)#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#">

<!-- start product/reviews/dsp_reviews_list.cfm -->
<div id="dspreviewslist" class="product">
<!--- Include the header information --->
<cfinclude template="put_search_header.cfm">

<cfmodule template="../../customtags/putline.cfm" linetype="thick"/>


<!--- If sort is NEWEST, group output by Editorial ---->
<cfif attributes.sortby is "newest">

	<cfoutput query="qry_get_reviews" group="editorial"  startrow="#pt_StartRow#" maxrows="#attributes.displaycount#">

		<cfif len(editorial)><!--- Staff & Spotlight Review Header --->
			<div class="section_title">#Editorial#  Reviews</div><br/>
		<cfelse><!--- Customer Review Header --->
			<div class="section_title">Customer Reviews</div><br/>
		</cfif>
	
		<!--- Output Review --->
		<cfoutput>
			<cfinclude template="put_review_inline.cfm">
			<cfmodule template="../../customtags/putline.cfm" linetype="Thin"/>
		</cfoutput>
	
	</cfoutput>
	
<cfelse><!--- Ungrouped output when sort is not Newest --->

	<cfloop query="qry_get_reviews" startrow="#pt_StartRow#" endrow="#pt_EndRow#">
		<cfinclude template="put_review_inline.cfm">
		<cfmodule template="../../customtags/putline.cfm" linetype="Thin"/>
	</cfloop>
	
</cfif><!--- Grouped or ungrouped --->


<cfoutput><div align="right">#pt_pagethru#</div><br/></cfoutput>

</div>
<!-- end product/reviews/dsp_reviews_list.cfm -->

