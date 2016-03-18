
<!--- CFWebstore, version 6.50 --->

<!--- Saves the UserSettings. Called from users.admin&settings=save. --->

<!--- CSRF Check --->
<cfset keyname = "userSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfset TermsText = CleanHighAscii(attributes.TermsText)>

<cfset AffPercent = iif(isNumeric(attributes.AffPercent), Evaluate(DE('#attributes.AffPercent#/100')), 0)>

<cfquery name="EditUserSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#UserSettings
	SET UseRememberMe = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseRememberMe#">,
	EmailAsName = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.EmailAsName#">,
	StrictLogins = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.StrictLogins#">,
	MaxDailyLogins = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.MaxDailyLogins), attributes.MaxDailyLogins, 0)#">,
	MaxFailures = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.MaxFailures), attributes.MaxFailures, 0)#">,
	UseStateList = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseStateList#">,
	UseStateBox = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseStateBox#">,
	RequireCounty = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.RequireCounty#">,
	UseCountryList = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseCountryList#">,
	UseResidential = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseResidential#">,
	UseGroupCode = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseGroupCode#">,
	UseBirthdate = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseBirthdate#">,
	UseTerms = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseTerms#">,
	TermsText = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#TermsText#">,
	UseCCard = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseCCard#">,
	UseEmailConf = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseEmailConf#">,
	UseEmailNotif = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseEmailNotif#">,
	MemberNotify = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.MemberNotify#">,
	AllowAffs = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.allowaffs#">,
	AffPercent = <cfqueryparam cfsqltype="cf_sql_double" value="#AffPercent#">,
	AllowWholesale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.allowWholesale#">,
	UseShipTo = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseShipTo#">,
	UseAccounts = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseAccounts#">,
	ShowAccount = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowAccount#">,
	ShowDirectory = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowDirectory#">,
	ShowSubscribe = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowSubscribe#">
</cfquery>

<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../qry_get_user_settings.cfm">



