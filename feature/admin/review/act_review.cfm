<!--- CFWebstore, version 6.50 --->

<!--- Check user's feature review permission level, and if not admin, restrict access to only their own reviews --->
<cfmodule template="../../../access/secure.cfm" keyname="feature" requiredPermission="8">
<cfif NOT ispermitted>
	<cfset attributes.UID = Session.User_ID>
<cfelse>
	<cfparam name="attributes.UID" default="#Session.User_ID#">
</cfif>

<cfparam name="attributes.submit_review" default="">
<cfparam name="attributes.feature_ID" default="0">

<cfif attributes.submit_review is "Delete">
	<cfset attributes.delete = attributes.Review_ID>
	<cfset attributes.XFA_success = "fuseaction=feature.admin&review=list">
</cfif>

<cfset attributes.error_message = "">

<cfif len(attributes.submit_Review) or isdefined("attributes.delete")>


	<!--- CSRF Check --->
	<cfset keyname = "featReviewEdit">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif isdefined("attributes.Delete")>

		<cfset attributes.error_message = "">

		<!--- check if review has any children ---->
		<cfquery name="checkchildren" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Review_ID
			FROM #Request.DB_Prefix#FeatureReviews
			WHERE Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
		</cfquery>
			
		<cfif checkchildren.recordcount gt 0>
			<cfset attributes.error_message = "This comment can not be deleted because it has other comments attached to it. Please delete them first.">
		</cfif>
		
		<!--- Check permission for user ---->
		<cfquery name="Check_Review"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Review_ID FROM #Request.DB_Prefix#FeatureReviews
			WHERE Review_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
			<cfif NOT ispermitted>
          		AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">
			</cfif>
		</cfquery>
			
		<cfif NOT Check_Review.RecordCount>
			<cfset attributes.error_message = "Sorry, you do not have permission to delete this review.">
		</cfif>		
		
		<cfif not len(attributes.error_message)>
		
			<cfquery name="Delete_Review"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#FeatureReviews
				WHERE Review_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
			</cfquery>	
		
		</cfif>
		
		<cfparam name="attributes.XFA_success" default="fuseaction=feature.admin&review=list">
		<cfset attributes.Feature_ID = "">
		
	<!--- Add or Edit --->	
	<cfelse>	
			
		<cfset fieldlist = "uname,Anon_Name,Anon_Loc,Anon_email,Editorial,Rating,updated">
	
		<cfloop list="#fieldlist#" index="counter">
			<cfparam name="attributes.#counter#" default="">
		</cfloop>
		
		<!--- Strip paragraph tags at beginning and end, if found. --->
		<cfset attributes.Comment = ReReplace(attributes.Comment, "^\s*<p>", "")>
		<cfset attributes.Comment = ReReplace(attributes.Comment, "</p>\s*$", "")>
		
		<!--- Add required fields --->
		<cfset fieldlist = ListAppend(fieldlist, "title,Anonymous")>
		
		<!--- Parse the fields to remove any HTML --->
		<cfloop list="#fieldlist#" index="counter">
			<cfset attributes[counter] = HTMLEditFormat(Trim(attributes[counter]))>
		</cfloop>
		
		<cfset attributes.Comment = Application.objGlobal.CodeCleaner(attributes.Comment)>

		<cfif NOT len(attributes.updated)>
			<cfset attributes.Updated = now()>
		</cfif>
		
		
		<cfif request.appsettings.FeatureReview_Approve>
			<cfparam name="attributes.Approved" default="0">
		<cfelse>
			<cfparam name="attributes.Approved" default="1">
		</cfif>

		<cfif len(attributes.uname) AND ispermitted>
			<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT User_ID FROM #Request.DB_Prefix#Users
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
			</cfquery>
			<cfif finduser.recordcount>
				<cfset attributes.UID = finduser.user_ID>	
			<cfelse>
				<cfset attributes.error_message = "OOPS! The user name entered is not valid.">
			</cfif>	
		</cfif>		

		
		<cfif not len(attributes.error_message)>
	
		<cfif attributes.Review_ID IS 0>
			
				<cfquery name="Add_Review" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#FeatureReviews
				(Feature_ID, User_ID, Anonymous, Anon_Name, Anon_Loc, Anon_Email, Parent_ID, Title,
				Comment, Rating, Posted, Updated, Approved, NeedsCheck)
				VALUES(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Anonymous#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Loc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_email#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Parent_ID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Title#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Comment#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Rating#" null="#YesNoFormat(NOT Len(attributes.Rating))#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Approved#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#iif(isDefined('attributes.NeedsCheck'), Evaluate(DE('attributes.NeedsCheck')), 0)#">
				)
				</cfquery>
		<cfelse>

			<cfquery name="Update_Review" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#FeatureReviews
			SET 	
			User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">,
			Anonymous = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Anonymous#">,
			Anon_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Name#">,
			Anon_Loc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Loc#">,
			Anon_Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_email#">,
			Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Title#">,
			Comment = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Comment#">,
			Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Approved#">,
			Rating = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Rating#" null="#YesNoFormat(NOT Len(attributes.Rating))#">,			
			<cfif isdefined("attributes.posted")>
				Posted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Posted#">,
			</cfif>
			<cfif isdefined("attributes.NeedsCheck")>
				NeedsCheck = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.NeedsCheck#">,
			</cfif>					
			Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">
			WHERE Review_ID = <cfqueryparam value="#attributes.Review_ID#" cfsqltype="CF_SQL_INTEGER">
			
			</cfquery>
		
			<cfparam name="attributes.XFA_success" default="fuseaction=feature.admin&review=list">
			
		</cfif><!--- Add or edit --->
			
			
				
		</cfif><!--- Error Message Check --->
	
		<cfset attributes.UID = "">
			
	</cfif>
	
</cfif>

<!--- update admin menu  --->
<cfif FindNoCase(".admin", attributes.XFA_success)>
	<cfset attributes.admin_reload = "commentcount">
</cfif>


<cfsetting enablecfoutputonly="no">