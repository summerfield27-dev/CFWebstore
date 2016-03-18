
<!--- CFWebstore, version 6.50 --->

<!--- This query gets the default shipping information for a user --->
<cfquery name="qry_get_shipto" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Customers
	WHERE Customer_ID = <cfqueryparam value="#qry_get_user.shipto#" cfsqltype="CF_SQL_INTEGER">
</cfquery>



