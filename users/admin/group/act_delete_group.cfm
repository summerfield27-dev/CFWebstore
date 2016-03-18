<!--- CFWebstore, version 6.50 --->

<!--- Called from act_group.cfm, this template deletes a group. To delete a group, fist remove group from any discounts and promotions, then remove group ID from user records --->

<!--- Remove discounts --->
<cfquery name="ClearDiscounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Discount_Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
</cfquery>

<!--- Remove promotions --->
<cfquery name="ClearPromotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Promotion_Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
</cfquery>

<!--- Delete any product group prices --->
<cfquery name="DeleteProdPrices" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#ProdGrpPrice
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
</cfquery>

<!--- Remove group_ID from all user Records --->
<cfquery name="GetUsers" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Users
SET Group_ID = 0
WHERE Group_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
</cfquery>

<!--- Delete group --->
<cfquery name="DeleteGroup" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gid#">
</cfquery>

<!----- RESET Discount Groups query ---->
	<cfinvoke component="#Request.CFCMapping#.shopping.discounts"
			method="qryGroupDiscounts" Group_ID="#attributes.gid#" reset="yes">

<!----- RESET Promotion Groups query ---->
	<cfinvoke component="#Request.CFCMapping#.shopping.promotions"
			method="qryGroupPromotions" Group_ID="#attributes.gid#" reset="yes">
			
			
	
			
			