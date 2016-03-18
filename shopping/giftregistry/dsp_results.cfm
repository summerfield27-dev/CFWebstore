
<!--- CFWebstore, version 6.50 --->

<!--- Used to output the listing of gift registries. Called by shopping.giftregistry&do=results --->

<cfparam name="attributes.currentpage" default=1>

<!--- Define URL for pagethrough --->
<cfset fieldlist="do,name,sort,order">
<cfinclude template="../../includes/act_setpathvars.cfm">

<cfparam name="attributes.displaycount" default= "20">

<!--- Create the page through links, max records set by the display count --->
<cfmodule template="../../customtags/pagethru.cfm" 
	totalrecords="#qry_Get_registries.recordcount#" 
	currentpage="#Val(attributes.currentpage)#"
	templateurl="#thisself#"
	addedpath="#XHTMLFormat(addedpath&request.token2)#"
	displaycount="#Val(attributes.displaycount)#" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilitecolor="###request.getcolors.mainlink#" >
	
	
<!-- start shopping/giftregistry/dsp_results.cfm -->
<div id="dspgiftresults" class="shopping">
<cfif qry_Get_registries.recordcount gt 0>

	<cfinclude template="put_searchheader.cfm">
	<cfinclude template="dsp_giftregistries.cfm">
	<cfinclude template="put_searchfooter.cfm">
	
<cfelse>

	<cfoutput>
		<p class="ResultHead">No Gift Registries found. Be sure to enter valid search criteria.	
		<cfmodule template="../../customtags/putline.cfm" linetype="Thick">
		</p>
	</cfoutput>


</cfif>
<p>&nbsp;</p>
<div class="formtitle">Search Again</div>

<cfoutput>
<form name="searchform" method="post"
action="#XHTMLFormat('#request.self#?fuseaction=shopping.giftregistry&do=results#request.Token2#')#" >
<table cellpadding="0" cellspacing="6" class="formtext">
	<tr>
		<td>Name:</td>
		<td><input type="text" name="Name" size="20" maxlength="30" value="" class="formfield"/></td>
		<td>City or State:</td>
		<td><input type="text" name="city" size="20" maxlength="30" value="" class="formfield"/></td>		
  	   	<td><input type="submit" name="frm_submit" value="Search" class="formbutton"/></td>
 	</tr>
</table>
</form>
</cfoutput>

</div>
<!-- end shopping/giftregistry/dsp_results.cfm -->
