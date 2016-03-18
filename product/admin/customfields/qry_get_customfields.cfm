
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for the product custom fields. Called by product.admin&fields=edit --->

<cfquery name="qry_Get_Customfields" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#Prod_CustomFields
ORDER BY Custom_ID
</cfquery>


