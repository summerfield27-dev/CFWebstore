
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the complete list of tax codes, to set the calculation order and cumulative settings. Called by shopping.admin&taxes=editcode --->

<!--- CSRF Check --->
<cfset keyname = "taxCodes">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="GetCodes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Code_ID FROM #Request.DB_Prefix#TaxCodes
</cfquery>

<cfloop query="GetCodes">

	<cfset CalcOrder = attributes['CalcOrder' & Code_ID]>

	<cfif StructKeyExists(attributes,'Cumulative' & Code_ID)>
		<cfset Cumulative = 1>
	<cfelse>
		<cfset Cumulative = 0>
	</cfif>

	<cfquery name="UpdateMethod2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#TaxCodes
		SET CalcOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(CalcOrder),CalcOrder,0)#">,
		Cumulative = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Cumulative#">
		WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Code_ID#">
	</cfquery>

</cfloop>

<!---------------------------->
<cfoutput>
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
alert('Your changes have been saved!');
location.href = "#self#?fuseaction=shopping.admin&taxes=codes&redirect=yes#request.token2#";
</script>
</cfprocessingdirective>
</cfoutput>


