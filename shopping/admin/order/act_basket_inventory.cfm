<!--- CFWebstore, version 6.50 --->

<!--- Updates Product inventory when editing or adding order products. Called from act_basket_productform.cfm and act_basket_addproduct.cfm --->


<!--- Retrieve the current status of this order, if inventory has been updated, update with new quantity --->
<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	SELECT InvDone
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

<cfif GetInfo.InvDone>	
			
	<cfquery name="UpdateInv" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Products
	SET NumInStock = NumInStock - <cfqueryparam cfsqltype="cf_sql_integer" value="#Quantity#">
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	</cfquery>
			
	<cfif OptChoice IS NOT 0>
	
		<!--- Update Option Quantity --->
		<cfquery name="UpdateChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#ProdOpt_Choices
			SET NumInStock = NumInStock - <cfqueryparam cfsqltype="cf_sql_integer" value="#Quantity#">
			WHERE Option_ID IN (SELECT OptQuant FROM Products
								WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">)
								AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#OptChoice#">
		</cfquery>

	
	</cfif>		

</cfif>
