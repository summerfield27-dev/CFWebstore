<!--- CFWebstore, version 6.50 --->

<!--- Retrieve selected local tax rate(s). Called by shopping.admin&taxes=local --->

<cfquery name="GetTaxes" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#LocalTax
	WHERE Code_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.code_ID#">
	ORDER BY ZipCode
</cfquery>
