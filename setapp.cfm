<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to set application settings --->

<!--- Don't change anything in this file, unless you know what you are doing! --->

<!--- Set cached query timeout --->
<cfif IsDefined("attributes.Refresh") OR Request.DevelopmentMode>
	<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfelse>
	<cfset Request.Cache = CreateTimeSpan(0, 1, 0, 0)>
</cfif>

<!--- Keep Alive will keep the session alive while the browser is open, so a very low session timeout is needed, and increases security of the application. --->
<!--- For search engines, this will be set to just seconds, to prevent large numbers of hits from crawlers using lots of memory --->
<cfparam name="Request.SessionTimeout" default="#CreateTimeSpan(0, 0, 20, 0)#">

<cfset Request.BrowserType = getBrowserType(cgi.http_user_agent)>
<cfif Request.BrowserType.browserName IS "spider">
	<cfset Request.SessionTimeout = #CreateTimeSpan(0, 0, 0, 2)#>
</cfif>

<cfapplication name="#Request.DS#" clientmanagement="No" sessionmanagement="Yes" 
	setclientcookies="No" sessiontimeout="#Request.SessionTimeout#"
	applicationtimeout="#CreateTimeSpan(0, 2, 0, 0)#">	

</cfsilent>
