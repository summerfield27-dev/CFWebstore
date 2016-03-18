<!--- CFWebstore, version 6.50 --->

<!--- This template is called by review.display and displays the selected comment plus the full comment tree of the Feature below. --->

<cfset itemlist = valuelist(qry_get_reviews.Review_ID)>
<cfset itemindex = listfind(valuelist(qry_get_reviews.Review_ID),qry_get_review.Review_ID)>

<!--- Required for pop-up mail form --->
<cfhtmlhead text="<script type='text/javascript' src='#Request.StorePath#includes/openwin.js'></script>">

<!-- start feature/reviews/dsp_review.cfm -->
<div id="dspreview" class="feature">

<!--- Provide a Page Title --->
<cfset Webpage_title = "Your Opinion">
<cfmodule template="../../customtags/puttitle.cfm" TitleText="Your Opinion" class="feature">

<!----- Set this page for Keep Shopping button ------->
<cfset Session.Page = Request.currentURL>

<cfoutput query="qry_get_review">
<div class="review_title">#HTMLEditFormat(Title)#</div>
<div class="mainpage">
Posted By: <cfif Anonymous is 1>Anonymous<cfelseif user_ID><a href="#XHTMLFormat('#self#?fuseaction=feature.reviews&do=list&uid=#user_ID##Request.Token2#')#" #doMouseover('Other Reviews by #username#')#><cfif len(anon_name)>#anon_name#<cfelse>#username#</cfif></a><cfelse>#anon_name#</cfif><br/>
Date: #dateformat(Posted,"mmm d, yyyy")#, #timeformat(Posted,"h:mm tt")#<br/>
About: <a href="#XHTMLFormat(featurelink)#" #doMouseover('Read Article')#><strong>#GetDetail.Name#</strong></a><br/>
</div>

<br/>
<cfmodule template="../../customtags/puttext.cfm" Text="#HTMLEditFormat(comment)#" Token="#Request.Token1#" ptag="yes" class="mainpage">

<cfset reviewlink = "#self#?fuseaction=feature.reviews&feature_ID=#feature_ID#">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="mainpage">
	<tr>
		<td colspan="2" height="25">
		<a href="#XHTMLFormat('#reviewlink#&do=write#PCatNoSES##request.token2#')#" #doMouseover('Leave a Comment')#><strong>Comment on this Story</strong></a> | <a href="#XHTMLFormat('#reviewlink#&do=write&parent_ID=#Review_ID##PCatNoSES##request.token2#')#" #doMouseover('Reply to Comment')#><strong>Reply to this Comment</strong></a>
		</td>
		<td align="right"><a href="javascript:newWindow=openWin('#XHTMLFormat("#self#?fuseaction=home.email&mailto=editor&page=#self#?#cgi.query_string#")#','Email','width=600,height=450,toolbar=0,location=0,directories=0,status=0,menuBar=0,scrollBars=1,resizable=1'); newWindow.focus()" #doMouseover('Report a Comment')#>Alert Us</a>	</td>
	</tr>
	<tr><td height="1" colspan="3" bgcolor="###request.getcolors.linecolor#">
	<img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="1" /></td></tr>

	<cfif listlen(itemlist) gt 1>
		<cfif itemindex is listlen(itemlist)>
			<cfset nextitem = listgetat(itemlist, 1)>
		<cfelse>
			<cfset nextitem = listgetat(itemlist, itemindex + 1)>
		</cfif>
			
		<cfif itemindex is 1>
			<cfset previtem = listgetat(itemlist, listlen(itemlist))>
		<cfelse>
			<cfset previtem = listgetat(itemlist, itemindex - 1)>
		</cfif>
	<tr>
		<td width="40%" height="25">
		<img src="#Request.ImagePath#icons/left.gif" border="0" alt="" hspace="2" vspace="0" /> <a href="#XHTMLFormat('#reviewlink#&do=display&Review_ID=#previtem##PCatNoSES##Request.Token2#')#" #doMouseover('Previous')#>Previous Comment</a> </td>
		<td width="20%" align="center">#qry_get_reviews.recordcount# Comments
		</td>
		<td width="40%" align="right"><a href="#XHTMLFormat('#reviewlink#&do=display&Review_ID=#nextitem##PCatNoSES##Request.Token2#')#" #doMouseover('Next')#>Next Comment</a> <img src="#Request.ImagePath#icons/right.gif" border="0"alt="" hspace="2" vspace="0" /></td>
	</tr>	
	</cfif>

</table>

</cfoutput>

<cfinclude template="put_admin_menu.cfm">

<br/>
<!--- Expanded Comment Tree ---> 
<cfoutput><p>Read the Story: <strong><a href="#XHTMLFormat(featurelink)#" #doMouseover('Read Article')#>#GetDetail.Name#</a></strong> &nbsp;&nbsp;[<a href="#XHTMLFormat('#reviewlink#&do=write#PCatNoSES##request.token2#')#" #doMouseover('Make a Comment')#>Make A Comment</a>]</p></cfoutput>


<cfset attributes.CurrentReview = attributes.Review_ID>
<cfset attributes.ExpandTree="1">
<cfinclude template="put_review_tree.cfm">	

</div>
<!-- end feature/reviews/dsp_review.cfm -->

