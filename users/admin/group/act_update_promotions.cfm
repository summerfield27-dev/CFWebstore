
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to update the promotions after editing a user group. Called by act_group.cfm --->

<!--- Loop through the list of user group promotions --->
<cfloop list="#attributes.PromotionList#" index="promotion">

	<!--- promotion was found selected for this user group --->
	<cfif isDefined("attributes.Promotions") AND ListFind(attributes.Promotions, promotion)>
	
			<!--- Confirm that user group is not already in the table ---->
			<cfquery name="check_relations"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Group_ID
				FROM #Request.DB_Prefix#Promotion_Groups
				WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#promotion#">
				AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Group_ID#">
			</cfquery>		
		
			<cfif check_relations.recordcount is 0>
				
				<cfquery name="Add_Related" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#Promotion_Groups
					(Promotion_ID, Group_ID)
					VALUES ( 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#promotion#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Group_ID#"> )
				</cfquery>
		
			</cfif>
			
	<cfelse>
		
		<cfquery name="delete_related"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Promotion_Groups
			WHERE Promotion_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#promotion#">
			AND Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Group_ID#">
		</cfquery>		
	
	</cfif>

</cfloop>

<!----- RESET Promotion Groups query ---->
	<cfinvoke component="#Request.CFCMapping#.shopping.promotions"
			method="qryGroupPromotions" Group_ID="#attributes.Group_ID#" reset="yes">

