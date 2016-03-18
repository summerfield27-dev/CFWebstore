
<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for Giftwraps. Called by Giftwrap.admin&do=actform --->

<!--- CSRF Check --->
<cfset keyname = "giftwrapListEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfloop index="Giftwrap_ID" list="#attributes.GiftwrapList#">

<cfset Price = attributes['Price' & Giftwrap_ID]>
<cfset Priority = attributes['Priority' & Giftwrap_ID]>
<cfset Display = iif(StructKeyExists(attributes,'Display' & Giftwrap_ID),1,0)>

<cfif NOT len(Trim(Price))>
	<cfset Price = 0>
<cfelse>
	<!--- Replaced for Blue Dragon:
	<cfset Price = LSParseNumber(Price)> --->
	<cfset Price = Price> 
</cfif>

<cfif NOT isNumeric(Priority) OR Priority IS 0>
	<cfset Priority = 9999>
</cfif>

<cfquery name="UpdateGiftwrap" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Giftwrap
	SET Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">,
	Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">,
	Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">
	WHERE Giftwrap_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Giftwrap_ID#">
</cfquery>

</cfloop>



