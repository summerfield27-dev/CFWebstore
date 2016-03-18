<!--- CFWebstore, version 6.50 --->

<!--- This template is used to create a slideshow of images when more than one image is listed in the lg_image field.

Before including this page

1) CHECK <cfif listlen(qry_get_products.Lg_Image) is 1>
2) <cfset Lg_Images=qry_get_products.Lg_Image>
---->	

<!--- if the product is created by a specific user, add the subdirectory --->
<cfif qry_get_products.User_ID IS NOT 0>
	<cfset subdir = "User#qry_get_products.User_ID#/">
<cfelse>
	<cfset subdir = "">
</cfif>


<cfoutput>
<!-- start product/listings/lg_image_slideshow.cfm -->
<script type="text/javascript">
<!--
var Picture = new Array();
<cfloop index="ii" list="#Lg_Images#">
Picture[#listfind(Lg_Images,ii)#] = '#Request.ImagePath##subdir##ii#';
</cfloop>

var tss;
var iss;
var jss = 1;
var pss = Picture.length-1;

var preLoad = new Array();
for (iss = 1; iss < pss+1; iss++){
preLoad[iss] = new Image();
preLoad[iss].src = Picture[iss];}

function control(how){
if (how=="F") jss = jss + 1;
if (jss > (pss)) jss=1;
if (jss < 1) jss = pss;
if (document.all){
document.images.Lg_Image.style.filter="blendTrans(duration=1)";
document.images.Lg_Image.filters.blendTrans.Apply();}
document.images.Lg_Image.src = preLoad[jss].src;
if (document.all) document.images.Lg_Image.filters.blendTrans.Play();
}
//-->
</script>
	<a href="javascript:control('F');"><img src="#Request.ImagePath##subdir##listfirst(qry_get_products.Lg_Image)#" name="Lg_Image" border="0" alt="#qry_get_products.Name#" /></a>
<!-- end product/listings/lg_image_slideshow.cfm -->
</cfoutput>