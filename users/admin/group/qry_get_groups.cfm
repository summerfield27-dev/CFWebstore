
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of Groups for the admin. Called by the fuseaction users.admin&group=list --->

<!--- initialize parameters --->
<cfloop index="namedex" list="gid,name,description,wholesale,discounts,promotions">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<cfquery name="qry_get_groups" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Groups
	WHERE 1 = 1
		<cfif len(trim(attributes.gid))>
			AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
		</cfif>
		<cfif len(trim(attributes.name))>
			AND Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">
		</cfif>
		<cfif len(trim(attributes.description))>
			AND Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.description#%">
			</cfif>
		<cfif len(trim(attributes.wholesale))>
			AND Wholesale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.wholesale#">
		</cfif>
		<cfif attributes.discounts IS 1>
			AND Group_ID IN (SELECT DISTINCT Group_ID FROM Discount_Groups)
		<cfelseif attributes.discounts IS 0>
			AND Group_ID NOT IN (SELECT DISTINCT Group_ID FROM Discount_Groups)
		</cfif>
		<cfif attributes.promotions IS 1>
			AND Group_ID IN (SELECT DISTINCT Group_ID FROM Promotion_Groups)
		<cfelseif attributes.promotions IS 0>
			AND Group_ID NOT IN (SELECT DISTINCT Group_ID FROM Promotion_Groups)
		</cfif>
</cfquery>
		
