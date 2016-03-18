<!--- CFWebstore, version 6.50 --->

<!--- Saves the Feature Review Settings. Called from produts.admin&review=settings. --->

<!--- CSRF Check --->
<cfset keyname = "featReviewSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="EditUserSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Settings
	SET 
	FeatureReviews = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#iif(isNumeric(attributes.FeatureReviews),attributes.FeatureReviews,0)#">,
	FeatureReview_Approve = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.FeatureReview_Approve#">,
	FeatureReview_Flag = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.FeatureReview_Flag#">,
	FeatureReview_Add =<cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.FeatureReview_Add#">
</cfquery>

<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../../queries/qry_getsettings.cfm">


