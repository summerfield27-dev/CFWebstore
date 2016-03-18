<!--- CFWebstore, version 6.50 --->

<!--- Confirm delete of a feature review. Called by fuseaction=feature.reviews&do=delete --->
	
<!-- start feature/reviews/dsp_delete.cfm -->
<div id="dspdelete" class="feature">

<p>&nbsp;</p>
	
<cfmodule template="../../customtags/format_input_form.cfm"
	box_title="Delete Article Comment"
	width="400"
	required_fields="0"
	align="center"
	>
	
	<tr><td align="center">
		<br/>This will permanently remove your article comment!<br/>Are you sure you want to continue?<br/>
	</td></tr>

	<tr><td align="center">		
	<cfoutput>
	<form action="#XHTMLFormat('#self#?fuseaction=feature.reviews&do=update&delete=#Review_ID##request.token2#')#" method="post" class="margins">
	<input type="hidden" name="XFA_success" value="fuseaction=feature.reviews&do=manager">
	<input type="hidden" name="Feature_ID" value="#qry_get_review.Feature_ID#">
	<cfset keyname = "featReviewEdit">
	<cfinclude template="../../includes/act_add_csrf_key.cfm">
	
	<input type="submit" name="submit_delete" value="  Yes  " class="formbutton"/> 
	<input type="submit" name="submit_cancel" value="  No  " class="formbutton"/> 
	</form>
	</td></tr>	
	</cfoutput>

</cfmodule>	

</div>
<!-- end feature/reviews/dsp_delete.cfm -->