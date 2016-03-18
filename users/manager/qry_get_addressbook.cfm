
<!--- CFWebstore, version 6.50 --->

<!--- called from dsp_addressbook.cfm to get all customer records a user has created. --->

<!--- Administrators can pass a User ID in, Users must use their own --->
<cfmodule template="../../access/secure.cfm"
	keyname="users"
	requiredPermission="1"
	> 
<cfif ispermitted>
	<cfparam name="attributes.uid" default="#Session.User_ID#">
<cfelse>	
	<cfset attributes.uid = Session.User_ID>	
</cfif>

<cfquery name="qry_get_addressbook" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Customers
	WHERE User_ID = <cfqueryparam value="#attributes.UID#" cfsqltype="CF_SQL_INTEGER">
	ORDER BY Company, LastName, FirstName
</cfquery>


