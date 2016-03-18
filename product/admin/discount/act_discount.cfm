
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on discounts: add, edit and delete. Verifies the discount is not in use before deleting. Called by product.admin&discount=act --->

<!--- CSRF Check --->
<cfset keyname = "discountEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif len(Trim(attributes.Amount1))>
	<cfset attributes.Amount = attributes.Amount1> 
	<cfset attributes.Type2 = 1>
<cfelse>
	<cfset attributes.Amount = attributes.Amount2/100>
	<cfset attributes.Type2 = 2>
</cfif>

<cfif NOT len(Trim(attributes.MaxOrder))>
	<cfset attributes.MaxOrder = 999999999>
<cfelse>
	<cfset attributes.MaxOrder = attributes.MaxOrder>
</cfif>

<cfif NOT len(Trim(attributes.Disc_Display))>
	<cfset attributes.Disc_Display = Trim(attributes.Name)>
<cfelse>
	<cfset attributes.Disc_Display = Trim(attributes.Disc_Display)>
</cfif>

			
<cfswitch expression="#mode#">
	<cfcase value="i">

		<cftransaction isolation="SERIALIZABLE">
		
			<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Discounts
				(Type1, Type2, Type3, Type4, Type5, Coup_Code, OneTime, AccessKey, Name, 
				Display, Amount, MinOrder, MaxOrder, StartDate, EndDate)
			VALUES(
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type1#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type2#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type3#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type4#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type5#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(attributes.Coup_Code))#">,
				 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OneTime#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Disc_Display#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#Attributes.Amount#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MinOrder#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#Attributes.MaxOrder#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">  
				 )
			</cfquery>				
			
			<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				SELECT MAX(Discount_ID) AS maxid 
				FROM #Request.DB_Prefix#Discounts
				</cfquery>
		
			<cfset attributes.Discount_ID = get_id.maxid>
			
		</cftransaction>
			
		<cfif attributes.Type3 IS 0>
			<cfset attributes.XFA_success="fuseaction=product.admin&discount=products&discount_id=#attributes.Discount_ID#&cid=0">
		<cfelseif attributes.Type3 IS 1>
			<cfset attributes.XFA_success="fuseaction=product.admin&discount=categories&discount_id=#attributes.Discount_ID#&pid=0">
		</cfif>
			
	</cfcase>			
		
	<cfcase value="u">
		<cfif submit is "Delete">				

			<!--- Delete any assigned products --->
			<cfquery name="DeleteProducts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Discount_Products
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
			</cfquery>

			<!--- Delete any assigned categories --->
			<cfquery name="DeleteCategories" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Discount_Categories
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
			</cfquery>
			
			<!--- Delete any assigned user groups --->
			<cfquery name="DeleteGroups" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Discount_Groups
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
			</cfquery>

			<!--- Finally, remove the discount --->
			<cfquery name="DeleteDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Discounts
				WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
			</cfquery>			
							
		<cfelse><!---- EDIT ---->
		
			<cfquery name="UpdDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Discounts
			SET Type1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type1#">,
			Type2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type2#">,
			Type4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type4#">,
			Type5 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type5#">,
			Coup_Code =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(attributes.Coup_Code))#">,
			OneTime = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OneTime#">,
			AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey#">,
			Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
			Display = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Disc_Display#">,
			Amount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Amount#">,
			MinOrder = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MinOrder#">,
			MaxOrder = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.MaxOrder#">,
			StartDate =   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
			EndDate =   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
			</cfquery>

			
			<!---- If discount has been changed to all users, delete any records in the Discount_Groups table ------>
			<cfif attributes.Type5 IS 0>
	
				<cfquery name="DeleteGroups" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Discount_Groups
				WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Discount_ID#">
				</cfquery>
				
			</cfif><!---- all user discount --->
			
		</cfif><!---- update ---->
	
	</cfcase>

</cfswitch>	


<!----- RESET Cached All Discounts query ---->
<cfset Application.objDiscounts.getallDiscounts('yes')>	

<!----- RESET Cached group queries ---->
<cfinclude template="act_reset_group_queries.cfm">
	
	

