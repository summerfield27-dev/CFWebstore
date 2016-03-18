<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to update the UPS Settings for the store. Called by shopping.admin&shipping=ups and shopping.admin&shipping=settings --->

<cfquery name="GetUPS" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
SELECT * FROM #Request.DB_Prefix#UPS_Settings
</cfquery>

<cfquery name="GetUPSPickup" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#UPS_Pickup
</cfquery>

<cfquery name="GetUPSPackages" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#UPS_Packaging
</cfquery>

<cfquery name="GetUPSOrigins" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#UPS_Origins
ORDER BY OrderBy
</cfquery>

