
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related categories for a discount. Called by product.admin&discount=categories --->

<cfif isdefined("attributes.submit_related")>

	<!--- CSRF Check --->
	<cfset keyname = "relatedCategories">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif attributes.submit_related is "Add Categories" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that category is not already in the table ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Category_ID
			FROM #Request.DB_Prefix#Discount_Categories
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
			AND Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Discount_Categories
				(Discount_ID, Category_ID)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> )
				</cfquery>
		
			</cfif>
			
			<!--- Update the discounts for products in this category --->
			<cfset attributes.CID = thisID>
			<cfinclude template="../../../category/admin/act_update_proddiscounts.cfm">
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Discount_Categories
		WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
		AND Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>			
		
		<!--- Update the discounts for products in this category --->
		<cfset attributes.CID = submit_related>
		<cfinclude template="../../../category/admin/act_update_proddiscounts.cfm">
	
	</cfif>

</cfif>
				
