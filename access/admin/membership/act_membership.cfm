<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for memberships: add, update, delete. Called by access.admin&membership=act --->

<cfparam name="attributes.recur_product_ID" default="">

<!--- CSRF Check --->
<cfset keyname = "membershipEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfswitch expression="#mode#">
	<cfcase value="i">
	
		<!--- check to make sure the user is valid --->
		<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT User_ID FROM #Request.DB_Prefix#Users
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
		</cfquery>
			
		<cfif finduser.recordcount is 1>
	
	
		<cfquery name="AddMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Memberships 
			(User_ID, Order_ID, Product_ID, Membership_Type, AccessKey_ID, Date_Ordered, 
			Start, Time_Count, Access_Count, Expire, Valid, Suspend_Begin_date,
			Next_Membership_ID, Recur, Recur_Product_ID)
			
			VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#finduser.User_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Order_ID#" null="#YesNoFormat(NOT len(Trim(attributes.Order_ID)))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Product_ID#" null="#YesNoFormat(NOT len(Trim(attributes.Product_ID)))#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Membership_Type#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccessKey_ID#" null="#YesNoFormat(NOT len(Trim(attributes.AccessKey_ID)))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start#" null="#YesNoFormat(NOT isDate(attributes.start))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Time_count#" null="#YesNoFormat(NOT isNumeric(attributes.Time_count))#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Access_count#" null="#YesNoFormat(NOT isNumeric(attributes.Access_count))#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expire#" null="#YesNoFormat(NOT isDate(attributes.expire))#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.valid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Suspend_Begin_date#" null="#YesNoFormat(NOT isDate(attributes.Suspend_Begin_date))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Next_Membership_ID#" null="#YesNoFormat(NOT isNumeric(attributes.Next_Membership_ID))#">, 
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Recur#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Recur_product_ID#" null="#YesNoFormat(NOT isNumeric(attributes.Recur_product_ID))#">
			)
			</cfquery>	
			
		<cfelse>
			
			<cfset attributes.error_message = "Could not add Membership. Not a valid User">
		
		</cfif>	
			

	</cfcase>
			
	<cfcase value="u">
		<cfif submit is "delete">

			<!--- see if membership is child --->
			<cfquery name="findparent" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Membership_ID FROM #Request.DB_Prefix#Memberships
				WHERE Next_Membership_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_ID#">
			</cfquery>
			
			<!--- Update parent membership if it exists --->
			<cfif findparent.recordcount>
				<cfquery name="UpdateParentMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Memberships
				SET Next_Membership_ID = NULL
				WHERE Membership_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#findparent.Membership_ID#">
				</cfquery>
			</cfif>
			
			<cfquery name="deleteMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Memberships 
			WHERE Membership_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_ID#">
			</cfquery>
				
		<cfelse>
		
		<!--- check to make sure the user is valid --->
		<cfquery name="finduser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT User_ID FROM #Request.DB_Prefix#Users
			WHERE Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UName#">
		</cfquery>
			
			<cfif finduser.recordcount is 1>
			
				<cfset form.User_id = finduser.User_ID>

				<cfquery name="UpdateMembership" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
    			UPDATE #Request.DB_Prefix#Memberships
    			SET	User_ID =		<cfqueryparam cfsqltype="cf_sql_integer" value="#finduser.user_id#">,
				Order_ID =  		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Order_ID#" null="#YesNoFormat(NOT len(Trim(attributes.Order_ID)))#">,
				Product_ID =  		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Product_ID#" null="#YesNoFormat(NOT len(Trim(attributes.Product_ID)))#">,
				Membership_Type = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Membership_Type#">,
				AccessKey_ID = 		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccessKey_ID#" null="#YesNoFormat(NOT len(Trim(attributes.AccessKey_ID)))#">,
				Start = 			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start#" null="#YesNoFormat(NOT isDate(attributes.start))#">,
				Time_Count = 		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Time_count#" null="#YesNoFormat(NOT isNumeric(attributes.Time_count))#">, 
				Access_Count = 		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Access_count#" null="#YesNoFormat(NOT isNumeric(attributes.Access_count))#">, 
				Expire = 			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expire#" null="#YesNoFormat(NOT isDate(attributes.expire))#">,
				Valid = 			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.valid#">,
				Access_Used  = 		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Access_Used#">,
				Suspend_Begin_Date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Suspend_Begin_date#" null="#YesNoFormat(NOT isDate(attributes.Suspend_Begin_date))#">,
				Recur =				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Recur#">,
				Recur_Product_ID = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Recur_product_ID#" null="#YesNoFormat(NOT isNumeric(attributes.Recur_product_ID))#">
				WHERE Membership_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Membership_ID#">
				</cfquery>
			
				<cfinclude template="act_suspend.cfm">

			<cfelse>
			
				<cfset attributes.error_message = "Oops! Not a valid User">
			
			</cfif>
			

		</cfif>

	</cfcase>
			
</cfswitch>

<!--- update admin menu  --->
<cfset attributes.admin_reload = "membershipcount">


		