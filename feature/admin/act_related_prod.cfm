
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related products for a feature. Called by feature.admin&feature=related_prod --->

<cfif isdefined("attributes.submit_related")>

	<!--- CSRF Check --->
	<cfset keyname = "productRelated">
	<cfinclude template="../../includes/act_check_csrf_key.cfm">

	<cfif attributes.submit_related is "Add Products" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that product is not already there ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Feature_Product_ID
				FROM #Request.DB_Prefix#Feature_Product
				WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_ID#">
				AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#Feature_Product
					(Feature_ID, Product_ID)
					VALUES( <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_id#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">)
				</cfquery>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Feature_Product
			WHERE Feature_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.feature_ID#">
			AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>			
	
	</cfif>

</cfif>
				


				
				
				
				
				
				
				

				
				
