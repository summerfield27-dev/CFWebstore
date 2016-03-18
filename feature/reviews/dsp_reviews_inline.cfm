<!--- CFWebstore, version 6.50 --->

<!--- This template puts the comments on a Feature detail page. --->

<!-- start feature/reviews/dsp_reviews_inline.cfm -->
<div id="dspreviewsinline" class="feature">

<!--- For link to comments ---->
<cfoutput><a name="reviews"></a></cfoutput>

<!--- Section Title ----------->
<cfmodule template="../../customtags/putline.cfm" linetype="thin"/>

<cfoutput>
<div class="mainpage" style="margin-top:5px;">
<cfset commentlink = "#self#?fuseaction=feature.reviews&do=write&feature_id=#attributes.feature_ID##PCatNoSES##request.token2#">

<span class="section_title">Add Your Opinion</span> - <a href="#XHTMLFormat(commentlink)#" #doMouseover('Comment')#>Post Your Comment Here</a>

<cfif qry_get_reviews.recordcount>
	<p>Explore Comments</p>
<cfelse>
	<p>Be the First to Comment</p>
</cfif>
</div>
</cfoutput> 

<cfinclude template="put_review_tree.cfm">
<br/>
</div>
<!-- end feature/reviews/dsp_reviews_inline.cfm -->