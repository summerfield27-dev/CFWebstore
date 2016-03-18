<!--- CFWebstore, version 6.50 --->


<!-----
This template puts the PRODUCT IMAGES into the products detail page. Called from dsp_product.cfm

Attributes: 
	Product_ID 		= Product_ID
	gallery			= User_images.gallery 	- Private | Public
------>

<cfparam name="attributes.Product_ID" default="">
<cfparam name="attributes.gallery" default="">
<cfparam name="attributes.Prod_User" default="0">

<cfset dirBase = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
<cfset self=caller.self>

<!--- if the product is created by a specific user, add the subdirectory --->
<cfif attributes.Prod_User IS NOT 0>
	<cfset subdir = "User#attributes.Prod_User#/">
<cfelse>
	<cfset subdir = "">
</cfif>

<!--- Get Images ---->

<cfquery name="qry_Get_photos" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT *
	FROM #Request.DB_Prefix#Product_Images
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	<cfif attributes.gallery is not "">
		AND Gallery = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.gallery#">
	</cfif>
	ORDER BY Priority
</cfquery>


<cfif qry_get_photos.recordcount>

	<!-- start product/put_pics/put_gallery.cfm -->
	<div id="putgallery" class="product">

	<cfparam name="attributes.SectionTitle" default="#attributes.gallery# Gallery">

	<cfif len(attributes.SectionTitle)>
		<cfmodule template="../../customtags/putline.cfm" linetype="thin">
				
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<cfoutput>
		<tr>
			<td class="section_title">#attributes.SectionTitle#</td>
			<td align="right" class="FormTextVerySmall">(click photo to enlarge)</td>
		</tr>
		<tr><td colspan="2"><img src="#Request.ImagePath#spacer.gif" height="10" alt="" /></td></tr>
		</cfoutput>
		</table>

	</cfif>


<cfloop query="qry_get_photos">
	
	<!--- Check for subdirectory --->
	<cfif ListLen(image_file,"/") GT 1>
		<cfset imagename = ListLast(image_file,"/")>
		<cfset smimagename = ListSetat(image_file, ListLen(image_file,"/"), "sm_#imagename#", "/")>
	<cfelse>
		<cfset smimagename = "sm_#image_file#">
	</cfif>

	<cfoutput><a href="#Request.ImagePath##subdir#products/#image_file#" rel="thumbnail" title="#Caption#" onmouseover=" window.status='Click to open picture in new window'; return true" onmouseout="window.status=' '; return true"><img src="#Request.ImagePath##subdir#products/#smimagename#" alt="" border="0" class="gallery_img" /></a></cfoutput>

</cfloop>
<br/><br/>
	</div>
	<!-- end product/put_pics/put_gallery.cfm -->
</cfif><!--- recordcount --->