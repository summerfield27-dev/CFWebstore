
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of giftwrap options. Called by shopping.admin&giftwrap=list --->	
<cfquery name="qry_get_giftwraps" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Giftwrap
	ORDER BY Display DESC, Priority ASC
</cfquery>
		
