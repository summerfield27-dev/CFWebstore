
<!--- CFWebstore, version 6.50 --->

<!--- Performs the user actions for GiftRegistry: add, update, delete.
Called by shopping.giftregistry&manage=act --->

<!--- CSRF Check --->
<cfset keyname = "registryEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfset attributes.error_message="">

<cfif len(attributes.expire_days)>
	<cfset attributes.Expire = dateadd('d',attributes.expire_days,attributes.Event_Date)>
<cfelse>
	<cfset attributes.Expire = dateadd('d','365',attributes.Event_Date)>
</cfif>

<!--- UUID to tag new inserts --->
<cfset NewIDTag = CreateUUID()>
<!--- Remove dashes --->
<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>

<cfswitch expression="#mode#">
	<cfcase value="i">
	
		<!--- check to make sure the user is valid --->
		<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT User_ID FROM #Request.DB_Prefix#Users
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
		</cfquery>

		<cfif finduser.recordcount is 1>
		
			<cftransaction>
				
			<cfquery name="Add_GiftRegistry" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			<cfif Request.dbtype IS "MSSQL">
				SET NOCOUNT ON
			</cfif>
			INSERT INTO #Request.DB_Prefix#GiftRegistry
				(ID_Tag, User_ID, Registrant, OtherName, 
				GiftRegistry_Type, Event_Date, Event_Name, Event_Descr, 
				City, State, Private, Order_Notification, 
				Live, Created, Expire)
			VALUES
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#finduser.User_ID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Registrant)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OtherName)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.GiftRegistry_Type)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Attributes.Event_Date#" null="#YesNoFormat(NOT isDate(attributes.Event_Date))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Event_Name)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(Attributes.Event_Descr)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.City)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.State)#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Private#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Order_Notification#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.live#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Expire#">
				)
				<cfif Request.dbtype IS "MSSQL">
					SELECT @@Identity AS New_ID
					SET NOCOUNT OFF
				</cfif>
			</cfquery>	
			
			<cfif Request.dbtype IS NOT "MSSQL">
				<cfquery name="Add_GiftRegistry" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				   SELECT GiftRegistry_ID AS New_ID
				   FROM #Request.DB_Prefix#GiftRegistry
				   WHERE ID_Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">
				 </cfquery>
			  </cfif>
	
			</cftransaction>
			
			<cfset attributes.GiftRegistry_id = Add_GiftRegistry.New_ID>
			
		<cfelse>
		
			<cfset attributes.error_message = "Can not add this Account. Not a valid User">
			
		</cfif>			
			
	</cfcase>
			
	<cfcase value="u">
		<cfif submit is "Delete">
			<!--- Delete registry items first --->
			<cfquery name="CheckItems" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			   DELETE FROM #Request.DB_Prefix#GiftItems
			   WHERE GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GiftRegistry_ID#">
			</cfquery>
		
			<cfquery name="delete_GiftRegistry"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#GiftRegistry 
			    WHERE GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GiftRegistry_ID#">
			</cfquery>			
			
		<cfelse>

			<!--- Update --->
			<!--- check to make sure the user is valid --->
			<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT User_ID FROM #Request.DB_Prefix#Users
				WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
			</cfquery>
		
			<cfif finduser.recordcount is 1>	

				<cfquery name="update_registry" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" >
				UPDATE #Request.DB_Prefix#GiftRegistry
				SET
				User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#finduser.User_ID#">, 
				Registrant = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Registrant)#">,
				OtherName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.OtherName)#">,
				GiftRegistry_Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.GiftRegistry_Type)#">,
				Event_Date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Attributes.Event_Date#" null="#YesNoFormat(NOT isDate(attributes.Event_Date))#">,
				Event_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.Event_Name)#">,
				Event_Descr = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(Attributes.Event_Descr)#">,
				City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.City)#">,
				State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Attributes.State)#">,
				Private =  <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Private#">,
				Order_Notification =  <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Order_Notification#">,
				Live = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.live#">,
				Expire = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Expire#">
				WHERE GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GiftRegistry_ID#">
				</cfquery>
			
			<cfelse>
			
				<cfset attributes.error_message = "Could not update Account. Not a valid User">
		
			</cfif>			
			
		</cfif>

	</cfcase>	
</cfswitch>
			
