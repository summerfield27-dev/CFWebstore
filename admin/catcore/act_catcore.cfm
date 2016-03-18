
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for page templates: add, update, delete. Called by home.admin&catcore=act --->

<!--- CSRF Check --->
<cfset keyname = "catcoreEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.c_products" default="0">
<cfparam name="attributes.c_features" default="0">
<cfparam name="attributes.c_category" default="0">
<cfparam name="attributes.c_page" default="0">

<cfif isdefined("attributes.template_type")>
	<cfloop index="i" list="#attributes.template_type#">
		<cfset attributes['c_' & i] = 1>
	</cfloop>
</cfif>


<cfswitch expression="#mode#">

	<cfcase value="i">

		<cftransaction isolation="SERIALIZABLE">

			<cfquery name="getnum" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT MAX(CatCore_ID) AS maxnum FROM #Request.DB_Prefix#CatCore
			</cfquery>
			
			<cfquery name="Addcatcore" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#CatCore 
			(CatCore_ID, Catcore_Name, PassParams, Template, Products, Features, Category, Page)
				VALUES
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(getnum.maxnum), getnum.maxnum+1, 1)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.catcore_Name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.passparams#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.template)#">,				
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_products#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_features#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_category#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_page#"> 
		 	)
			</cfquery>	
			
		</cftransaction>		

	</cfcase>
			
	<cfcase value="u">
	
		<cfif submit is "delete">
		
<!--- Confirm that the palette is not being used
			in any Features, Categories, Products or Pages --->	
			<cfset attributes.error_message = "">	
				
				<cfquery name="check_categories"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT Category_ID FROM #Request.DB_Prefix#Categories
					WHERE CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CatCore_ID#">
				</cfquery>
				
				<cfif check_categories.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Template used in Category #valuelist(check_categories.Category_ID)#. Please delete or edit them first.">
				</cfif>

				<cfquery name="check_pages"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT Page_ID FROM #Request.DB_Prefix#Pages
					WHERE CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CatCore_ID#">
				</cfquery>
				
				<cfif check_pages.recordcount gt 0>
					<cfset attributes.error_message = attributes.error_message &  "<br/>Template used in Page(s) #valuelist(check_pages.page_ID)#. Please delete or edit them first.">
				</cfif>		
						
				
			<cfif NOT len(attributes.error_message)>
			
				<cfquery name="deleteCatCore" dbtype="ODBC" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					DELETE FROM #Request.DB_Prefix#CatCore 
					WHERE CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CatCore_ID#">
				</cfquery>
			
			<cfelse>
			
				<cfset attributes.error_message = "This Category Template could not be deleted for the following reasons:<br/>" &  attributes.error_message >
			
			</cfif>		
					
				
		<cfelse>
			<cfquery name="Addcatcore" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#CatCore 
				SET Catcore_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.catcore_Name#">,
				PassParams = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.passparams#">,
				Template = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template#">,
				Products = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_products#">,
				Features = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_features#">,
				Category = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_category#">,
				Page = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.c_page#">
				WHERE CatCore_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CatCore_ID#">
			</cfquery>	

		</cfif>
	</cfcase>

</cfswitch>
			


