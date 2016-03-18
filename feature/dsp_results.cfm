
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to list the results of a feature search. Called by feature.list and feature.search --->

<!--- This template is called by the index page and outputs feature listings. --->
<cfparam name="attributes.searchform" default="1">
<cfparam name="attributes.searchfooter" default="1">
<cfparam name="attributes.thickline" default="1">
<cfparam name="attributes.thinline" default="1">
<!--- switch to show the feature_type above name --->
<cfparam name="attributes.showType" default="0">

<!--- Define URL for pagethrough --->
<cfset fieldlist = "category_id,sort,search_string,title,all_words,displaycount">
<cfinclude template="../includes/act_setpathvars.cfm">

<cfset numlist = numlist + qry_get_features.recordcount>

<cfparam name="attributes.displaycount" default="#Request.AppSettings.maxfeatures#">

<!--- Create the page through links, max records set by the display count --->	
<cfmodule template="../customtags/pagethru.cfm" 
	totalrecords="#numlist#" 
	currentpage="#Val(attributes.currentpage)#"
	templateurl="#self#"
	addedpath="#addedpath##request.token2#"
	displaycount="#Val(attributes.displaycount)#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >
	
<!-- start feature/dsp_results.cfm -->
<div id="dspresults" class="feature">

<cfif qry_get_Features.recordcount gt 0>

	<cfif attributes.searchfooter>
		<cfinclude template="put_searchheader.cfm">
		<cfinclude template="dsp_features.cfm">
		<cfinclude template="put_searchfooter.cfm">
	<cfelse>
		<cfinclude template="dsp_features.cfm">
	</cfif>
<cfelse>

	<cfoutput>
	<cfif isdefined("request.qry_get_subcats.recordcount") and request.qry_get_subcats.recordcount IS NOT 0>
		<cfif attributes.searchfooter is "1">
			<p class="ResultHead">Select a category to browse.
		</cfif>
	<cfelseif trim(searchheader) is not "<b>all articles</b>">
		<p class="ResultHead">No listings found for #searchheader#. 
		<cfif attributes.searchform><br/><br/>Please try another search...</cfif></p> 
	<cfelseif attributes.searchform>
		<p class="ResultHead">Please enter your search below...</p>
	</cfif>
	</cfoutput>

</cfif>

<cfif attributes.searchform is "1">
	<cfinclude template="put_search_form.cfm">
</cfif>	

</div>
<!-- end feature/dsp_results.cfm -->
