
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for groups: add, update, delete. Called by users.admin&group=act --->

<!--- CSRF Check --->
<cfset keyname = "groupEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfset attributes.error_message="">

<cfswitch expression="#mode#">
	<cfcase value="i">
		<!--- add new group --->
		<cftransaction isolation="SERIALIZABLE">

		<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			SELECT MAX(Group_ID) AS maxid 
			FROM #Request.DB_Prefix#Groups
		</cfquery>
		
		<cfset attributes.group_id = get_id.maxid + 1>
		
		<cfquery name="addgroup" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Groups 	
			(Group_ID, Name, Description, Group_Code, Wholesale, TaxExempt, ShipExempt)
			VALUES
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Group_ID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(attributes.Description)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Group_Code)#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Wholesale#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxExempt#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShipExempt#">
			)
		</cfquery>
		
		</cftransaction>
		
		<cfinclude template="act_update_discounts.cfm">
		<cfinclude template="act_update_promotions.cfm">
		
	</cfcase>
			
	<cfcase value="u">
		<cfif submit is "Delete">
			<!--- Delete Group. Administrator group can not be deleted. --->
			<cfif attributes.gid is "1">
				<cfset attributes.error_message = "You cannot delete this group">
			<cfelse>
				<cfinclude template="act_delete_group.cfm">
			</cfif>				
			
		<cfelse>
			<!--- Update Group --->
			<cfset attributes.group_id = attributes.gid>
			<cfinclude template="act_update_discounts.cfm">
			<cfinclude template="act_update_promotions.cfm">
			
			<cfquery name="update_group" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" >
				UPDATE #Request.DB_Prefix#Groups
				SET
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
				Description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(attributes.Description)#">,
				Group_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Group_Code)#">,
				Wholesale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Wholesale#">,
				TaxExempt = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.TaxExempt#">,
				ShipExempt = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShipExempt#">
				WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
			</cfquery>
			
		</cfif>

	</cfcase>	
</cfswitch>
			

