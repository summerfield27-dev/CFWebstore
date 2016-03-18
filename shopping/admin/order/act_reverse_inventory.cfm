
<!--- CFWebstore, version 6.50 --->

<!--- Puts items back into inventory if the order is being deleted. Called from act_order.cfm --->

<!--- Get list of items being ordered --->
<cfquery name="GetOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.Product_ID, O.Quantity, O.OptChoice, P.Prod_Type 
	FROM #Request.DB_Prefix#Order_Items O, #Request.DB_Prefix#Products P
	WHERE O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
	AND O.Product_ID = P.Product_ID
</cfquery>

<cfloop query="GetOrder">

	<!--- Only return tangible products --->
	
	<cfif GetOrder.Prod_Type IS "product">
		
		<cfquery name="UpdateInv" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Products
		SET NumInStock = NumInStock + <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Quantity#">
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Product_ID#">
		</cfquery>
				
		<cfif GetOrder.OptChoice IS NOT 0>
	
			<!--- Update Option Quantity --->
			<cfquery name="UpdateChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#ProdOpt_Choices
				SET NumInStock = NumInStock + <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Quantity#">
				WHERE Option_ID IN (SELECT OptQuant FROM Products
									WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Product_ID#">)
				AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.OptChoice#">
			</cfquery>
			
		</cfif>
		
	</cfif>
</cfloop>

<!--- Update the order --->
<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	UPDATE #Request.DB_Prefix#Order_No
	SET InvDone = 0
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
</cfquery>

