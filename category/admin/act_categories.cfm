
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for categories: add, update, delete. Called by category.admin&category=act --->

<!--- CSRF Check --->
<cfset keyname = "categoryEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfset Message = "">

<!---====== Prepare form variables =====--->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 9999>
</cfif>

<!--- Replace double carriage returns with HTML paragraph tags. --->
<cfset HTMLBreak = Chr(60) & 'br/' & Chr(62)>
<cfset HTMLParagraph = HTMLBreak & HTMLBreak>
<cfset LineBreak = Chr(13) & Chr(10)>
<cfset Long_Desc = Replace(Trim(attributes.Long_Desc), LineBreak & LineBreak, HTMLParagraph & LineBreak & LineBreak, "ALL")>
<cfset Short_Desc = Replace(Trim(attributes.Short_Desc), LineBreak & LineBreak, HTMLParagraph & LineBreak & LineBreak, "ALL")>
<cfset Short_Desc = CleanHighAscii(Short_Desc)>
<cfset Long_Desc = CleanHighAscii(Long_Desc)>

<!--- Replace any instances of the reserved characters --->
<cfset Name = Trim(attributes.Name)>
<cfset Name = ReplaceList(Name, ":", ";")>
<!----
<cfset Name = HTMLEditFormat(Name)>
--->
<!--- Calculate Parent Strings ---->
<cfset Parent_ID = attributes.PID>
<cfinclude template="act_calc_parents.cfm">


<cfswitch expression="#mode#">
	<cfcase value="i">
	
		<cftransaction isolation="SERIALIZABLE">
				
		<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Categories
		(Parent_ID, CatCore_ID, Name, Short_Desc, Long_Desc, Metadescription, Keywords, TitleTag, 
		Sm_Image, Lg_Image, Sm_Title, Lg_Title, PassParam, AccessKey, CColumns, PColumns, Color_ID, 
		ProdFirst, Display, Priority, Highlight, Sale, ParentIDs, ParentNames, DateAdded)
		VALUES(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Pid#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Catcore_ID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Short_Desc#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Long_Desc#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(metadescription)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(keywords)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.titletag)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Image)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Lg_Image)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Title)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Lg_Title)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Passparam)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.AccessKey),Attributes.AccessKey,0)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.CColumns)#" null="#YesNoFormat(Val(Attributes.CColumns) LTE 0)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.PColumns)#" null="#YesNoFormat(Val(Attributes.PColumns) LTE 0)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.Cat_Color_ID)#" null="#YesNoFormat(Val(Attributes.Cat_Color_ID) LTE 0)#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.ProdFirst#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Cat_Display#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Priority#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Highlight#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.sale#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CatIDs#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#CatNames#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
			</cfquery>	

		<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			SELECT MAX(Category_ID) AS maxid 
			FROM #Request.DB_Prefix#Categories
			</cfquery>
		
		<cfset attributes.CID = get_id.maxid>
		
		</cftransaction>
		
		<cfinclude template="act_update_discounts.cfm">
		
	</cfcase>
			
	<cfcase value="u">
		<cfif frm_submit is "Delete">
		
			<cfinclude template="act_delete_category.cfm">
							
		<cfelse>
					
			<!--- Make changes to discounts --->
			<cfinclude template="act_update_discounts.cfm">
					
			<cfquery name="Update_Categories" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Categories
			SET 	
			Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Pid#">,
			CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Catcore_ID#">,
			Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
			Short_Desc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Short_Desc#">,
			Long_Desc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Long_Desc#">,
			Metadescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(metadescription)#">,
			Keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(keywords)#">,
			TitleTag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.titletag)#">,
			Sm_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Sm_Image)#">,
			Lg_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Lg_Image)#">,
			Sm_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Sm_Title)#">,
			Lg_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Lg_Title)#">,
			PassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.PassParam)#">,
			AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.AccessKey),attributes.AccessKey,0)#">,
			CColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.CColumns)#" null="#YesNoFormat(Val(attributes.CColumns) LTE 0)#">,
			PColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.PColumns)#" null="#YesNoFormat(Val(attributes.PColumns) LTE 0)#">,
			Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(attributes.Cat_Color_ID)#" null="#YesNoFormat(Val(attributes.Cat_Color_ID) LTE 0)#">,
			ProdFirst = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.ProdFirst#">,
			Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Cat_Display#">,
			Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Priority#">,
			Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Highlight#">,
			Sale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Sale#">,
			ParentIDs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CatIDs#">,
			ParentNames = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#CatNames#">
			WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
			</cfquery>
			
			<!--- If changes made to discounts, update any products in the category --->
			<cfif isDefined("attributes.Discounts") and Compare(attributes.Discounts, attributes.CurrDiscounts) IS NOT 0>
				<cfinclude template="act_update_proddiscounts.cfm">			
			</cfif>
				
			<cfinclude template="act_update_children.cfm">

		</cfif>
	
	</cfcase>

</cfswitch>	

<cfscript>
	//Update top category queries
	Application.objMenus.getTopCats(rootcat="0", reset='yes');
	//Update all categories query
	Application.objMenus.getAllCats(reset='yes');
	
	//Update current user's menus
	StructDelete(Session, 'SideMenus');
</cfscript>	

		