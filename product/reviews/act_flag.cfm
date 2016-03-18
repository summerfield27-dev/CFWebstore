<!--- CFWebstore, version 6.50 --->

<!--- This template flags a review for Admin review. It is invoked by a link in the product review:
<a href="#self#?fuseaction=product.reviews&do=flag&Product_ID=#Product_ID#&Review_ID=#Review_ID##request.token2#">Flag for Editor Review</a>
 --->

<cfparam name="attributes.Review_ID" default="0">
<cfparam name="attributes.Product_ID" default="0">

<cfif attributes.Review_ID AND isNumeric(attributes.Review_ID)>
	
	<!--- CSRF Check --->
	<cfset keyname = "prodReviewFlag">
	<cfinclude template="../../includes/act_check_csrf_key.cfm">

	<cfquery name="Flag_Review" datasource="#request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#ProductReviews
	SET	NeedsCheck = 1
	WHERE Review_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Review_ID#">
	</cfquery>

	<!--- Alert confirmation --->
	<cfparam name = "attributes.message" default="This Review has been flagged for Editor Review.">
	<cfparam name = "attributes.error_message" default="">
	<cfparam name = "attributes.box_title" default="Thanks">
	<cfparam name = "attributes.XFA_success" default="#Replace(session.page,self & '?','','ALL')#">
	<cfinclude template="../../includes/form_confirmation.cfm">
	
	<!---- Use the following if you don't want the alert confirmation 
	<cflocation url="#session.page#" addtoken="NO">
	---->

</cfif>
