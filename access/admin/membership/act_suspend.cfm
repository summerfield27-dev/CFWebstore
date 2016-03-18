<!--- CFWebstore, version 6.50 --->

<!--- This template processes the reinstatement of a suspended  membership. It creates a new membership record with the appropriate start date and calculated end date. --->

<cfparam name="attributes.suspend_end_date" default="">

<!--- UUID to tag new inserts --->
<cfset NewIDTag = CreateUUID()>
<!--- Remove dashes --->
<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>

<!--- Process template only if attributes.suspend_ending is defined ---->
<cfif isdate(attributes.suspend_end_date)>

	<!--- Verify that the suspend ending is after the starting date --->
	<cfif datecompare(attributes.suspend_end_date,attributes.suspend_begin_date) is 1>
	
		<!--- Calculate number of days to carry over to the next record --->
		<cfset daysleft = DateDiff('d',attributes.suspend_begin_date,attributes.Expire)>
		<cfset newexpire = DateAdd('d',daysleft,attributes.suspend_end_date)>
			
		<!--- Copy current membership to new membership --->
		
		<!--- check to make sure the user is valid --->
		<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT User_ID FROM #Request.DB_Prefix#Users
			WHERE 
				<cfif isdefined("attributes.UName")>
					UserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
				<cfelse>
					User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.User_ID#">
				</cfif>
		</cfquery>
			
		<cfif finduser.recordcount is 1>
			
			<cftransaction>
				
			<cfquery name="AddMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			<cfif Request.dbtype IS "MSSQL">
				SET NOCOUNT ON
			</cfif>
			INSERT INTO #Request.DB_Prefix#Memberships 
				(ID_Tag, User_ID, Order_ID, Product_ID, Membership_Type, AccessKey_ID, Date_Ordered, 
				Start, Time_Count, Access_Count, Expire, Valid,	Suspend_Begin_Date, Next_Membership_ID)
			
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="'#NewIDTag#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#finduser.User_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_ID#" null="#YesNoFormat(NOT len(attributes.Order_ID))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#" null="#YesNoFormat(NOT len(attributes.Product_ID))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Membership_Type#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccessKey_ID#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.suspend_end_date#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Time_Count#" null="#YesNoFormat(NOT len(attributes.Time_Count))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Access_Count#" null="#YesNoFormat(NOT len(attributes.Access_Count))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NewExpire#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.valid#">,
			Null,
			Null
			)
			<cfif Request.dbtype IS "MSSQL">
				SELECT @@Identity AS New_ID
				SET NOCOUNT OFF
			</cfif>
			</cfquery>	
		
			<cfif Request.dbtype IS NOT "MSSQL">
				<cfquery name="AddMembership" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				SELECT Membership_ID AS New_ID 
				FROM #Request.DB_Prefix#Memberships
				WHERE ID_Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">
				</cfquery>
			</cfif>
			
			</cftransaction>
		
			<cfset OLD_Membership_id = attributes.Membership_id>
			<cfset attributes.Membership_id = AddMembership.New_ID>
		
		
			<!--- Update old membership with new membership ID --->
			<cfquery name="UpdateMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Memberships
			SET
			Next_Membership_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_id#">,
			Suspend_Begin_Date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Suspend_Begin_date#">
			WHERE Membership_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#OLD_Membership_ID#">
			</cfquery>
			
		
		<cfelse><!--- error: --->
			
			<cfset attributes.error_message = "Could not add Membership. Not a valid User">
		
		</cfif>	
	
	<cfelse><!--- error: --->
	
		<cfset attributes.error_message="The Suspend Ending date must be after the starting date.">	
	
	</cfif>

</cfif><!--- processing check --->

<cfsetting enablecfoutputonly="no">
