
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of memberships for the admin. Called by the fuseaction access.admin&membership=list --->

<!--- Defaults for the filters --->
<cfparam name="attributes.IsExpired" default="ALL">
<cfparam name="attributes.IsUsed" default="ALL">
<cfparam name="attributes.Valid" default="">
<cfparam name="attributes.User" default="">
<cfparam name="attributes.UID" default="">
<cfparam name="attributes.membership_Type" default="">
<cfparam name="attributes.prod_type" default="">
<cfparam name="attributes.Product" default="">
<cfparam name="attributes.AccessKey" default="">

<cfparam name="attributes.Show" default="recent">

<cfquery name="qry_get_Memberships"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT M.*, U.Username, U.CardisValid, U.CardExpire, U.Disable, P.Name AS product
		FROM ((#Request.DB_Prefix#Memberships M 
				LEFT JOIN #Request.DB_Prefix#Users U ON M.User_ID = U.User_ID) 
				LEFT JOIN #Request.DB_Prefix#Products P ON M.Product_ID = P.Product_ID)

		WHERE 1=1
		<cfif attributes.show is "recent">
			AND M.Date_Ordered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("ww", -1, Now())#">
		</cfif>
		<cfif attributes.IsExpired is "current">
			AND (M.Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR M.Start IS NULL)
		<cfelseif attributes.IsExpired is "future">
			AND M.Start > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		</cfif>		
		<cfif attributes.IsExpired is "current">
			AND (M.Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR M.Expire IS NULL)
			AND (M.Suspend_Begin_Date IS NULL
				OR	M.Suspend_Begin_Date >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		<cfelseif attributes.IsExpired is "expired">
			AND (M.Expire < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				OR M.Suspend_Begin_Date < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		<cfelseif attributes.IsExpired is "suspended">
			AND M.Suspend_Begin_Date IS NOT NULL
		<cfelseif attributes.IsExpired is "recur">
			AND M.Recur = 1
		</cfif>		
		<cfif attributes.IsUsed is "yes">
			AND M.Access_Used >= M.Access_Count
		<cfelseif attributes.IsUsed is "no">
			AND M.Access_Used < M.Access_Count
		</cfif>	
		<cfif attributes.valid is "yes">
			AND M.Valid = 1
		<cfelseif attributes.valid is "no">
			AND M.Valid = 0
		</cfif>	
		<cfif attributes.User is not "">
			AND (U.Username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#User#%">
				 OR U.Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#User#%">)
		</cfif>	
		<cfif attributes.UID is not "">
			AND	M.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">
		</cfif>	
		<cfif attributes.product is not "">
			AND P.Name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#product#%">
		</cfif>		
		<cfif attributes.AccessKey is not "">
			AND (M.AccessKey_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccessKey#">
			OR M.AccessKey_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccessKey#,%">
			OR M.AccessKey_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.AccessKey#">
			OR M.AccessKey_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.AccessKey#,%">)
		</cfif>	
		<cfif attributes.prod_type is not "">
			AND P.Prod_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_type#">
		</cfif>	
		<cfif attributes.membership_type is not "">
			AND M.Membership_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.membership_type#">
		</cfif>	
		
		<cfif attributes.show is "all">
		ORDER BY M.Membership_ID DESC
		<cfelseif attributes.IsExpired is "recur">
		ORDER BY M.Expire DESC
		<cfelse>
		ORDER BY M.Valid DESC, M.Start DESC, M.Product_ID
		</cfif>
</cfquery>

