
<!--- CFWebstore, version 6.50 --->


<!--- This page is used to update the discounts after editing a category. Called by act_category.cfm --->

<!--- Loop through the list of category discounts --->
<cfloop list="#attributes.DiscountList#" index="discount">

	<!--- discount was found selected for this category --->
	<cfif isDefined("attributes.Discounts") AND ListFind(attributes.Discounts, discount)>
	
			<!--- Confirm that category is not already in the table ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Category_ID
			FROM #Request.DB_Prefix#Discount_Categories
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">
			AND Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Discount_Categories
				(Discount_ID, Category_ID)
				VALUES
				 (<cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">, 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#"> )
				</cfquery>
		
			</cfif>
			
	<cfelse>
		
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Discount_Categories
		WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">
		AND Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
		</cfquery>		
	
	</cfif>

</cfloop>


