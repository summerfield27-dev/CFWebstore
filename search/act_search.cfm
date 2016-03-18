
<!--- CFWebstore, version 6.50 --->

<!--- Performs the site search. This page is used as the default file for the 'search results page' page template --->

<cfif request.appsettings.UseVerity>
	<cfinclude template="act_verity_search.cfm">
	<cfinclude template="dsp_verity_results.cfm">
<cfelse>
	<cfinclude template="act_sql_search.cfm">
	<cfinclude template="dsp_sql_results.cfm">
</cfif>



