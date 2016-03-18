
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for color palettes: add, update, delete. Called by home.admin&colors=act --->

<!--- CSRF Check --->
<cfset keyname = "colorsEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfswitch expression="#mode#">
	<cfcase value="i">
		
		<cfquery name="Addcolors" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Colors
		(Palette_Name, LayoutFile, Bgcolor, Bgimage, MainTitle, MainText, MainLink, MainVLink, 
		BoxHBgcolor, BoxHText, BoxTBgcolor, BoxTText, InputHBgcolor, InputHText, InputTBgcolor, InputTText, 
		OutputHBgcolor, OutputHText, OutputTBgcolor, OutputTText, OutputTAltcolor, LineColor, 
		HotImage, SaleImage, NewImage, MainLineImage, MinorLineImage, FormReq, FormReqOB, PassParam)
		VALUES
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.palette_name)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.layoutfile)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Bgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Bgimage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainTitle)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainLink)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainVLink)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxHBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxHText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxTBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxTText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputHBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputHText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputTBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputTText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputHBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputHText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTBgcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTText)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTAltcolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.linecolor)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.hotImage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.saleImage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.newImage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.mainlineImage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.minorLineImage)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.formreq)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.formreqOB)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.PassParam)#">
			)
			</cfquery>	
		
	</cfcase>
			
	<cfcase value="u">
	
		<cfif submit is "Delete">
			
			<!--- Confirm that the palette is not being used
			in any Features, Categories, Products or Pages --->	
			<cfset attributes.error_message = "">	
				
				<cfquery name="check_categories"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Category_ID FROM #Request.DB_Prefix#Categories
				WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
				</cfquery>
				
				<cfif check_categories.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Palette used in Category #valuelist(check_categories.Category_ID)#. Please edit them first.">
				</cfif>

				<cfquery name="check_pages"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Page_ID FROM #Request.DB_Prefix#Pages
				WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
				</cfquery>
				
				<cfif check_pages.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Palette used in Page(s) #valuelist(check_pages.page_ID)#">
				</cfif>										
								
				<cfquery name="check_products"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Product_ID FROM #Request.DB_Prefix#Products
				WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
				</cfquery>
				
				<cfif check_products.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Palette used in Product(s) #valuelist(check_products.product_ID)#. Please edit them first.">
				</cfif>				
								
				<cfquery name="check_features"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Feature_ID FROM #Request.DB_Prefix#Features
				WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
				</cfquery>
				
				<cfif check_features.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Palette used in Feature(s) #valuelist(check_features.feature_ID)#. Please edit them first.">
				</cfif>
			
				
			<cfif NOT len(attributes.error_message)>
			
				<cfquery name="delete_colors"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Colors WHERE
				Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.color_ID#">
				</cfquery>
			
			<cfelse>
			
				<cfset attributes.error_message = "This Palette could not be deleted for the following reasons:<br/>" & attributes.error_message >
			
			</cfif>	
			
		<cfelse>
				
			<cfquery name="UpdateColors" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Colors
			SET 
			Palette_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Palette_Name)#">,
			LayoutFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.LayoutFile)#">,
			Bgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Bgcolor)#">,
			Bgimage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Bgimage)#">,
			MainTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainTitle)#">,
			MainText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainText)#">,
			MainLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainLink)#">,
			MainVLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainVLink)#">,
			BoxHBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxHBgcolor)#">,
			BoxHText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxHText)#">,
			BoxTBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxTBgcolor)#">,
			BoxTText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.BoxTText)#">,
			InputHBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputHBgcolor)#">,
			InputHText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputHText)#">,
			InputTBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputTBgcolor)#">,
			InputTText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.InputTText)#">,
			OutputHBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputHBgcolor)#">,
			OutputHText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputHText)#">,
			OutputTBgcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTBgcolor)#">,
			OutputTText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTText)#">,
			OutputTAltcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OutputTAltcolor)#">,
			LineColor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.LineColor)#">,
			HotImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.HotImage)#">,
			MainLineImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MainLineImage)#">,
			MinorLineImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.MinorLineImage)#">,
			NewImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.NewImage)#">,
			SaleImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.SaleImage)#">,
			FormReq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.FormReq)#">,
			FormReqOB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.FormReqOB)#">,
			PassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.PassParam)#">
			WHERE Color_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.color_ID#">
			</cfquery>

			<!--- Get New Settings --->
			<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>

			<cfinclude template="../../queries/qry_getsettings.cfm">

			<cfinclude template="../../queries/qry_getcolors.cfm">
			
			<!---- DOES NOT UPDATE color DIRECTORY OR FILES ---------->
		</cfif>

	</cfcase>
	
</cfswitch>
			
	

		
