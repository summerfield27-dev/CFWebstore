
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of Users for the admin. Called by the fuseaction users.admin&user=list|listform --->

<!--- initialize parameters --->
<cfloop index="namedex" list="uid,un,email,custname,location,email_bad,subscribe,affiliate,cid,shipto,gid,account_id,birthdate,CardisValid,CardNumber,currentbalance">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<cfparam name="attributes.Show" default="recent">
		
		
<cfquery name="qry_get_users"   datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
 SELECT U.*, G.Name AS groupname, C.FirstName, C.LastName, 
    (SELECT COUNT(Account_ID) FROM #Request.DB_Prefix#Account Acc 
		WHERE Acc.User_ID = U.User_ID) as Accounts
 FROM ((#Request.DB_Prefix#Users U 
 			LEFT JOIN #Request.DB_Prefix#Groups G ON U.Group_ID = G.Group_ID)  
    	LEFT JOIN #Request.DB_Prefix#Customers C ON U.Customer_ID = C.Customer_ID)
    <cfif len(attributes.account_ID)>
    LEFT JOIN #Request.DB_Prefix#Account A ON A.User_ID = U.User_ID
    </cfif>
 WHERE 1 = 1
		<cfif attributes.show is "recent">
			AND U.LastLogin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("ww", -1, Now())#">
		</cfif>
		<cfif len(trim(attributes.uid))>
			AND U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.uid#">
			</cfif>			
		<cfif len(trim(attributes.un))>
			AND U.Username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.un#%">
			</cfif>
		<cfif len(trim(attributes.email))>
			AND U.Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.email#%">
			</cfif>
		<cfif trim(attributes.affiliate) is 0>
			AND U.Affiliate_ID = 0
		<cfelseif trim(attributes.affiliate) is 1>
			AND U.Affiliate_ID <> 0
		</cfif>
		<cfif trim(attributes.email_bad) is "bad">
			AND U.EmailIsBad = 1	</cfif>
		<cfif trim(attributes.email_bad) is "good">
			AND U.EmailIsBad = 0 
			AND (U.EmailLock = 'verified'
			OR U.EmailLock = '')</cfif>
		<cfif trim(attributes.email_bad) is "lock"> 
			AND U.EmailLock <> 'verified'</cfif>
		<cfif isNumeric(trim(attributes.subscribe))>
			AND U.Subscribe = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.subscribe#">
			</cfif>
		<cfif len(trim(attributes.custname))>
			AND (LastName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.custname#%">
			OR FirstName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.custname#%">)
		</cfif>
		<cfif isNumeric(trim(attributes.cid))>
			AND (U.Customer_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
			OR U.ShipTo = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">)
			</cfif>
		<cfif isNumeric(trim(attributes.gid))>
			AND U.Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
			</cfif>
		<cfif isNumeric(trim(attributes.account_id))>
			AND A.Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#">
			</cfif>
		<cfif isDate(trim(attributes.birthdate))>
			AND U.Birthdate > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.birthdate#">
			</cfif>
		<cfif isNumeric(trim(attributes.CardisValid))>
			AND U.CardisValid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.CardisValid#">
			</cfif>
		<cfif len(trim(attributes.cardnumber))>
			AND U.CardNumber <> ''
			</cfif>
		<cfif fusebox.fuseaction IS "loginAsAnother">
			<!--- Filter out any admin users other than the one currently logged in --->
			AND ( U.Group_ID <> 1 
				OR ( U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #Session.User_ID#">
				<cfif StructKeyExists( Session, "OrigUserID")>
					OR U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #Session.OrigUserID#">
				</cfif>
				)
			)
			<!--- For this feature, always show the original user so they don't have to search for them --->
				<cfif StructKeyExists( Session, "OrigUserID")>
					OR U.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #Session.OrigUserID#">
				</cfif>
		</cfif>
		ORDER BY U.Username ASC
	</cfquery>


