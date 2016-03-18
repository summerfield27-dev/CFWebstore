
<!--- CFWebstore, version 6.50 --->

<!--- Runs the function to delete a select month's worth of filled orders. Called from act_orders_filled.cfm --->

<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Order_No, Card_ID FROM #Request.DB_Prefix#Order_No 
	WHERE MONTH(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 1)#">
	AND YEAR(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 2)#">
	AND Filled = 1
	<!--- Don't remove orders used for an active recurring membership --->
	AND Order_No NOT IN (SELECT Order_ID FROM #Request.DB_Prefix#Memberships
						WHERE Recur = 1
						AND Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
</cfquery>

<cfif GetOrders.RecordCount>

	<cfset OrderList = ValueList(GetOrders.Order_No)>
	<cfset CardList = ValueList(GetOrders.Card_ID)>
	
	<cfquery name="GetCustomers" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Customer_ID FROM #Request.DB_Prefix#Customers
	WHERE Customer_ID IN (SELECT Customer_ID FROM #Request.DB_Prefix#Order_No  
						WHERE MONTH(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 1)#">
						AND YEAR(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 2)#">) 
	AND Customer_ID NOT IN (SELECT Customer_ID FROM #Request.DB_Prefix#Users)
	AND Customer_ID NOT IN (SELECT Customer_ID FROM #Request.DB_Prefix#Order_No  
							WHERE Order_No NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#OrderList#" list="true">) )
	AND Customer_ID NOT IN (SELECT Customer_ID FROM #Request.DB_Prefix#Account)
	AND User_ID = 0
	</cfquery>
	
	
	<cfset CustomerList = ValueList(GetCustomers.Customer_ID)>
	
	<cfif len(CardList)>
		<cfquery name="Purge3" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#CardData
		WHERE ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CardList#" list="true">)
		</cfquery>
	</cfif>
	
	<cfif len(OrderList)>
		<cfquery name="Purge1" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Order_Items
		WHERE Order_No IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#OrderList#" list="true">)
		</cfquery>
		
		<cfquery name="Purge2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#OrderTaxes
		WHERE Order_No IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#OrderList#" list="true">)
		</cfquery>
		
		<cfquery name="DeleteOrderPO" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Order_PO
		WHERE Order_No IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#OrderList#" list="true">)
		</cfquery>
		
		<cfquery name="Purge2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Order_No
		WHERE Order_No IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#OrderList#" list="true">)
		</cfquery>
		
	</cfif>
	
	
	<cfif len(CustomerList)>
		<cfquery name="Purge4" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Customers
		WHERE Customer_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CustomerList#" list="true">)
		</cfquery>
	
	</cfif>


</cfif>


