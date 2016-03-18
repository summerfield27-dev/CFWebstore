
<!--- CFWebstore, version 6.50 --->

<!--- Read in the encryption key. If none found, create one --->
<cftry>
	<cfinclude template="../key.cfm">
	
<cfcatch type="missingInclude">
	<cfset objGlobal = Request.Loader.getComponent('/','global')>
	<cfset encrypt_key = objGlobal.createKey()>
</cfcatch>

</cftry>

