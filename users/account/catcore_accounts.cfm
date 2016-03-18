<!--- CFWebstore, version 6.50 --->

<!--- This is the default file used for the 'account directory' page template --->

<!--- 
account_name,rep,directory_live,city,state,country,description
sort,order
displaycount
accountCols
--->
<cfparam name="attributes.thickline" default="1">
<cfparam name="attributes.thinline" default="1">

<cfinclude template="qry_get_accounts.cfm">

<!--- Define URL for pagethrough --->
<cfset fieldlist="account_name,rep,directory_live,city,state,country,description,sortby,order">
<cfset IDlist = "category_id,page_id">
<cfinclude template="../../includes/act_setstorepath.cfm">

<cfparam name="attributes.displaycount" default= "#Request.AppSettings.maxfeatures#">

<!--- Create the page through links, max records set by the display count --->
<cfmodule template="../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_accounts.recordcount#" 
	currentpage="#attributes.currentpage#"
	templateurl="#templatepath#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="#attributes.displaycount#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >
	

<!-- start users/account/catcore_accounts.cfm -->
<div id="catcoreaccounts" class="users">
	
<cfif isDefined("attributes.category_id")>		
<cfif request.qry_get_cat.ProdFirst>
	<!------->
	<cfinclude template="put_searchheader.cfm"> 
	<cfinclude template="dsp_accounts.cfm">
	<cfinclude template="put_searchfooter.cfm">
	
	<cfinclude template="../../category/dsp_subcats_directory.cfm">

<cfelse>
	
	<cfif request.qry_get_subcats.recordcount>
		<cfinclude template="../../category/dsp_subcats_directory.cfm">
		<br/>
	</cfif>

	<!------->
	<cfinclude template="put_searchheader.cfm"> 
	<cfinclude template="dsp_accounts.cfm">
	<cfinclude template="put_searchfooter.cfm">
</cfif>

<cfelse>
	<cfinclude template="put_searchheader.cfm"> 
	<cfinclude template="dsp_accounts.cfm">
	<cfinclude template="put_searchfooter.cfm">
</cfif>
	
</div>
<!-- end users/account/catcore_accounts.cfm -->
