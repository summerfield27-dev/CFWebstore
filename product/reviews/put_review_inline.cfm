<!--- CFWebstore, version 6.50 --->

<!--- This Product Review format is called by dsp_reviews_inline.cfm and is used on the Product Detail page. It does not include the Product's name and photo. --->

<cfoutput>
<!-- start product/reviews/put_review_inline.cfm -->
<div id="putreviewinline" class="product">
	<table width="100%" class="mainpage" cellpadding="5" cellspacing="0">
		<cfif Helpful_Total>
		<tr>
			<td colspan="2">#Helpful_Yes# of #Helpful_Total# found the following review helpful:</td>
		</tr>
		</cfif>
		<tr>
			<td valign="top" width="70"><img src="#Request.ImagePath#icons/#Rating#_med_stars.gif" alt="#Rating# Stars" border="0" /></td>
			<td width="88%"><strong>#HTMLEditFormat(Title)#</strong><br/>
			by <cfif Anonymous is 1>a member<cfelseif user_ID><a href="#XHTMLFormat('#self#?fuseaction=product.reviews&do=list&uid=#user_ID##request.token2#')#" #doMouseover('Other Reviews by #username#')#><cfif len(anon_name)>#anon_name#<cfelse>#username#</cfif></a><cfelse>#anon_name#</cfif>
			<cfif len(Anon_Loc)>from #Anon_Loc#</cfif> on #dateformat(Posted,"mmm d, yyyy")#
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>#HTMLEditFormat(comment)#</td>
		</tr>		
		<tr>
			<td colspan="2">
			<cfif user_ID IS NOT Session.User_ID>
			<cfset ratelink = "#self#?fuseaction=product.reviews&do=rate&Review_ID=#Review_ID#&product_ID=#product_ID#">
			
			Was this review helpful to you? <a href="#XHTMLFormat('#ratelink#&rate=1#request.token2#')#" #doMouseover('Click to Vote Yes')#>Yes</a> 
			<a href="#XHTMLFormat('#ratelink#&rate=0#request.token2#')#" #doMouseover('Click to Vote No')#>No</a>
			<cfelse>
			<!--- You cannot rate this review, since you wrote it.  --->
			</cfif>
			<!--- An optional link to allow users to flag a review for editorial review.
			<br/><a href="#self#?fuseaction=product.reviews&do=flag&Review_ID=#Review_ID##request.token2#">Flag for Editor Review</a>  --->
			</td>
		</tr>
	</table>
	<cfinclude template="put_admin_menu.cfm">
	</div>
	<!-- end product/reviews/put_review_inline.cfm -->
</cfoutput>	
