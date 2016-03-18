<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to update the FedEx Settings for the store. Called by shopping.admin&shipping=fedex --->

<cfquery name="GetFedEx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
SELECT * FROM #Request.DB_Prefix#FedEx_Settings
</cfquery>

<cfquery name="GetFedExDropoff" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#FedEx_Dropoff
</cfquery>

<cfquery name="GetFedExPackages" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT * FROM #Request.DB_Prefix#FedEx_Packaging
</cfquery>


