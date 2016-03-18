
<!--- CFWebstore, version 6.50 --->

<!--- Outputs the header for the registries listings, called by catcore_registries.cfm and dsp_results.cfm --->

<!--- remove page, sort and from query string ---->
<cfparam name="querystring" default="currentpage=#Val(attributes.currentpage)##addedpath#">

<cfset replacetext = "currentpage=#Val(attributes.currentpage)#&">
	<cfset querystring=Replace(querystring,replacetext,'')>
<cfset replacetext = "&sort=#attributes.sort#">
	<cfset querystring=Replace(querystring,replacetext,'')>
<cfset replacetext = "&order=#attributes.order#">
	<cfset querystring=Replace(querystring,replacetext,'')>
	
<cfset action = "#request.self#?#querystring##Request.Token2#">


<!-- start shopping/giftregistry/dsp_searchheader.cfm -->
<div id="dspgiftsearchheader" class="shopping">

<cfoutput>				
<div class="ResultHead">Your search for '#attributes.name#' returned #qry_Get_registries.recordcount# results:</div>
<br/>
		
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td valign="bottom" height="20" class="section_footer">

	sort by

<cfif attributes.sort is "name" and not len(attributes.order)>
	<a href="#XHTMLFormat('#action#&sort=name&order=DESC')#" class="section_footer"><cfif attributes.sort is "name"><b>name</b><cfelse>name</cfif></a>
   	<cfelse><a href="#XHTMLFormat('#action#&sort=name')#" class="section_footer"><cfif attributes.sort is "name"><b>name</b><cfelse>name</cfif></a></cfif> | 

<cfif attributes.sort is "date" and not len(attributes.order)>
	<a href="#XHTMLFormat('#action#&sort=date&order=DESC')#" class="section_footer"><cfif attributes.sort is "date"><b>date</b><cfelse>date</cfif></a>
   	<cfelse><a href="#XHTMLFormat('#action#&sort=date')#" class="section_footer"><cfif attributes.sort is "date"><b>v</b><cfelse>date</cfif></a></cfif> 
</td></tr>

<cfif len(pt_pagethru)>
<tr><td valign="bottom"  height="20" align="right" class="section_footer">
#pt_pagethru#
</td></tr>
</cfif>

</cfoutput>

</table>

<cfmodule template="../../customtags/putline.cfm" linetype="Thick" width="100%">	

</div>
<!-- end shopping/giftregistry/dsp_searchheader.cfm -->
