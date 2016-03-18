
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves a specific membership record for editing. Called by the fuseaction access.admin&membership=edit --->

<cfquery name="qry_get_Membership"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT M.*, U.Username, U.User_ID, P.Name, P.Prod_Type, P.Content_URL
	FROM ((#Request.DB_Prefix#Memberships M 
			LEFT JOIN #Request.DB_Prefix#Users U ON M.User_ID = U.User_ID) 
			LEFT JOIN #Request.DB_Prefix#Products P ON M.Product_ID = P.Product_ID)
	WHERE M.Membership_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_id#">
</cfquery>
		
	

	
