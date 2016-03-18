
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of credit cards accepted by the store. Called by users\formfields\put_ccard.cfm --->

<cfquery name="GetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT CardName FROM #Request.DB_Prefix#CreditCards
	WHERE USED = 1
</cfquery>



