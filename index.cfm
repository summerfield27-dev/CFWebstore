
<!--- CFWebstore, version 6.50 --->

<!--- Used to call the appropriate Fusebox core file --->

<!--- CF10 Fix for SEO URLs. When CF10 does not find a template, application.cfm file is not executed. --->
<cfif not isDefined("request.self")>
<cfset request.self="index.cfm">
<cfinclude template="config.cfm">
</cfif>

<!---- for search engine urls ------>
<cfset SESrBaseName = "baseHREF"> 
<cfinclude template="customtags/sesConverter.cfm"> 

<!--- include the core FuseBox  --->
<cflock type="READONLY" scope="server" timeout="10">
	<cfset variables.fuseboxVersion=Replace(Replace(ListDeleteAt(server.coldfusion.productVersion,4),",","","all")," ","","all")>
	<cfset variables.fuseboxOSName=server.os.name>
</cflock>

<cfinclude template="fbx_fusebox30_CF50_lite.cfm">


