<!--- CFWebstore, version 6.50 --->

<!--- Retrieve selected tax code(s). Called by shopping.admin&taxes=codes and other tax pages--->

<cfquery name="GetCodes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#TaxCodes
	<cfif isDefined("attributes.code_ID")>
		WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_ID#">
	</cfif>
	ORDER BY CalcOrder, CodeName
</cfquery>
