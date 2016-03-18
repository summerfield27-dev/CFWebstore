
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on promotions: add, edit and delete. Called by product.admin&promotion=act --->

<!--- CSRF Check --->
<cfset keyname = "promotionEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif len(Trim(attributes.Amount1))>
	<cfset attributes.Amount = attributes.Amount1> 
	<cfset attributes.Type2 = 1>
<cfelse>
	<cfset attributes.Amount = attributes.Amount2/100>
	<cfset attributes.Type2 = 2>
</cfif>

<cfif NOT len(Trim(attributes.Promo_Display))>
	<cfset attributes.Promo_Display = Trim(attributes.Name)>
<cfelse>
	<cfset attributes.Promo_Display = Trim(attributes.Promo_Display)>
</cfif>
			
<cfswitch expression="#mode#">
	<cfcase value="i">

		<cftransaction isolation="SERIALIZABLE">
		
			<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#Promotions
				(Type1, Type2, Type3, Type4, Coup_Code, OneTime, AccessKey, Name, Display, Amount, 
				QualifyNum, DiscountNum, Multiply, Add_DiscProd, StartDate, EndDate, Disc_Product)
			VALUES(
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type1#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type2#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type3#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type4#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(attributes.Coup_Code))#">,
				 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OneTime#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Promo_Display#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#Attributes.Amount#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.QualifyNum#">,
				 <cfqueryparam cfsqltype="cf_sql_double" value="#Attributes.DiscountNum#">,
				 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Multiply#">,
				 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Add_DiscProd#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">,
				0)
			</cfquery>				
			
			<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				SELECT MAX(Promotion_ID) AS maxid 
				FROM #Request.DB_Prefix#Promotions
				</cfquery>
		
			<cfset attributes.Promotion_ID = get_id.maxid>

			<cfif attributes.Type1 IS NOT 4>			
				<cfset attributes.XFA_success= "fuseaction=product.admin&promotion=qual_products&promotion_id=#attributes.promotion_id#">
			<cfelse>
				<cfset attributes.XFA_success= "fuseaction=product.admin&promotion=disc_product&promotion_id=#attributes.promotion_id#">
			</cfif>
			
		</cftransaction>
				
		</cfcase>			
			
		<cfcase value="u">
			<cfif submit is "Delete">				

				<!--- Delete any assigned qualifying products --->
				<cfquery name="DeleteProducts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Promotion_Qual_Products
				WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
				</cfquery>
				
				<!--- Delete any assigned user groups --->
				<cfquery name="DeleteGroups" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Promotion_Groups
				WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
				</cfquery>

				<!--- Finally, remove the promotion --->
				<cfquery name="DeletePromotion" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					DELETE FROM #Request.DB_Prefix#Promotions
					WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
				</cfquery>			
								
			<cfelse><!---- EDIT ---->
			
				<cfquery name="UpdPromotion" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Promotions
				SET Type1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type1#">,
				Type2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type2#">,
				Type4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Type4#">,
				Coup_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(attributes.Coup_Code))#">,
				OneTime = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OneTime#">,
				AccessKey = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AccessKey#">,
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Name)#">,
				Display = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Promo_Display#">,
				Amount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.Amount#">,
				QualifyNum = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.QualifyNum#">,
				DiscountNum = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.DiscountNum#">,
				Multiply = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Multiply#">,
				Add_DiscProd = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Attributes.Add_DiscProd#">,
				StartDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
				EndDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">
				WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
				</cfquery>
	
				
				<!---- If promotion has been changed to all users, delete any records in the Promotion_Groups table ------>
				<cfif attributes.Type4 IS 0>
		
					<cfquery name="DeleteGroups" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					DELETE FROM #Request.DB_Prefix#Promotion_Groups
					WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
					</cfquery>
					
				</cfif><!---- all user promotion --->
				
			</cfif><!---- update ---->
		
		</cfcase>

	</cfswitch>	
	
	
	<!----- RESET Promotion Application query ---->
	<cfset Application.objPromotions.getallPromotions('yes')>
		
	<!----- RESET Cached group queries ---->
	<cfinclude template="act_reset_group_queries.cfm">
	

		
