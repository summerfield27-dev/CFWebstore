
<!--- CFWebstore, version 6.50 --->

<!--- This query is used throughout the store to retrieve the settings related to shipping. It is cached to improve performance so is also called after changing any of the settings to update the cached query.  --->

<cfquery name="ShipSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" cachedwithin="#Request.Cache#">
	SELECT * FROM #Request.DB_Prefix#ShipSettings
</cfquery>


<!--- if any methods are showEstimator, not just the first one in the DB --->
<cfparam name="attributes.showEstimator" default="0">
<cfloop query="ShipSettings">
	<cfif showEstimator eq 1>
    	<cfset attributes.showEstimator = 1>
    </cfif>
</cfloop>

<!--- list of shipTypes, not just the first --->
<cfset attributes.shiptypelist = valuelist(shipsettings.shiptype)>

