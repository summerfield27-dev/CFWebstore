
<!--- CFWebstore, version 6.50 --->

<!--- Ths file is used to create URL paths for searches --->

<cfparam name="addedpath" default="&fuseaction=#attributes.fuseaction#">
<cfparam name="fieldlist" default="">

<cfloop list="#fieldlist#" index="counter">
	<cfif StructKeyExists(attributes,counter) AND len(attributes[counter])>
		<!--- Sanitize the parameter --->
		<cfset addedpath = addedpath & "&#counter#=" & sanitize(attributes[counter])>
	</cfif>
</cfloop>

