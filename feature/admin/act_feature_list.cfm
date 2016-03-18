
<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for features. Called by feature.admin&feature=actform --->

<!--- CSRF Check --->
<cfset keyname = "featureListForm">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">

<!--- Create the string with the filter parameters --->	
<cfset addedpath="&fuseaction=Feature.admin&Feature=list">
<cfset fieldlist="uid,username,search_string,feature_type,accesskey,display_status,highlight,order,cid">
<cfinclude template="../../includes/act_setpathvars.cfm">

<cfloop index="Feature_ID" list="#attributes.FeatureList#">

<cfset Priority = attributes["Priority" & Feature_ID]>
<cfset Start = attributes["Start" & Feature_ID]>
<cfset Expire = attributes["Expire" & Feature_ID]>
<cfset Display = iif(StructKeyExists(attributes,"Display" & Feature_ID),1,0)>
<cfset Highlight = iif(StructKeyExists(attributes,"Highlight" & Feature_ID),1,0)>
<cfset Approved = iif(StructKeyExists(attributes,"Approved" & Feature_ID),1,0)>

<cfif NOT isNumeric(Priority) OR Priority IS 0>
	<cfset Priority = 9999>
</cfif>

<cfquery name="UpdateFeature" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Features
	SET Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">,
	Start = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Start#" null="#YesNoFormat(NOT isDate(Start))#">,
	Expire = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Expire#" null="#YesNoFormat(NOT isDate(Expire))#">,
	Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">,
	Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Highlight#">, 
	Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Approved#">
	WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Feature_ID#">
</cfquery>
</cfloop>

			


