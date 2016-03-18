<!--- CFWebstore, version 6.50 --->

<!--- Custom tag used to create a styled box for displaying items. Use the attributes below to control the look and style of your box as well as the title displayed  --->

<!--- Attributes --->
<cfparam name="attributes.box_title" default="Featured Items">
<cfparam name="attributes.width" default="100%">
<cfparam name="attributes.border" default="2">
<cfparam name="attributes.align" default="center">
<cfparam name="attributes.HBgcolor" default="#Request.GetColors.BoxHBgcolor#">
<cfparam name="attributes.HText" default="#Request.GetColors.BoxHText#">
<cfparam name="attributes.TBgcolor" default="#Request.GetColors.BoxTBgcolor#">
<cfparam name="attributes.TText" default="#Request.GetColors.BoxTText#">
<cfparam name="attributes.more" default="">
<cfparam name="attributes.float" default="left">
<cfparam name="attributes.title_image" default="">

<!--- START --------------------------------------------------------->
<cfif thistag.ExecutionMode is "Start">

<cfoutput>
	<!-- start customtags/format_box.cfm (start tag) -->
	<div id="formatbox" class="customtags">
	
	<cfif attributes.border>
		<table width="#attributes.width#" cellspacing="0" border="0" cellpadding="#attributes.border#" bgcolor="###attributes.HBgColor#" <cfif len(attributes.float)>align="#attributes.float#"</cfif>>
			<tr>
				<td>
		<cfset innerwidth = "100%">
	<cfelse>
		<cfset innerwidth = attributes.width>
	</cfif>

	<table width="#innerwidth#" cellspacing="0" border="0" cellpadding="0" bgcolor="###attributes.TBgcolor#">
		<tr>
			<td align="#attributes.align#" class="BoxTitle" bgcolor="###attributes.HBgcolor#" style="color:###attributes.HText#;">
			<cfif len(attributes.title_image)>
				<img src="#Request.ImagePath##attributes.title_image#" alt="#attributes.box_title#" />
			<cfelse>
				#attributes.box_title#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="center" class="boxtext" style="color:###attributes.TText#;">
	</cfoutput>
	<!-- end customtags/format_box.cfm (start tag) -->

<cfelse><!--- END -------------------------------------------------->

			<cfoutput>
			<!-- start customtags/format_box.cfm (end tag) -->
			</td>
		</tr>
		<tr>
			<td class="boxtext" align="right" style="color:###attributes.TText#;">#attributes.more#</td>
		</tr>
	</table>
		
<cfif attributes.border>
		</td>
	</tr>
</table>
</cfif>

</div>
<!-- end customtags/format_box.cfm (end tag) -->
</cfoutput>
</cfif><!---- TAG END ------------------------------------------------>
