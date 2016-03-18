
<!--- CFWebstore, version 6.50 --->

<!--- This query gets all the Customer information for a particular customer_ID --->

<!--- Administrators can pass a User ID in, Users must use their own --->
<cfmodule template="../access/secure.cfm"
	keyname="users"
	requiredPermission="1"
	> 

<cfquery name="qry_get_customer" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Customers
	WHERE Customer_ID = <cfqueryparam value="#attributes.Customer_id#" cfsqltype="CF_SQL_INTEGER">
	<cfif NOT ispermitted>
		AND User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="CF_SQL_INTEGER">
	</cfif>
</cfquery>



