
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for a software download. Called by the access.download fuseaction --->

<cfparam name="attributes.ID" default="0">
<cfset attributes.Membership_id = attributes.ID>

<cfquery name="qry_get_Membership"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT M.*, U.Username, P.Name, P.Prod_Type, P.Content_URL, P.MimeType, P.User_ID AS UID
	FROM ((#Request.DB_Prefix#Memberships M 
	LEFT JOIN #Request.DB_Prefix#Users U ON M.User_ID = U.User_ID) 
	LEFT JOIN #Request.DB_Prefix#Products P ON M.Product_ID = P.Product_ID)
	WHERE M.Membership_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_id#">
	AND M.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
		AND Valid = 1
		AND (Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Start IS NULL)
		AND (Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Expire IS NULL)
		AND M.Access_Used < M.Access_Count
</cfquery>
		


