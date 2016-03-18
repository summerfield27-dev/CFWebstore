
<!--- CFWebstore, version 6.50 --->

<!--- Javascript redirect after login or logout. If javascript is turned off, will give user a link to click on to continue. Called from act_login.cfm and act_logout.cfm--->

<cfif isdefined("attributes.submit_logout")>
	<cfparam name="attributes.xfa_logout_successful" default="fuseaction=users.manager">
	<cfset redirect = attributes.xfa_logout_successful>
	<cfset theresult = "You have logged out.">

<cfelse>
	<cfparam name="attributes.xfa_login_successful" default="fuseaction=users.manager">
	<cfset redirect = attributes.xfa_login_successful>
	<cfset theresult = "You are now logged in.">
</cfif>

<cfparam name="attributes.server_port" default="80">

<cfset redirect = URLDecode(redirect)>
<cfset redirect = ReReplaceNoCase(redirect, "<[^>]*>", "", "ALL")>

<!--- Check if the redirect already has session information --->
<cfif NOT FindNoCase("CFID=",redirect) AND len(Request.Token2)>
	<cfset redirect = redirect & Request.Token2>
</cfif>
	
<!--- Remove any previous error messages or redirect parameter --->
<cfset redirect = REReplaceNoCase(redirect, "[&(&amp;)]*errormess=[0-9]+", "", "ALL")>
<cfset redirect = REReplaceNoCase(redirect, "[&(&amp;)]*redirect=yes", "", "ALL")>

<!--- If on checkout registration page, remove that from the redirect URL --->
<cfset redirect = ReplaceNoCase(redirect, "&step=register", "&step=address")>

<!--- Add error message --->
<cfif isdefined("variables.errormess") AND variables.errormess IS NOT 0>
	<cfset attributes.xfa_login_successful = Request.LoginURL>
	<cfset redirect = redirect & "&errormess=#errormess#">
	<cfset theresult = "You are not logged in.">
</cfif>

<cfset redirectURL = doReturn(redirect)>

<!--- If checking out, redirect back to the start of the checkout --->
<cfif FindNoCase("shopping.checkout", redirect)>
	<cflocation url="#redirectURL#&login=yes" addtoken="No">
</cfif>

<!--- If redirecting to an admin page, set to open in full window with menu --->
<cfif FindNoCase(".admin", redirect)>
	<cfset redirect = redirect & "&newWindow=yes">
</cfif>
	
<!-- start users/login/dsp_result.cfm -->
<cfoutput>
<script type="text/javascript">
window.top.location.href = '#redirectURL#';
</script>

<span id="dspresult" class="users">
#theresult# <a href="#XHTMLFormat(redirectURL)#" target="_top">Click</a> to continue. 
</span>
</cfoutput> 

<!-- end users/login/dsp_result.cfm -->

