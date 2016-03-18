
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for pages: add, update, delete. Called by page.admin&do=act --->

<!--- CSRF Check --->
<cfset keyname = "pageEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!---====== Prepare form variables =====--->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 9999>
</cfif>

<!--- Replace double carriage returns with HTML paragraph tags. --->
<cfset HTMLBreak = Chr(60) & 'br/' & Chr(62)>
<cfset HTMLParagraph = HTMLBreak & HTMLBreak>
<cfset LineBreak = Chr(13) & Chr(10)>
<cfset attributes.PageText = Replace(Trim(attributes.PageText), LineBreak & LineBreak, HTMLParagraph & LineBreak & LineBreak, "ALL")>
<cfset attributes.PageText = CleanHighAscii(attributes.PageText)>
		
<cfswitch expression="#mode#">
	<cfcase value="i">

		<cftransaction isolation="SERIALIZABLE">

		<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			SELECT MAX(Page_ID) AS maxid 
			FROM #Request.DB_Prefix#Pages
			</cfquery>
		
		<cfif get_id.maxid gt 0>
			<cfset attributes.Page_ID = get_id.maxid + 1>
		<cfelse>
			<cfset attributes.Page_ID = 1>
		</cfif>
		
		<cfif trim(attributes.page_url) is "">
			<cfif len(trim(attributes.PageAction))>
				<cfset attributes.page_url = "#thisself#?fuseaction=page.#trim(attributes.pageaction)#">
			<cfelse>
				<cfset attributes.page_url = "#thisself#?fuseaction=page.display&page_id=#attributes.page_ID#">
			</cfif>
		</cfif>
		
		<cfif attributes.parent_id is "HEADER">
			<cfset attributes.Parent_id = attributes.Page_id>
			<cfset title_priority = attributes.priority>
			<cfset attributes.priority = 0>
		<cfelse>
			<cfset title_priority = 0>
		</cfif>

		<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Pages
			(Page_ID, Page_URL, Display, Page_Name, PageAction, Page_Title, Sm_Title, Lg_Image, Lg_Title, 
			CatCore_ID, PassParam, Color_ID, PageText, Priority, Href_Attributes, AccessKey, 
			Parent_ID, Title_Priority, TitleTag, Metadescription, Keywords)
		VALUES(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Page_ID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.page_url)#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Page_Display#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Attributes.Page_name)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.PageAction#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Attributes.Page_title)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.sm_title#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Lg_image#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Lg_title#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.Catcore_ID),Attributes.Catcore_ID,0)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Passparam#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Page_Color_ID#" null="#YesNoFormat(NOT isNumeric(Attributes.Page_Color_ID))#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Attributes.PageText#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Priority#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.href_attributes#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.AccessKey),Attributes.AccessKey,0)#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.parent_id#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#title_priority#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.titletag)#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.metadescription)#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.keywords)#">
			)
			</cfquery>	
		</cftransaction>
		
		<!--- ADDITIONAL PROCESSING HERE ----->
		
		</cfcase>
			
		<cfcase value="u">
			<cfif frm_submit is "Delete">
				
				<cfquery name="delete_images"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Lg_Image, Lg_Title
				FROM #Request.DB_Prefix#Pages WHERE
				Page_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Page_ID#">
				</cfquery>		
				
				<cfset attributes.image_list="">		
				<cfif len(delete_images.lg_image)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_image)>
				</cfif>
				<cfif len(delete_images.lg_title)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_title)>
				</cfif>		
								
				<cfquery name="delete_Page"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Pages 
				WHERE Page_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Page_ID#">
				</cfquery>
												
			<cfelse>
			
				<cfif trim(attributes.page_url) is "">
					<cfif len(trim(attributes.PageAction))>
						<cfset attributes.page_url = "#self#?fuseaction=page.#trim(attributes.pageaction)#">
					<cfelse>
						<cfset attributes.page_url = "#self#?fuseaction=page.display&page_id=#attributes.page_ID#">
					</cfif>
				</cfif>
		
				<cfif trim(attributes.parent_id) is "HEADER">
					<cfset attributes.Parent_id = attributes.Page_id>
					<cfset title_priority = attributes.priority>
					<cfset attributes.priority = 0>
				<cfelse>
					<cfset title_priority = 0>
				</cfif>
				
				<cfquery name="EditPage" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Pages
				SET 
				Page_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.page_url)#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Page_Display#">,
				Page_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Attributes.Page_name)#">,
				Page_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Attributes.Page_title)#">,
				PageAction = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.PageAction#">,
				Sm_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.sm_title#">,
				Lg_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Lg_title#">,
				Lg_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Lg_image#">,
				PassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Passparam#">,
				CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.Catcore_ID),Attributes.Catcore_ID,0)#">,
				Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Page_Color_ID#" null="#YesNoFormat(NOT isNumeric(Attributes.Page_Color_ID))#">,
				Href_Attributes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.href_attributes#">,
				AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(Attributes.AccessKey),Attributes.AccessKey,0)#">,
				Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#">,
				PageText = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Attributes.PageText#">,
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
				Title_Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#title_priority#">,
				TitleTag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.titletag)#">,
				Metadescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.metadescription)#">,
				Keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.keywords)#">
				WHERE Page_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Page_ID#">
				</cfquery>
							
			</cfif>
		
		</cfcase>

	</cfswitch>	
	

<cfscript>
	//Update main page queries
	Application.objMenus.getMenuPages(reset='yes');
	Application.objMenus.getAllPages(reset='yes');
	
	//Update current user's menus
	if (isDefined("Session.SideMenus"))
		StructDelete(Session, 'SideMenus');
</cfscript>	


			
