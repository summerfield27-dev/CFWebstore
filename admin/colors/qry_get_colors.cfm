
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of color palettes. Called by home.admin&colors=list --->

<!--- This page is also called by various admin pages to display the list of color palettes that can be used for a store page. --->

<cfquery name="qry_get_Colors" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#" >
SELECT * FROM #Request.DB_Prefix#Colors
</cfquery>
		
	

	
