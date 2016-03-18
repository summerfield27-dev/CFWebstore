
<!--- CFWebstore, version 6.50 --->

<!--- This is a custom tag used for outputting the lines on the store. It takes attributes for the linetype and alignment and one that passes the image base location --->

<cfif thistag.ExecutionMode is "start">
<cfparam name="Attributes.linetype" default="Thick">
<cfparam name="Attributes.linecolor" default="#Request.GetColors.linecolor#">
<cfparam name="Attributes.align" default="Center">
<cfparam name="Attributes.width" default="100%">
<cfparam name="Attributes.imgBase" default="#Request.ImagePath#">

<!--- Make sure there is a trailing slash --->
<cfif Right(attributes.imgBase, 1) IS NOT "/">
	<cfset attributes.imgBase = attributes.imgBase & "/">
</cfif>

<cfif Attributes.linetype IS "Thick">	
	<cfif len(Request.MainLine)>
		<cfoutput>
			<!-- customtags/putline.cfm -->
			<cfif Request.MainLine IS "HR" and len(attributes.linecolor)>
		 <div class="thickline" style="color: ###Attributes.linecolor#; background-color: ###Attributes.linecolor#;  width: #Attributes.width#;"><hr /></div>
		<cfelse><img src="#Attributes.imgBase#/#Request.MainLine#" class="thickline" alt="" /></cfif>
		</cfoutput>
	</cfif>
<cfelse>
	<cfif len(Request.MinorLine)>
		<cfoutput>
			<!-- customtags/putline.cfm -->
			<!----<span align="#Attributes.align#">--->
		<cfif Request.MinorLine IS "HR" and len(attributes.linecolor)>
		<div class="thinline" style="color: ###Attributes.linecolor#; background-color: ###Attributes.linecolor#; width: #Attributes.width#;"><hr /></div>
		<cfelse><img src="#Attributes.imgBase#/#Request.MinorLine#" class="thickline" alt="" />
		</cfif>
		<!----</span>---->
		</cfoutput>
	</cfif>
</cfif>
</cfif>


