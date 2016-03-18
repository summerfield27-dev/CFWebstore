<!--- CFWebstore, version 6.50 --->

<!--- Used to create an XML file with the pending counts to update the admin menu --->

<cfsetting showdebugoutput="No">

<cftry>
<cfset SpryData = Application.objMenus.doSpryData()>

<cfcontent type="text/xml">
<cfoutput>#SpryData#</cfoutput>
	
<cfcatch type="ANY">
	Store is reloading the CFC objects
</cfcatch>
</cftry>

