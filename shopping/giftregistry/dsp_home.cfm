
<!--- CFWebstore, version 6.50 --->

<!--- This template is used as the default Gift Registry Page. Called by shopping.giftregistry. --->

<cfset action = "#request.self#?fuseaction=shopping.giftregistry#request.Token2#">

<!-- start shopping/giftregistry/dsp_registry_home.cfm -->
<div id="dspregistryhome" class="shopping">

<cfmodule template="../../customtags/puttitle.cfm"
titletext="Give a Gift" class="cat_title_large">


<br/>
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="3" class="mainpage">
	<tr>
		<td valign="top">
		
		<span class="formtitle">Locate a Registry</span>
		<br/>
	<form name="searchform" action="#XHTMLFormat('#action#&do=results')#" method="post">
	<table cellpadding="0" cellspacing="10" class="mainpage">
			<tr>
				<td>By Name<br/>
				<input type="text" name="Name"  size="20" maxlength="50" value="" class="formfield"/></td>
			</tr>
			<tr>
				<td>By City or State<br/>
				<input type="text" name="City"  size="20" maxlength="100" value="" class="formfield"/></td>
			</tr>			
			<tr>
				<td>OR Registry Number<br/>
				<input type="text" name="GiftRegistry_ID"  size="20" maxlength="20" value="" class="formfield"/></td>
			</tr>
			<tr>
  		     	<td><input type="submit" name="frm_submit" value="Search" class="formbutton"/></td>
 			</tr>
		</table>
		</form>
		
		</td>
		
		<td bgcolor="###request.GetColors.linecolor#">
		<img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="1" /></td>
		<td><img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="8" /></td>

		<td valign="top">
		<span class="formtitle">Create</span><br/><br/>
		<a href="#XHTMLFormat('#action#&manage=add')#">Sign up and choose gifts.</a> 
		</td>
		
		<td bgcolor="###request.GetColors.linecolor#">
		<img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="1" /></td>
		<td><img src="#Request.ImagePath#spacer.gif" alt="" height="1" width="8" /></td>

		<td valign="top">			
		<span class="formtitle">Edit</span><br/><br/>
		<a href="#XHTMLFormat('#action#&manage=list')#">Check in, update and add gifts.</a> 
		</td>
	</tr>
</table>

</cfoutput>

</div>
<!-- end shopping/giftregistry/dsp_registry_home.cfm -->