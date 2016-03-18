
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related user groups for a discount. Called by product.admin&discount=groups --->

<cfif isdefined("attributes.submit_related")>

	<!--- CSRF Check --->
	<cfset keyname = "editRelatedGroups">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	<cfif attributes.submit_related is "Add Groups" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that group is not already in the table ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Discount_ID
			FROM #Request.DB_Prefix#Discount_Groups
			WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
			AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Discount_Groups
				(Discount_ID, Group_ID)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_id#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> )
				</cfquery>
				
				<!----- RESET Discount Groups query ---->
				<cfset Application.objDiscounts.qryGroupDiscounts(Group_ID=thisID,reset='yes')>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Discount_Groups
		WHERE Discount_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.discount_ID#">
		AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>		
		
		<!----- RESET Discount Groups query ---->
		<cfset Application.objDiscounts.qryGroupDiscounts(Group_ID=submit_related,reset='yes')>
	
	
	</cfif>

</cfif>
				
