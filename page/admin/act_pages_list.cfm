
<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for pages. Called by page.admin&do=actform --->

<!--- CSRF Check --->
<cfset keyname = "pageListEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">

<cfloop index="page_ID" list="#attributes.pageList#">

<cfset Priority = attributes['Priority' & page_ID]>
<cfset Display = iif(StructKeyExists(attributes,'Display' & page_ID),1,0)>
<cfset Parent_id = attributes['Parent_id' & page_ID]>

<cfif parent_id is 0 and page_id is not 0>
	<cfset title_priority = 0>
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 9999>
	</cfif>
<cfelseif page_id is Parent_id>
	<cfset title_priority = priority>
	<cfset priority = 0>
<cfelse>
	<cfset title_priority = 0>
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 9999>
	</cfif>
</cfif>
	
				
<cfquery name="Updatepage" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Pages
	SET 
	<cfif page_id is not "0">
		Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">,
	</cfif>
	Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">,
	Title_Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#title_priority#">
	WHERE Page_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#page_ID#">
</cfquery>

</cfloop>



