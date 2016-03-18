
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related products for a product. Called by product.admin&do=related --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this product --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Product_ID#">
	<cfset editproduct = useraccess>
<cfelse>
	<cfset editproduct = "yes">
</cfif>

<cfif editproduct AND isdefined("attributes.submit_related")>
	
	<cfif attributes.submit_related is "Add Products" AND isDefined("attributes.add_related") AND attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that product is not already there ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Product_Item_ID
			FROM #Request.DB_Prefix#Product_Item
			WHERE 
				Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
				AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Product_Item
				(Product_ID, Item_ID)
				VALUES ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">)
				</cfquery>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Product_Item
		WHERE 
			Item_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>			
	
	</cfif>
				
</cfif>		

