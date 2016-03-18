
<!--- CFWebstore, version 6.50 --->

<!--- Creates a copy of a feature. Called by feature.admin&feature=copy --->

<!--- CSRF Check --->
<cfset keyname = "featureList">
<cfinclude template="../../includes/act_check_csrf_key.cfm">


<!--- Get the feature to copy --->
<cfquery name="GetFeature" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Features F
	WHERE F.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
</cfquery>

<cftransaction isolation="SERIALIZABLE">
	<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		INSERT INTO Features
			(User_ID, Feature_Type, Name, Author, Copyright, Display, Approved, Start, Expire, 
			Priority, AccessKey, Highlight, Reviewable, Display_Title, Sm_Title, Sm_Image, Short_Desc, 
			Lg_Title, Lg_Image, Long_Desc, TitleTag, Metadescription, Keywords, PassParam, Color_ID, Created)
		VALUES(
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetFeature.user_ID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFeature.feature_type#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="COPY OF #GetFeature.Name#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.Author)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.copyright)#">,
			 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetFeature.display#">,
			 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetFeature.approved#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetFeature.start#" null="#YesNoFormat(NOT len(GetFeature.start))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetFeature.expire#" null="#YesNoFormat(NOT len(GetFeature.expire))#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetFeature.priority#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(trim(GetFeature.AccessKey)),Trim(GetFeature.AccessKey),0)#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetFeature.highlight#">,
			 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetFeature.Reviewable#">,
			 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetFeature.display_title#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.Sm_Title)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.Sm_image)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#GetFeature.short_desc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.lg_title)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(GetFeature.lg_image)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#GetFeature.long_desc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFeature.TitleTag#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFeature.metadescription#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFeature.keywords#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFeature.passparam#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetFeature.Color_ID#" null="#YesNoFormat(NOT isNumeric(GetFeature.Color_ID))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
	</cfquery>	
			
	<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		   SELECT MAX(Feature_ID) AS maxid
		   FROM #Request.DB_Prefix#Features
	</cfquery>
			
	<cfset attributes.Feature_id = get_id.maxid>
</cftransaction>
		
	
<!--- Copy feature categories --->
<cfquery name="GetFeatureCats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Category_ID 
	FROM #Request.DB_Prefix#Feature_Category
	WHERE Feature_Category.Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
</cfquery>

<cfloop query="GetFeatureCats">

	<cfquery name="AddFeatureCat" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	INSERT INTO #Request.DB_Prefix#Feature_Category
	(Feature_ID, Category_ID)
	VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Feature_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#category_ID#">)
	</cfquery>
	
</cfloop>


