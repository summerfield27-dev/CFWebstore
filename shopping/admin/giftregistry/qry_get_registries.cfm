
<!--- CFWebstore, version 6.50 --->

<cfsetting enablecfoutputonly="yes">

<!--- Retrieves the list of giftregistrys. Filters according to the search parameters that are passed. Called by giftregistry.admin&giftregistry=list|listform --->

<cfloop index="namedex" list="uid,uname,giftregistry_ID,name,city,giftregistry_Type,event_Date,display_status">
	<cfparam name="attributes[namedex]" default="">
</cfloop>
		
<!--- If we have an event date, set the start and end date --->
<cfif len(attributes.event_Date)>

	<cfset Year = "20" & ListGetAt(attributes.event_Date, 1, "-")>

	<!--- Check if month entered --->
	<cfif listlen(attributes.event_Date,'-') gte 2>
		<cfset StartMonth = ListGetAt(attributes.event_Date, 2, "-")>
		<cfset EndMonth = ListGetAt(attributes.event_Date, 2, "-")>
	<cfelse>
		<cfset StartMonth = 1>
		<cfset EndMonth = 12>
	</cfif>

	<!--- Check if day entered --->
	<cfif listlen(attributes.event_Date,'-') is 3>
		<cfset StartDay = ListGetAt(attributes.event_Date, 3, "-")>
		<cfset EndDay = ListGetAt(attributes.event_Date, 3, "-")>
	<cfelse>
		<cfset StartDay = 1>
		<cfset EndDay = DaysinMonth(CreateDate(Year, StartMonth, StartDay))>
	</cfif>

	<cfset eventfrom = CreateDateTime(Year, StartMonth, StartDay, 0, 0, 0)>
	<cfset eventto = CreateDateTime(Year, EndMonth, EndDay, 23, 59, 59)>
	
</cfif>
		
<cfif attributes.display_status is "expired">
	<cfset expire = 1>
	<cfset attributes.approved = "">
	<cfset attributes.live = "0">
	<cfset approved = "">
	<cfset live = "">
<cfelseif attributes.display_status is "over">
	<cfset expire = 0>
	<cfset eventfrom = CreateDateTime(2000, 1, 1, 0, 0, 0)>	
	<cfset eventto = now()>
	<cfset approved = "">
	<cfset live = "">
<cfelseif attributes.display_status is "upcoming">
	<cfset expire = 0>
	<cfset eventfrom = now()>	
	<cfset eventto = CreateDateTime(2100, 1, 1, 0, 0, 0)>
	<cfset approved = "">
	<cfset live = "">
<cfelseif attributes.display_status is "editor">
	<cfset expire = 0>
	<cfset approved = 0>
	<cfset live = 1>
<cfelseif attributes.display_status is "off">
	<cfset expire = 0>
	<cfset approved = "">
	<cfset live = 0>
<cfelse>
	<cfset expire = "">
	<cfset approved = "">
	<cfset live = "">
</cfif>
		

<!--- Get wishlist items --->
<cfquery name="qry_get_giftregistrys" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT GR.*, U.Username
FROM #Request.DB_Prefix#GiftRegistry GR 
LEFT OUTER JOIN #Request.DB_Prefix#Users U ON GR.User_ID = U.User_ID
WHERE 
	1 = 1
	<cfif len(attributes.UID)>
		AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">
	</cfif>

	<cfif len(attributes.name) OR len(attributes.city)>

		<cfif len(attributes.name)>
		AND (Event_name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">
		OR Registrant like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">
		OR OtherName like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">
		OR Username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.name#%">)
		</cfif>
		
		<cfif len(attributes.city)>
		AND (City like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">
		OR State like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">)
		</cfif>
		
	<cfelseif len(attributes.GiftRegistry_ID)>
		AND GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.giftRegistry_ID#">
	</cfif>
	
	<cfif len(attributes.giftregistry_Type)>
		AND GiftRegistry_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.giftregistry_Type#">
	</cfif>
		
	<cfif isDefined("eventfrom")>
		AND Event_Date >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#eventfrom#">
		AND Event_Date <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#eventto#">
	</cfif>	
	
	<cfif len(expire)>
		<cfif expire>
			AND Expire <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		<cfelse>
			AND Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		</cfif>
	</cfif>
	
	<cfif len(approved)>
		AND Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#approved#">
	</cfif>
	
	<cfif len(live)>
		AND Live = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#live#">
	</cfif>
	
ORDER BY GiftRegistry_ID DESC
</cfquery>


