<!--- CFWebstore, version 6.50 --->

<!--- This page is used to make sure the user has cookies turned on in order to shop. --->

<cfif NOT StructKeyExists(cookie, "CFID") AND NOT  StructKeyExists(cookie, "JSESSIONID")>
	<cflocation url="#self#?fuseaction=page.nocookies">
</cfif>
