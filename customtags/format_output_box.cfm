<!--- CFWebstore, version 6.50 --->

<!--- Attributes --->
<cfparam name="attributes.box_title" default="">
<cfparam name="attributes.width" default="100%">
<cfparam name="attributes.border" default="1">
<cfparam name="attributes.align" default="center">
<cfparam name="attributes.HBgcolor" default="#Request.GetColors.OutputHBgcolor#">
<cfparam name="attributes.HText" default="#Request.GetColors.OutputHText#">
<cfparam name="attributes.TBgcolor" default="#Request.GetColors.OutputTBgcolor#">
<cfparam name="attributes.TText" default="#Request.GetColors.OutputTText#">
<cfparam name="attributes.more" default="">

<!--- START --------------------------------------------------------->
<cfif thistag.ExecutionMode is "Start">

	<cfoutput>
	<!-- start customtags/format_output_box (start tag) -->
	<div id="formatoutputbox" class="customtags">
	<cfif attributes.border>
	<table width="#attributes.width#" cellspacing="0" border="0" cellpadding="#attributes.border#" bgcolor="###attributes.HBgColor#" align="center">
		<tr>
			<td>
	</cfif>

		<table border="0" cellspacing="0" cellpadding="2" width="#attributes.width#" align="center" bgcolor="###attributes.TBgcolor#" style="color:###attributes.TText#;">
		<cfif len(attributes.box_title)>
			<tr>
				<th align="#attributes.align#" bgcolor="###attributes.HBgcolor#" class="boxtitle"
				style="color:###attributes.HText#;">#attributes.box_title#</th>
			</tr>
		</cfif>
			<tr>
				<td align="center" ><!--- <font color="###attributes.TText#"> --->
	<!-- end customtags/format_output_box (start tag) -->
	</cfoutput>

<cfelse><!--- END -------------------------------------------------->
	<!--- </font> --->
		<cfoutput>
		<!-- start customtags/format_output_box (end tag) -->
		</td>
		</tr>
		<tr>
			<td class="Outputtext" align="right">#attributes.more#</td>
		</tr>
	</table>
			
	<cfif attributes.border>
	</td></tr></table>
	</cfif>
	
	</div>
	<!-- end customtags/format_output_box (end tag) -->
	</cfoutput>
</cfif><!---- TAG END ------------------------------------------------>
