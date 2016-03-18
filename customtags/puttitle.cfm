
<!--- CFWebstore, version 6.50 --->

<cfif thistag.ExecutionMode is "start">

<cfparam name="Attributes.TitleText">
<cfparam name="Attributes.class" default=""> 

<cfoutput>
	<!-- customtags/puttitle.cfm -->
<h1 <cfif len(attributes.class)>class="#Attributes.class#"</cfif> style="color: ###Request.GetColors.MainTitle#">#Attributes.TitleText#</h1>
</cfoutput>

</cfif>


