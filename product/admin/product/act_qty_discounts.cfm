
<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the product quantity discounts: add, update, delete. Called by product.admin&do=Qty_Discounts --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this product --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Product_ID#">
	<cfset editproduct = useraccess>
<cfelse>
	<cfset editproduct = "yes">
</cfif>

<cfif editproduct>	
	
	<cfif isdefined("attributes.Submit_discount")>

		<!--- CSRF Check --->
		<cfset keyname = "prodQtyDiscounts">
		<cfinclude template="../../../includes/act_check_csrf_key.cfm">
		
		<cfset Discountper = iif(isNumeric(attributes.Discountper), attributes.Discountper, 0)>	
	
		<cfif attributes.prodDisc_ID is 0>
	
			<cftransaction isolation="SERIALIZABLE">
				<cfquery name="getID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT MAX(ProdDisc_ID) AS maxid
					FROM #Request.DB_Prefix#ProdDisc 
					WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">
					</cfquery>
					
				<cfquery name="AddDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#ProdDisc 
					(ProdDisc_ID, Product_ID, Wholesale, QuantFrom, QuantTo, DiscountPer)
					VALUES 
					(<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(getID.maxid), Evaluate(DE('getID.maxid+1')), 1)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">, 
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Wholesale#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Quantfrom#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Quantto#">, 
					 <cfqueryparam cfsqltype="cf_sql_double" value="#Discountper#"> )
				</cfquery>
			</cftransaction>
		
		<cfelse>
			
			<cfquery name="UpdateDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#ProdDisc
				SET
				Wholesale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Wholesale#">,
				QuantFrom = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Quantfrom#">,
				QuantTo = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Quantto#">,
				DiscountPer = <cfqueryparam cfsqltype="cf_sql_double" value="#Discountper#">
				WHERE ProdDisc_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prodDisc_ID#">
				AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">
			</cfquery>
			
		</cfif>
		
	<cfelseif isdefined("attributes.delete")>
	
		<!--- CSRF Check --->
		<cfset keyname = "prodQtyDiscounts">
		<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
		<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#ProdDisc
			WHERE ProdDisc_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">
		</cfquery>
	</cfif>


</cfif>