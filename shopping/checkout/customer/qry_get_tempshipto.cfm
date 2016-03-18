
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the customer shipping address from the temporary table. Called by dsp_addresses.cfm and from shipping\act_calc_shipping.cfm --->

<!------------
<cfif len(attributes.shipto)>

<cfquery name="GetShipTo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#Customers 
WHERE Customer_ID =<cfqueryparam value="#attributes.shipto#" cfsqltype="cf_sql_integer">
</cfquery>

<cfelse></cfif>-------------->

<cfquery name="GetShipTo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#TempShipTo 
	WHERE TempShip_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>



