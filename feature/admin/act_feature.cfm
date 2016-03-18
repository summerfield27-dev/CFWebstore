
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for features: add, update, delete. Called by feature.admin&feature=act --->

<!--- CSRF Check --->
<cfset keyname = "featureEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">
<cfparam name="attributes.CID_list" default="">

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
			
<cfswitch expression="#mode#">
	<cfcase value="i">
		
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Features
			(User_ID, Feature_Type, Name, Author, Copyright, Display, Approved, Start, Expire, 
			Priority, AccessKey, Highlight, Reviewable, Display_Title, Sm_Title, Sm_Image, Short_Desc, 
			Lg_Title, Lg_Image, Long_Desc, TitleTag, Metadescription, Keywords, PassParam, Color_ID, Created)
			VALUES(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.UID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.feature_type#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Author)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.copyright)#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.feat_display#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.approved#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start#" null="#YesNoFormat(NOT isDate(attributes.start))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expire#" null="#YesNoFormat(NOT isDate(attributes.expire))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value=" #Attributes.priority#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(trim(Attributes.AccessKey)),trim(Attributes.AccessKey),0)#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.highlight#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Reviewable#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.display_title#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Title)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_image)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#short_desc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.lg_title)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.lg_image)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#long_desc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.titletag)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.metadescription)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.keywords)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.passparam)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feat_Color_ID#" null="#YesNoFormat(NOT isNumeric(attributes.Feat_Color_ID))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.created#" null="#YesNoFormat(NOT isDate(attributes.created))#">
			)
			</cfquery>	
			
			 <cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			   SELECT MAX(Feature_ID) AS maxid
			   FROM #Request.DB_Prefix#Features
			  </cfquery>
			
			  <cfset attributes.Feature_id = get_id.maxid>
		</cftransaction>
		</cfcase>
			
		<cfcase value="u">
			
			<cfquery name="delete_categories"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Feature_Category
			WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
			</cfquery>
		
			<cfif frm_submit is "Delete">
					
				<cfquery name="delete_reviews" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#FeatureReviews
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>	

				<cfquery name="delete_related_prod" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Feature_Product
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>	
						
				<cfquery name="delete_related_feat" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Feature_Item
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>	
										
				<cfquery name="delete_images" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Sm_Image, Lg_Image, Sm_Title, Lg_Title
				FROM #Request.DB_Prefix#Features 
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>		
				
				<cfset attributes.image_list="">		
				<cfif len(delete_images.sm_image)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.sm_image)>
				</cfif>
				<cfif len(delete_images.sm_title)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.sm_title)>
				</cfif>
				<cfif len(delete_images.lg_image)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_image)>
				</cfif>
				<cfif len(delete_images.lg_title)>
					<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_title)>
				</cfif>		
									
				<cfquery name="delete_Features"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Features 
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>
								
			<cfelse>
				
		
				<cfquery name="Update_Features" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Features
				SET User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">,
				Feature_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.feature_type#">,
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
				Author = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Author)#">,
				Copyright = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.copyright)#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.feat_display#">,
				Approved = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.approved#">,
				Start = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start#" null="#YesNoFormat(NOT isDate(attributes.start))#">,
				Expire = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expire#" null="#YesNoFormat(NOT isDate(attributes.expire))#">,
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
				AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(trim(Attributes.AccessKey)),trim(Attributes.AccessKey),0)#">,
				Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.highlight#">,
				Reviewable = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Reviewable#">,
				Display_Title = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.display_title#">,
				Sm_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Title)#">,
				Sm_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_image)#">,
				Short_Desc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#short_desc#">,
				Lg_Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.lg_title)#">,
				Lg_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.lg_image)#">,
				Long_Desc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#long_desc#">,
				TitleTag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.titletag)#">,
				Metadescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.metadescription)#">,
				Keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.keywords)#">,
				PassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.passparam)#">,
				Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feat_Color_ID#" null="#YesNoFormat(NOT isNumeric(attributes.Feat_Color_ID))#">,
				Created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.created#" null="#YesNoFormat(NOT isDate(attributes.created))#">
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_id#">
				</cfquery>
							
			</cfif>
		
		</cfcase>

	</cfswitch>	
	
	
	<!--- Add Category ----->
	<cfif len(attributes.CID_list) and frm_submit is not "Delete">
		<cfloop index="thisID" list="#attributes.CID_list#">
			<cfquery name="Add_Feature_Category" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Feature_Category
			(Feature_ID, Category_ID)
			VALUES(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_ID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> )
			</cfquery>
		</cfloop>
	</cfif>
		
		
			


