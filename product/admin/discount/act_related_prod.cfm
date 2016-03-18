
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related products for a discount. Called by product.admin&discount=products --->

<cfif isdefined("attributes.submit_related")>

	<cfif attributes.submit_related is "Add Products" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that product is not already there ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Product_ID
			FROM #Request.DB_Prefix#Discount_Products
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Discount_Products
				(Discount_ID, Product_ID)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> 	)
				</cfquery>
				
				<!--- Update discount list for the product --->	
				<cfset Application.objDiscounts.updProdDiscounts(Product_ID=thisID)>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Discount_Products
		WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
		AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>		
		
		<!--- Update discount list for the product --->	
		<cfset Application.objDiscounts.updProdDiscounts(Product_ID=submit_related)>
	
	</cfif>

</cfif>
				


				
				
				
				
				
				
				

				
				
