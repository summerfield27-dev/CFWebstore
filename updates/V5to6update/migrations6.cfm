
<!--- Retrieve current store settings --->

<cfquery name="get_Order_Settings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows=1>
SELECT * FROM #Request.DB_Prefix#OrderSettings
</cfquery>

<cfif get_Order_Settings.CCProcess IS NOT "Shift4OTN">
	
	<!--- Clear any old card data --->
	<cfquery name="GetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT ID, CardNumber FROM #Request.DB_Prefix#CardData
		WHERE CardNumber NOT LIKE "X%"
	</cfquery>
	
	<cfloop query="GetCards">
		<cfquery name="UpdateCard" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#CardData
		SET CardNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="xxxxxxxxxxxx#right(GetCards.cardnumber,4)#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetCards.ID#">
		</cfquery>
	</cfloop>
	
	<!--- Clear any user data --->
	<cfquery name="UpdUsers" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE Users
		SET EncryptedCard = NULL
		WHERE EncryptedCard IS NOT NULL
	</cfquery>

</cfif>