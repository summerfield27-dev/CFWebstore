
<!--- CFWebstore, version 6.50 --->

<!--- Used to save the Shipping Settings for the store. Called by shopping.admin&shipping=settings --->

<cfparam name="session.ship_id" default="0">
<cfparam name="attributes.action" default="edit">
<cfset attributes.error_message = "">

<cfif isDefined( "attributes.Submit_shipping" )>

	<!--- CSRF Check --->
	<cfset keyname = "shipSettings">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<!--- Replace double carriage returns with HTML paragraph tags. --->
	<cfset HTMLBreak = Chr(60) & 'br/' & Chr(62)>
	<cfset HTMLParagraph = HTMLBreak & HTMLBreak>
	<cfset LineBreak = Chr(13) & Chr(10)>
	<cfset NoShipMess = Replace(Trim(attributes.NoShipMess), LineBreak & LineBreak, HTMLParagraph & LineBreak & LineBreak, "ALL")>
	<cfset ShipHand = Trim(attributes.ShipHand) / 100>
	
	<cfset customList = "Price,Price2,Weight,Weight2,Items">

	<cfif session.Ship_ID IS 0>
	
		<!--- Make sure we aren't adding a shipping type already used --->
		<cfquery name="CheckUsed" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT ID FROM #Request.DB_Prefix#ShipSettings
			WHERE ShipType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShipType#"> 
		</cfquery>
		
		<cfif CheckUsed.RecordCount>
			<cfset attributes.error_message = "You may only use a shipping type once.<br/> Please select a different shipping type.">
		
		<!--- Make sure we aren't adding a second custom shipping type --->
		<cfelseif ListFind( customList, attributes.ShipType )>
			<cfquery name="CheckCustom" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT ID FROM #Request.DB_Prefix#ShipSettings
				WHERE ShipType IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#customList#" list="true"> )
			</cfquery>
			
			<cfif CheckCustom.RecordCount>
				<cfset attributes.error_message = "You may only use one custom shipping type.<br/> Please select a different shipping type.">
			</cfif>
		</cfif>
		
		<cfif NOT len(attributes.error_message)>
		
			<!--- UUID to tag new inserts --->
			<cfset NewIDTag = CreateUUID()>
			<!--- Remove dashes --->
			<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>
		
			<cftransaction>
				<cfquery name="AddShipSetting" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				<cfif Request.dbtype IS "MSSQL">
					SET NOCOUNT ON
				</cfif>
				INSERT INTO #Request.DB_Prefix#ShipSettings
				( 	ID_Tag, ShipType, AllowNoShip, InStorePickup, ShowEstimator, UseDropShippers, 
		          	ShowFreight, NoShipMess, NoShipType, ShipBase, ShipHand )
				VALUES
				( 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShipType#">,
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.AllowNoShip#">,
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.InStorePickup#">,
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowEstimator#">,
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseDropShippers#">,
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowFreight#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#NoShipMess#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.NoShipType)#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#Trim(attributes.ShipBase)#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#ShipHand#">
				)
				<cfif Request.dbtype IS "MSSQL">
					SELECT @@Identity AS newID
					SET NOCOUNT OFF
				</cfif>
				</cfquery>
				
				<!--- Get New Ship ID Number --->
				<cfif Request.dbtype IS NOT "MSSQL">
					<cfquery name="AddShipSetting" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT ID AS newID 
					FROM #Request.DB_Prefix#ShipSettings
					WHERE ID_Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">
					</cfquery>
				</cfif>
			
			</cftransaction>
			
			<cfset attributes.ship_id = AddShipSetting.newID>
		</cfif>

	<cfelse>
	
		<!--- Make sure we aren't adding a shipping type already used --->
		<cfquery name="CheckUsed" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT ID FROM #Request.DB_Prefix#ShipSettings
			WHERE ShipType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShipType#"> 
			AND ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ship_ID#">
		</cfquery>
		
		<cfif CheckUsed.RecordCount>
			<cfset attributes.error_message = "You may only use a shipping type once.<br/> Please select a different shipping type.">
		
		<!--- Make sure we aren't adding a second custom shipping type --->
		<cfelseif ListFind( customList, attributes.ShipType )>
			<cfquery name="CheckCustom" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT ID FROM #Request.DB_Prefix#ShipSettings
				WHERE ShipType IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#customList#" list="true"> )
				AND ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ship_ID#">
			</cfquery>
			
			<cfif CheckCustom.RecordCount>
				<cfset attributes.error_message = "You may only use one custom shipping type. Please select a different shipping type.">
			</cfif>
		</cfif>
		
		<cfif NOT len(attributes.error_message)>
			
			<cfquery name="UpdSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#ShipSettings
				SET ShipType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShipType#">,
				AllowNoShip = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.AllowNoShip#">,
				InStorePickup = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#InStorePickup#">,
				ShowEstimator = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#ShowEstimator#">,
				UseDropShippers = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#UseDropShippers#">,
				ShowFreight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#ShowFreight#">,
				NoShipMess = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#NoShipMess#">,
				NoShipType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.NoShipType)#">,
				ShipBase = <cfqueryparam cfsqltype="cf_sql_double" value="#Trim(attributes.ShipBase)#">,
				ShipHand = <cfqueryparam cfsqltype="cf_sql_double" value="#ShipHand#">
				WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ship_ID#">
			</cfquery>
			
		</cfif>

	</cfif>
		
<cfelseif attributes.action IS "delete">
	
	<cfquery name="DelSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#ShipSettings
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Ship_ID#">
	</cfquery>


</cfif>

<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../qry_ship_settings.cfm">


