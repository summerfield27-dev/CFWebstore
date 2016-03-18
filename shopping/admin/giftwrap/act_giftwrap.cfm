
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on giftwrap options: add, edit and delete. Asks for confirmation for deletions. Called by shopping.admin&giftwrap=act --->

<!--- CSRF Check --->
<cfset keyname = "giftwrapEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!---====== Prepare form variables =====--->
<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
	<cfset attributes.Priority = 9999>
</cfif>

<!--- Replace double carriage returns with HTML paragraph tags. --->
<cfset HTMLBreak = Chr(60) & 'br/' & Chr(62)>
<cfset HTMLParagraph = HTMLBreak & HTMLBreak>
<cfset LineBreak = Chr(13) & Chr(10)>
<cfset Short_Desc = Replace(Trim(attributes.Short_Desc), LineBreak & LineBreak, HTMLParagraph & LineBreak & LineBreak, "ALL")>
			
<cfswitch expression="#mode#">
	<cfcase value="i">
		
		<cfif NOT len(attributes.name)>
		
			<cfset attributes.error_message = "You must enter a name.">
			
		<cfelse>
		
		  <cftransaction isolation="SERIALIZABLE">
			<cfquery name="Add_Giftwrap" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Giftwrap 
			(Name, Short_Desc, Sm_Image, Price, Weight, Priority, Display)
			VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Name#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Short_Desc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Image)#">,		
			 <cfqueryparam cfsqltype="cf_sql_double" value="#iif(isNumeric(Attributes.Price),Attributes.Price,0)#">,
			 <cfqueryparam cfsqltype="cf_sql_double" value="#iif(isNumeric(Attributes.Weight),Attributes.Weight,0)#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Priority#">,
			 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Gift_Display#">
			)
			</cfquery>	
			
			 <cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			   SELECT MAX(Giftwrap_ID) AS maxid
			   FROM #Request.DB_Prefix#Giftwrap
			  </cfquery>
			
			  <cfset attributes.giftwrap_id = get_id.maxid>
		  </cftransaction>
		</cfif>
		
		</cfcase>
			
		<cfcase value="u">
		
			<cfif submit is "Delete">
			
				<cfquery name="delete_giftwrap"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Giftwrap 
				WHERE Giftwrap_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Giftwrap_id#">
				</cfquery>
								
			<cfelse>
		
				<cfif NOT len(attributes.name)>
		
					<cfset attributes.error_message = "You must enter a name.">
			
				<cfelse>
		
		
				<cfquery name="Update_Giftwrap" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Giftwrap
				SET 
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Name#">,
				Short_Desc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Short_Desc#">,
				Sm_Image = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Sm_Image)#">,	
				Price = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(isNumeric(Attributes.Price),Attributes.Price,0)#">,
				Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#iif(isNumeric(Attributes.Weight),Attributes.Weight,0)#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Gift_Display#">,
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Priority#">
				WHERE Giftwrap_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Giftwrap_ID#">		
				</cfquery>
							
				</cfif>			
					
			</cfif>
		
		</cfcase>

	</cfswitch>	
	

