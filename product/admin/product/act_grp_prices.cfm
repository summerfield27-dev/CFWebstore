<!--- CFWebstore, version 6.50 --->

<!--- Performs the admin actions for the product group prices: add, update, delete. Called by product.admin&do=grp_price --->

<cfif isdefined("attributes.Submit_price") and attributes.GID IS NOT 0>

	<!--- CSRF Check --->
	<cfset keyname = "prodGroupPrice">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfif NOT len(Trim(attributes.Price))>
		<cfset Price = 0>
	<cfelse>
		<!--- Replaced for Blue Dragon 
		<cfset Price = LSParseNumber(attributes.Price)> ---->
		<cfset Price = attributes.Price>
	</cfif>


	<cfif attributes.GrpPrice_ID is "0">
	
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="getID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT MAX(GrpPrice_ID) AS maxid
				FROM #Request.DB_Prefix#ProdGrpPrice 
				WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">
			</cfquery>
			
			<cfquery name="AddPrice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#ProdGrpPrice 
				(GrpPrice_ID, Product_ID, Group_ID, Price)
				VALUES 
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(getID.maxid), Evaluate(DE('getID.maxid+1')), 1)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GID#">, 
					<cfqueryparam cfsqltype="cf_sql_double" value="#Price#">)
			</cfquery>
		</cftransaction>
	
	<cfelse>
		
		<cfquery name="UpdatePrice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#ProdGrpPrice
			SET
			Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GID#">,
			Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">
			WHERE GrpPrice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GrpPrice_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">
		</cfquery>
		
	</cfif>
	
<cfelseif isdefined("attributes.delete")>

	<cfquery name="delete_record"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#ProdGrpPrice
		WHERE GrpPrice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delete#">
		AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_id#">
	</cfquery>
</cfif>


