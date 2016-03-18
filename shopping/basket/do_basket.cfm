<!--- CFWebstore, version 6.50 --->

<!--- This template is used to output the shopping cart. Called by fbx_Switch.cfm --->

<cfparam name="variables.checkout" default="0">

<cfif NOT variables.checkout>
	<cfinclude template="estimator/act_ship_estimator.cfm">
</cfif>

<cfinclude template="dsp_basket.cfm">
<!--- call the page display fuseaction if not checkout --->
<cfif NOT variables.checkout>
	<cfset attributes.pageaction = "basket">
	<cfset fusebox.nextaction="page.display">
	<cfinclude template="../../lbb_runaction.cfm">
</cfif>
<!--- end fuseaction call --->

