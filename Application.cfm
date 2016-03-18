<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to make sure that the user goes through the main index.cfm page --->

<!---<cfset request.self="index.cfm">--->

<cfinclude template="config.cfm">

<cfif Request.DevelopmentMode>
	<cfsetting showdebugoutput="Yes">
<cfelse>
	<cfsetting showdebugoutput="No">
</cfif>

<!--- add any files that can be directly accessed to this list --->
<!--- <cfset directAccessFiles="#request.self#,go.cfm,image.cfm,colortool.cfm">
<cfif not listFindNoCase(directaccessfiles,getfilefrompath(cgi.script_name))>
	<cflocation url="#request.self#" addtoken="No">
</cfif>	 --->

<!--- check for invalid fuseaction --->
<cfif StructKeyExists(URL,"fuseaction") AND ListLen(URL.fuseaction, ".") IS NOT 2>
<cfabort>
</cfif>

<cfif "#GetDirectoryFromPath(GetCurrentTemplatePath( ))#index.cfm" NEQ GetBaseTemplatePath()
 AND "#GetDirectoryFromPath(GetCurrentTemplatePath( ))#go.cfm" NEQ GetBaseTemplatePath()
 AND "#GetDirectoryFromPath(GetCurrentTemplatePath( ))#image.cfm" NEQ GetBaseTemplatePath()
 AND "#GetDirectoryFromPath(GetCurrentTemplatePath( ))#colortool.cfm" NEQ GetBaseTemplatePath()
 AND "#GetDirectoryFromPath(GetCurrentTemplatePath( ))#admin\index.cfm" NEQ GetBaseTemplatePath()>
	<cflocation url="#Request.StorePath#index.cfm">
 </cfif>

</cfsilent>