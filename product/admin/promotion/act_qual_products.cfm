
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete qualifying products for a promotion. Called by product.admin&promotion=qual_products --->

<cfif isdefined("attributes.submit_related")>

	<cfif attributes.submit_related is "Add Products" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that product is not already there ---->
			<cfquery name="check_relations" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Product_ID
			FROM #Request.DB_Prefix#Promotion_Qual_Products
			WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Promotion_Qual_Products
				(Promotion_ID, Product_ID)
				VALUES ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> )
				</cfquery>
				
				<!--- Update promotion list for the product --->	
				<cfset Application.objPromotions.updProdPromotions(thisID)>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Promotion_Qual_Products
			WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>	
		
		<!--- Update promotion list for the product --->
		<cfset Application.objPromotions.updProdPromotions(submit_related)>	

	</cfif>

</cfif>
				
