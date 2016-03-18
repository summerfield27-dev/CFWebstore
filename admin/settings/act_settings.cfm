

<!--- CFWebstore, version 6.50 --->

<!--- Updates the main site settings. Called by home.admin&settings=save --->

<!--- CSRF Check --->
<cfset keyname = "settingsEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!--- Initialize the values received by the form --->
<cfset fieldlist="DS,sitename,Merchant,HomeCountry,MerchantEmail,Webmaster,DefaultImages,Editor,MoneyUnit,InvLevel,WeightUnit,SizeUnit,ItemSort,OrderButtonText,OrderButtonImage,collectionname,locale,metadescription,keywords,email_server,email_port,email_user,email_pass,sitelogo,Default_Fuseaction,CurrExchange,CurrExLabel">	
	
<!--- Set text fields defaults to blanks --->		
<cfloop list="#fieldlist#" index="counter">
	<cfparam name="attributes.#counter#" default="">
</cfloop>

<cfset fieldlist="ShowInStock,OutofStock,ShowRetail,UseSES,UseVerity,CColumns,PColumns,MaxProds,prodRoot,CachedProds,featureRoot,maxFeatures,color_id,admin_new_window">	
	
<!--- Set numeric field defaults to 0 --->		
<cfloop list="#fieldlist#" index="counter">
	<cfparam name="attributes.#counter#" default="0">
</cfloop>


<!--- Change carriage returns to HTML breaks --->
<cfset HTMLBreak = Chr(60) & 'br/' & Chr(62)>
<cfset LineBreak = Chr(13) & Chr(10)>
<cfset attributes.Merchant = Replace(Trim(attributes.Merchant), LineBreak, HTMLBreak & LineBreak, "ALL")>

<cfset attributes.CColumns = iif(attributes.CColumns LTE 1, 1, "#attributes.CColumns#")>
<cfset attributes.PColumns = iif(attributes.PColumns LTE 1, 1, "#attributes.PColumns#")>



<cfif NOT isNumeric(Trim(attributes.MaxProds))>
	<cfset attributes.MaxProds = 9999>
<cfelse>
	<cfset attributes.MaxProds = attributes.MaxProds>
</cfif>

<cfif NOT isNumeric(Trim(attributes.maxFeatures))>
	<cfset attributes.maxFeatures = 9999>
<cfelse>
	<cfset attributes.maxFeatures = attributes.maxFeatures> 
</cfif>

<!--- If MySQL, replace backslashes in the filepath --->
<!--- <cfif Request.dbtype IS "MySQL">
	<cfset attributes.FilePath = Replace(attributes.FilePath, "\", "\\", "All")>
</cfif> --->

<!--- Check for email server username and password. Put onto the server address for proper authentication --->
<cfif len(attributes.email_user) AND len(attributes.email_pass)>
	<cfset attributes.email_server = "#attributes.email_user#:#attributes.email_pass#@#attributes.email_server#">
</cfif>

<cfquery name="EditSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Settings
SET 
SiteName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sitename#">,
SiteLogo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sitelogo#">,
Merchant = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.Merchant#">,
HomeCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HomeCountry#">,
Locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Locale#">,
MerchantEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MerchantEmail#">,
Email_Server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email_server#">,
Email_Port = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.email_port#" null="#YesNoFormat(NOT isNumeric(attributes.email_port))#">,
Webmaster = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Webmaster#">,
DefaultImages = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DefaultImages#">,
MoneyUnit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.MoneyUnit)#">,
WeightUnit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.WeightUnit)#">,
SizeUnit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.SizeUnit)#">,
InvLevel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.InvLevel#">,
ShowRetail = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowRetail#">,
ShowInStock = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.showinstock#">,
OutofStock = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OutofStock#">,
CurrExchange = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CurrExchange#">,
CurrExLabel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.CurrExLabel)#">,
ItemSort = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ItemSort#">,

OrderButtonText = '#Trim(attributes.OrderButtonText)#',
OrderButtonImage = '#Trim(attributes.OrderButtonImage)#',
UseSES = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseSES#">,
UseVerity = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseVerity#">,
CollectionName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CollectionName#">,
Metadescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(metadescription)#">,
Keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(keywords)#">,
CColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.CColumns) AND Attributes.CColumns GTE 1,Attributes.CColumns,1)#">,
PColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.PColumns) AND Attributes.PColumns GTE 1,Attributes.PColumns,1)#">,
ProdRoot = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prodRoot#" null="#YesNoFormat(NOT isNumeric(attributes.prodRoot))#">,
MaxProds = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MaxProds#" null="#YesNoFormat(NOT isNumeric(attributes.MaxProds))#">,
CachedProds = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.CachedProds#">,
FeatureRoot = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FeatureRoot#" null="#YesNoFormat(NOT isNumeric(attributes.FeatureRoot))#">,
MaxFeatures = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MaxFeatures#" null="#YesNoFormat(NOT isNumeric(attributes.MaxFeatures))#">,
Admin_New_Window = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.admin_new_window#">,
Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Color_ID#">,
Default_Fuseaction =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Default_Fuseaction#">
</cfquery>


<!--- Turn on Shipping for Home Country --->
<cfquery name="EditShipping" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Countries
	SET Shipping = 1
	WHERE Abbrev = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.HomeCountry,1,"^")#">
</cfquery>

<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../queries/qry_getsettings.cfm">
<cfinclude template="../../queries/qry_getcolors.cfm">
<cfinclude template="../../queries/qry_getcountries.cfm">



