
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the current order information from the temporary table. Called by from do_checkout.cfm --->

<cfquery name="GetTempOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#TempOrder
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>



