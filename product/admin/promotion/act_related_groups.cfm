
<!--- CFWebstore, version 6.50 --->

<!--- Used to add and delete related user groups for a promotion. Called by product.admin&promotion=groups --->

<!--- CSRF Check --->
<cfset keyname = "editRelatedGroups">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif isdefined("attributes.submit_related")>

	<cfif attributes.submit_related is "Add Groups" and isdefined("attributes.add_related") and attributes.add_related is not "">
	
		<cfloop index="thisID" list="#attributes.add_related#">
			
			<!--- Confirm that category is not already in the table ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Promotion_ID
			FROM #Request.DB_Prefix#Promotion_Groups
			WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
			AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#Promotion_Groups
				(Promotion_ID, Group_ID)
				VALUES ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#thisID#"> )
				</cfquery>
				
				<!----- RESET Promotion Groups query ---->
				<cfset Application.objPromotions.qryGroupPromotions(Group_ID=thisID,reset='yes')>
		
			</cfif>
			
		</cfloop>
		
	<cfelseif IsNumeric(attributes.submit_related)>
	
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Promotion_Groups
			WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Promotion_ID#">
			AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#submit_related#">
		</cfquery>	
		
		<!----- RESET Promotion Groups query ---->
		<cfset Application.objPromotions.qryGroupPromotions(Group_ID=submit_related,reset='yes')>
	
	</cfif>

</cfif>

			
