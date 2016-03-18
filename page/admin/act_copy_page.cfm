
<!--- CFWebstore, version 6.50 --->

<!--- Creates a copy of a store page. Called by page.admin&do=copy --->

<!--- CSRF Check --->
<cfset keyname = "pageList">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!--- Get the page to copy --->
<cfinclude template="qry_get_page.cfm">

<cfif qry_get_page.recordcount>
	<cftransaction isolation="SERIALIZABLE">

	<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		   SELECT MAX(page_ID) AS maxid
		   FROM #Request.DB_Prefix#Pages
	</cfquery>
	
	<cfset attributes.page_id = get_id.maxid + 1>
	
	<!--- Add new page, set display to 0 until approved. --->
	<cfquery name="AddCopyPage" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Pages 
		(Page_ID, Page_URL, PageAction, CatCore_ID, PassParam, Display, Page_Name, Page_Title, 
		Sm_Image, Lg_Image, Sm_Title, Lg_Title, Color_ID, PageText, System, Href_Attributes, 
		AccessKey, Priority, Parent_ID, Title_Priority, TitleTag, Metadescription, Keywords)
		VALUES (
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.page_id#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Page_URL#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.PageAction#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.CatCore_ID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.PassParam#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="Copy of #qry_get_page.Page_Name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Page_Title#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Sm_Image#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Lg_Image#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Sm_Title#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Lg_Title#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.Color_ID#" null="#YesNoFormat(NOT isNumeric(qry_get_page.Color_ID))#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#qry_get_page.PageText#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Href_Attributes#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.AccessKey#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.Priority#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.Parent_ID#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#qry_get_page.Title_Priority#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.TitleTag#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Metadescription#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#qry_get_page.Keywords#">)
	</cfquery>
	
	</cftransaction>
	
	<cfset do = "edit">
</cfif>		

<cfsetting enablecfoutputonly="no">
