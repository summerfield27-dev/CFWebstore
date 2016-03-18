
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to update the discounts after editing a product. Called by act_product_price.cfm --->

<!--- Loop through the list of current product discounts --->
<cfloop list="#attributes.DiscountList#" index="discount">

	<!--- discount was found selected for this product --->
	<cfif isDefined("attributes.Discounts") AND ListFind(attributes.Discounts, discount)>
	
			<!--- Confirm that product is not already in the table ---->
			<cfquery name="check_relations" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Product_ID
			FROM #Request.DB_Prefix#Discount_Products
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Discount_Products
				(Discount_ID, Product_ID)
				VALUES ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#"> )
				</cfquery>
		
			</cfif>
	
	<!--- discount was not selected --->		
	<cfelse>
		
		<cfquery name="delete_related" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Discount_Products
		WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#discount#">
		AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
		</cfquery>		
	
	</cfif>

</cfloop>

<!--- Retrieve the updated product discount list --->
<cfset DiscountList = Application.objDiscounts.getProdDiscountList(attributes.Product_ID)>
