<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for reviews. Called by Feature.admin&review=actform --->

<!--- CSRF Check --->
<cfset keyname = "featReviewList">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Create the string with the filter parameters --->	
<cfset addedpath="&fuseaction=feature.admin&review=list">
<cfset fieldlist="uid,uname,search_string,feature_ID,rating,approved,needsCheck,order,sortby,editorial,recent_days">
<cfinclude template="../../../includes/act_setpathvars.cfm">	
	
<cfloop index="Review_ID" list="#attributes.reviewList#">
	
	<cfset Editorial = attributes["Editorial" & Review_ID]>
	<cfset NeedsCheck = iif(StructKeyExists(attributes,'NeedsCheck' & Review_ID),1,0)>
	<cfset Approved = iif(StructKeyExists(attributes,'Approved' & Review_ID),1,0)>

	<cfquery name="Updatereview" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#FeatureReviews
		SET Editorial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Editorial#">,
		NeedsCheck = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#NeedsCheck#">, 
		Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Approved#">
		WHERE Review_ID =<cfqueryparam cfsqltype="cf_sql_integer" value=" #Review_ID#">
	</cfquery>
</cfloop>

<!--- update admin menu  --->
<cfset attributes.admin_reload = "commentcount">
