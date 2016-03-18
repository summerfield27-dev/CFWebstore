<!--- CFWebstore, version 6.50 --->

<!--- Used to output the listing of accounts. Called by users.directory --->

<cfparam name="attributes.currentpage" default=1>

<!--- Define URL for pagethrough --->
<!--- Include filler variable to be removed for SES links --->
<cfset fieldlist="account_name,rep,directory_live,city,state,country,description,sortby,order">
<cfinclude template="../../includes/act_setpathvars.cfm">

<cfparam name="attributes.displaycount" default= "#Request.AppSettings.maxfeatures#">

<!-- start users/account/dsp_results.cfm -->
<div id="dspresults" class="users">

<cfif qry_get_accounts.recordcount gt 0>

	<!--- Create the page through links, max records set by the display count --->
	<cfmodule template="../../customtags/pagethru.cfm" 
		totalrecords="#qry_get_accounts.recordcount#" 
		currentpage="#attributes.currentpage#"
		templateurl="#thisSelf#"
		addedpath="#XHTMLFormat(addedpath&request.token2)#"
		displaycount="#attributes.displaycount#" 
		imagepath="#Request.ImagePath#icons/" 
		imageheight="12" 
		imagewidth="12"
		hilitecolor="###request.getcolors.mainlink#" >

	<cfinclude template="put_searchheader.cfm">
	<cfinclude template="dsp_accounts.cfm">
	<cfinclude template="put_searchfooter.cfm">
	
<cfelse>

	<!---------------------->
	<cfif isDefined("attributes.submit")>
		<cfoutput>
		<p class="ResultHead">No listings found for #searchheader#. Please try another search...
		<cfmodule template="../../customtags/putline.cfm" linetype="Thick">
		</cfoutput>
	<cfelse>
	
		<cfoutput>
		<p class="resulthead">
		Please enter your search below...
		<cfmodule template="../../customtags/putline.cfm" linetype="thick">
		</cfoutput>
	<!---------------------->
	</cfif>

</cfif>
<p>

</div>
<!-- end users/account/dsp_results.cfm -->
