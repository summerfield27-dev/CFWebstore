
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves a specific User record for editing. Called by the fuseaction users.admin&user=edit --->

<cfquery name="qry_get_user" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT U.*, F.AffCode, F.AffPercent, A.Account_ID, G.name AS GroupName
	FROM ((#Request.DB_Prefix#Users U 
			LEFT JOIN #Request.DB_Prefix#Groups G ON U.Group_ID = G.Group_ID) 
		LEFT JOIN #Request.DB_Prefix#Affiliates F ON U.Affiliate_ID = F.Affiliate_ID)
	LEFT JOIN #Request.DB_Prefix#Account A on A.User_ID = U.User_ID
	WHERE U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
</cfquery>

