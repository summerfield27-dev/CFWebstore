
<!--- CFWebstore, version 6.50 --->

<!--- Outputs a header for feature listing pages. Displays links for subcategories and the results of the search --->

<!-- start feature/put_searchheader.cfm -->
<div id="putsearchheader" class="feature">

<!--- Output search header --->
<cfif isdefined("request.qry_get_subcats.recordcount") and request.qry_get_subcats.recordcount>

	<cfinclude template="../category/dsp_subcats_directory.cfm">

<cfelseif len(searchheader)>
	
	<cfoutput>
	<p class="ResultHead">#qry_Get_features.recordcount# listings in #searchheader#</p>
	</cfoutput>
	
</cfif>

<cfif numlist gt 0 and attributes.thickline>
<cfmodule template="../customtags/putline.cfm" linetype="Thick">
</cfif>

</div>
<!-- end feature/put_searchheader.cfm -->
