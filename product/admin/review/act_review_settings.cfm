<!--- CFWebstore, version 6.50 --->

<!--- Saves the Product Review Settings. Called from produts.admin&review=settings. --->

<!--- CSRF Check --->
<cfset keyname = "prodReviewSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="EditUserSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Settings
	SET 
	ProductReviews = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProductReviews#">,
	ProductReview_Approve = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProductReview_Approve#">,
	ProductReview_Flag = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProductReview_Flag#">,
	ProductReview_Add = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ProductReview_Add#">,
	ProductReview_Rate = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ProductReview_Rate#">,
	ProductReviews_Page = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ProductReviews_Page#">
</cfquery>

<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../../queries/qry_getsettings.cfm">

