<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin functions for product reviews: add, update, delete --->

<!--- Check user's product review permission level --->
<cfmodule template="../../../access/secure.cfm" keyname="product" requiredPermission="64">
<cfif NOT ispermitted>
	<cfset attributes.UID = Session.User_ID>
<cfelse>
	<cfparam name="attributes.UID" default="#Session.User_ID#">
</cfif>

<cfparam name="attributes.submit_review" default="">
<cfparam name="attributes.product_ID" default="0">

<cfif attributes.submit_review is "Delete">
	<cfset attributes.delete = attributes.Review_ID>
	<cfset attributes.XFA_success = "fuseaction=product.admin&review=list">
</cfif>

<cfset attributes.error_message = "">

<cfif len(attributes.submit_Review) or StructKeyExists(attributes,"delete")>

	<!--- CSRF Check --->
	<cfset keyname = "prodReviewEdit">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif StructKeyExists(attributes,"Delete")>

		<cfset attributes.error_message = "">

		<!--- Error checking goes here ---->
		<cfquery name="Check_Review"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Review_ID FROM #Request.DB_Prefix#ProductReviews
				WHERE Review_ID = <cfqueryparam value="#attributes.delete#" cfsqltype="cf_sql_integer">
				<cfif NOT ispermitted>
           		AND User_ID = <cfqueryparam value="#attributes.UID#" cfsqltype="cf_sql_integer">
				</cfif>
			</cfquery>
			
		<cfif NOT Check_Review.RecordCount>
			<cfset attributes.error_message = "Sorry, you do not have permission to delete this review.">
		</cfif>
		
		<cfif not len(attributes.error_message)>
		
			<cfquery name="Delete_Helpful"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#ProductReviewsHelpful
				WHERE Review_ID = <cfqueryparam value="#attributes.delete#" cfsqltype="cf_sql_integer">
				</cfquery>	
		
			<cfquery name="Delete_Review"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#ProductReviews
				WHERE Review_ID = <cfqueryparam value="#attributes.delete#" cfsqltype="cf_sql_integer">
			</cfquery>	
		
		</cfif>
		
		<cfparam name="attributes.XFA_success" default="fuseaction=product.admin&review=list">
		<cfset attributes.product_ID = "">
		
	<!--- Add or Edit --->	
	<cfelse>	

		<cfloop list="uname,Anonymous,Anon_Name,Anon_Loc,Anon_email,Editorial,Rating,updated" index="counter">
			<cfparam name="attributes.#counter#" default="">
		</cfloop>	

		<cfif NOT len(attributes.updated)>
			<cfset attributes.Updated = now()>
		</cfif>
		
		<!--- Strip paragraph tags at beginning and end, if found. --->
		<cfset attributes.Comment = ReReplace(attributes.Comment, "^\s*<p>", "")>
		<cfset attributes.Comment = ReReplace(attributes.Comment, "</p>\s*$", "")>
		
		<cfif request.appsettings.ProductReview_Approve>
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
				INSERT INTO #Request.DB_Prefix#ProductReviews
				(Product_ID, User_ID, Anonymous, Anon_Name, Anon_Loc, Anon_Email, Title, Comment, Rating,
				Posted, Updated, Approved, NeedsCheck, Helpful_Total, Helpful_Yes)
				VALUES(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Anonymous#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_Loc#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Anon_email#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Title#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Comment#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Rating#" null="#YesNoFormat(NOT Len(attributes.Rating))#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Approved#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#iif(isDefined('attributes.NeedsCheck'), 'attributes.NeedsCheck', 0)#">, 0, 0 )
				</cfquery>
				
		<cfelse>

			<cfquery name="Update_Review" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#ProductReviews
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
			<cfif StructKeyExists(attributes,"posted")>
				Posted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Posted#">,
			</cfif>
			<cfif StructKeyExists(attributes,"NeedsCheck")>
				NeedsCheck = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.NeedsCheck#">,
			</cfif>
			<cfif StructKeyExists(attributes,"Helpful_Total")>
				Helpful_Total = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Helpful_Total#">,
			</cfif>
			<cfif StructKeyExists(attributes,"Helpful_Yes")>
				Helpful_Yes = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Helpful_Yes#">,
			</cfif>
					
			Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Updated#">
			WHERE Review_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Review_ID#">
		
			</cfquery>
		
			<cfparam name="attributes.XFA_success" default="fuseaction=product.admin&review=list">
			
		</cfif><!--- Add or edit --->			
				
		</cfif><!--- Error Message Check --->
	
		<cfset attributes.UID = "">
			
	</cfif>
	
</cfif>

<!--- update admin menu  --->
<cfif FindNoCase(".admin", attributes.XFA_success)>
	<cfset attributes.admin_reload = "reviewcount">
</cfif>
