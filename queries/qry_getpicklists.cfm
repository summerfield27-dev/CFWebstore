
<!--- CFWebstore, version 6.50 --->

<!--- Get PickLists --->
<cfquery name="qry_GetPicklists" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#PickLists
</cfquery>



