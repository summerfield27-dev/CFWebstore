<!--- CFWebstore, version 6.50 --->

<!--- Displays information for a user on how to create their affiliate links to the store. Called by shopping.affiliate&do=links --->
<cfmodule template="../../access/secure.cfm"
  keyname="users"
  requiredPermission="1"
  dsp_login_Required=""
 > 
<cfif ispermitted>   
	<cfparam name="attributes.uid" default="#Session.User_ID#">
<!--- If not permitted to see other people's order, force user ID to session user ID --->
<cfelse>
 	<cfset attributes.uid = Session.User_ID>	
</cfif>		

<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT A.AffCode, U.User_ID 
	FROM #Request.DB_Prefix#Affiliates A, #Request.DB_Prefix#Users U
	WHERE A.Affiliate_ID = U.Affiliate_ID
	AND U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
</cfquery>


<!-- start shopping/affiliate/dsp_aff_links.cfm -->
<div id="dspafflinks" class="shopping">

<cfmodule template="../../customtags/format_box.cfm"
	box_title="Affiliate Center"
	border="1"
	align="left"
	float="center"
	Width="650"
	HBgcolor="#Request.GetColors.InputHBGCOLOR#"
	Htext="#Request.GetColors.InputHtext#"
	TBgcolor="#Request.GetColors.InputTBgcolor#">

	
	<cfinclude template="dsp_menu.cfm">
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"
	style="color:###Request.GetColors.InputTText#" ></cfoutput>
	
		<tr>
			<td align="center" class="formtitle">
				<p>Creating Affiliate Links to Our Site</p>
			</td>
		</tr>
		
		<tr>
			<td>
<blockquote>
 <cfoutput>
<p>It is essential that the links you put on your site to our store be formatted properly in order to get credit for your referrals. This page will give you examples of links that you can cut and paste into your own web pages.</p>

<p><strong>Your Affiliate ID is #GetInfo.AffCode#</strong>. It is critical that any link to our site have "aff=#GetInfo.AffCode#" attached to the end. This code is how we know that it was you who referred the customer to our store.</p>

<p>To refer users to the "front door" of our store, use the following link:</p>

<p align="center"><b>#Request.StoreSelf#?aff=#GetInfo.AffCode#</b></p>

<p>You can create a link to any page of our web site by simply copying and pasting the page's URL and adding "&amp;aff=#GetInfo.AffCode#" to the end.</p>

<p>If the page you are linking to ends in a ".cfm", use a "?aff=#GetInfo.AffCode#" on the end instead.</p>


<p>To create a link to a specific product we sell, or a specific category of products, you would:</p>

<ol>
<li>Navigate to the place on our site (product or category page) where you want to link.</li>
<li>Copy the URL from the window at the top of your browser.</li>
<li>Remove any session information if present on the URL (CFID, CFTOKEN and/or JSESSIONID).</li>
<li>Append your affiliate ID to the URL you just copied as described above.</li>
</ol>

<p>That's it! If you have any questions about how to make links, don't hesitate to get in touch with us.</p>

</cfoutput>
</blockquote>
	
			</td>
		</tr>
		<tr>
			<td align="center">
				<cfoutput><form action="#XHTMLFormat('#Request.SecureSelf#?fuseaction=users.manager#Request.AddToken#')#" method="post" class="margins"></cfoutput>
				<input type="submit" name="Action" value="Back to My Account" class="formbutton" />
				</form>
			</td>
		</tr>
	
	</table>

</cfmodule>

</div>
<!-- end shopping/affiliate/dsp_aff_links.cfm -->
