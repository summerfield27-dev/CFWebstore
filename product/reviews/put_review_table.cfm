<!--- CFWebstore, version 6.50 --->

<!--- Used to output the list of member reviews, with links to edit|delete. Called from dsp_reviews_table.cfm --->

<cfset reviewlink = "#self#?fuseaction=product.reviews&Review_ID=#Review_ID##request.token2#">

<cfoutput>
<!-- start product/reviews/put_review_table.cfm -->
<div id="putreviewtable" class="product">
	<tr>
		<td valign="top">#LSDateFormat(posted,"mmm d, yyyy")#</td>
		<td valign="top"><a href="#XHTMLFormat('#reviewlink#&do=display')#" #doMouseover('View this product review')#><strong>#title#</strong></a>
		<br/>
		<cfif len(attributes.product_ID)>
			<cfif Anonymous is 1>a member<cfelseif user_ID><a href="#XHTMLFormat('#self#?fuseaction=product.reviews&do=list&uid=#user_ID##request.token2#')#" #doMouseover('Other Reviews by #username#')#><cfif len(anon_name)>#anon_name#<cfelse>#username#</cfif></a><cfelse>#anon_name#</cfif>
			
		<cfelse>On Product: <a href="#XHTMLFormat('#self#?fuseaction=product.display&product_ID=#product_ID##request.token2#')#">#product_Name#</a></cfif>
		
		</td>
		<td valign="top" align="left">
		
		<img src="#Request.ImagePath#icons/#Rating#_med_stars.gif" alt="#Rating# Stars" />
		</td>

		<td valign="top" align="left">
			<cfset HelpfulPercent = Round(helpful*100)>
			#HelpfulPercent#%
			<cfif helpful gte 0.8>
				Very Helpful
			<cfelseif helpful gte 0.6>
				Helpful
			<cfelseif helpful gte 0.4>
				Somewhat Helpful
			<cfelseif helpful gt 0>
				Not Very Helpful
			<cfelse>
				Unranked
			</cfif>
		</td>
		<cfif attributes.do is "manager">
		<cfparam name="attributes.XFA_success" default="fuseaction=product.reviews&do=manager">
		<td valign="top" align="right">
			<!--- Written BY user --->
			<cfif user_id is Session.User_ID>			
			[<a href="#XHTMLFormat('#reviewlink#&do=write&XFA_success=#URLEncodedFormat(attributes.XFA_success)#')#">edit</a>] 
			[<a href="#XHTMLFormat('#reviewlink#&do=delete')#">delete</a>]
			</cfif>
			
		</td>
		</cfif>
	</tr>
</div>
<!-- end product/reviews/put_review_table.cfm -->
</cfoutput>
	