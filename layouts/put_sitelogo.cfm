
<!--- CFWebstore, version 6.50 --->

<!--- Used to output the site logo or title on the page. Call from your layout pages --->
 
<!--- Site logo or title --->			

<!-- start layouts/put_sitelogo.cfm -->
<div id="putsitelogo" class="layouts">
<cfif len(request.appsettings.sitelogo)>
  	<cfmodule template="../customtags/putimage.cfm" fileName="#request.appsettings.sitelogo#" filealt="Home" imglink="#Request.StoreSelf##Request.Token1#">
<cfelse>
	<cfoutput><a href="#Request.StoreSelf##Request.Token1#" #doMouseover('Home')# alt="Home" id="siteName">#request.AppSettings.siteName#</a></cfoutput>
</cfif>
</div>
<!-- end layouts/put_sitelogo.cfm -->		
			
			