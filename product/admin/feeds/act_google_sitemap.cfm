<!--- CFWebstore, version 6.50 --->

<!--- get queries --->
<cfset attributes.sort = "sitemap">
<cfinclude template="../../../category/qry_get_allcats.cfm">
<cfinclude template="../../../product/queries/qry_get_products.cfm">
<cfinclude template="../../../feature/qry_get_features.cfm">

<!--- Set file path --->
<cfset FilePath = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
<cfset theFile = "#FilePath#sitemap.xml">

<!--- actual content --->
<cfsavecontent variable="sitemap"><?xml version="1.0" encoding="UTF-8" ?> 
<urlset xmlns="http://www.google.com/schemas/sitemap/0.84">
 <url>
 <cfoutput>
  <loc>#Request.StoreSelf#</loc> 
  <lastmod>#dateformat(now(), "yyyy-mm-dd")#</lastmod> 
  </cfoutput>
  </url>

<!---- LIST CATEGORIES ------------------------------>
<cfoutput query="qry_get_allcats">
<url>
    <loc>#Request.StoreSelf#/category/#Category_ID#/#SESFile(Name)#</loc>
    <lastmod>#dateformat(now(), "yyyy-mm-dd")#</lastmod>
  </url>
</cfoutput>
  
<!---- LIST PRODUCTS  ----------------------------------->
<cfoutput query="qry_Get_Products">
<url>
    <loc>#Request.StoreSelf#/product/#product_id#/#SESFile(Name)#</loc>
    <lastmod>#dateformat(now(), "yyyy-mm-dd")#</lastmod>
  </url>
</cfoutput>


<!---- LIST FEATURES  ---------------------------------->
<cfoutput query="qry_Get_features">
<url>
    <loc>#Request.StoreSelf#/feature/#feature_id#/#SESFile(Name)#</loc>
    <lastmod>#dateformat(now(), "yyyy-mm-dd")#</lastmod>
  </url>
</cfoutput>

</urlset>
</cfsavecontent>

<!--- create, save to file --->
<cffile action="WRITE" file="#theFile#" output="#sitemap#" nameconflict="OVERWRITE" addnewline="Yes">

<!--- Send down to the user --->
<cfheader name="Content-Disposition" value="attachment; filename=sitemap.xml">
<cfcontent type="text/plain" file="#theFile#" deletefile="No" reset="No">