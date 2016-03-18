<!--- CFWebstore, version 6.50 --->

<!--- Getting the table names --->
<cfif Request.dbtype IS "MSSQL">
	<cfquery name="GetTableNames" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM INFORMATION_SCHEMA.Tables
		WHERE Table_Type = 'BASE TABLE'
		ORDER BY Table_Name
	</cfquery>
<cfelse>
	<cfquery name="GetTableNames" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		SHOW TABLES
	</cfquery>
</cfif>