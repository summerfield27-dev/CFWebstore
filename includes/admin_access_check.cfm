<!--- CFWebstore, version 6.50 --->

<!--- This page is used to perform some additional admin access checks. If the site is using SSL, it makes sure the site ID cookie is set and matches the one in session memory. Called from ../fbx_Switch.cfm --->

<cfparam name="ispermitted" default="no">

<!--- No need to run these checks if access already failed. --->
<cfif ispermitted AND Request.secure_cookie>
	<cfif NOT isDefined("cookie.SiteID") OR NOT isDefined("Session.SpoofCheck") OR cookie.SiteID IS NOT Hash(Session.SpoofCheck)>
		<cfset ispermitted = "no">
	</cfif>
</cfif>

