
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves all the data for the order. Called by put_order.cfm --->

<!--- Get the order information --->
<cfquery name="CheckOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Order_No FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
	<cfif Type IS NOT "Admin">
		AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
	</cfif>
</cfquery>

<cfif CheckOrder.RecordCount IS 0>

	<cfset errormess = "Sorry, there does not appear to be an order with this number in the database.">

<cfelse>

	<!--- Get the order information, one row needed only --->
	<cfquery name="GetOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Order_Items O, #Request.DB_Prefix#Order_No N
		WHERE O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
		AND O.Order_No = N.Order_No
	</cfquery>
	
	<cfif GetOrder.RecordCount IS 0>
		
		<cfset errormess = "Sorry, this order appears to have no items listed.">
	
	<cfelse>
	
		<!--- Get the Affiliate information --->
		<cfif GetOrder.Affiliate>
			<cfquery name="GetAffiliate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT A.*, C.FirstName, C.LastName 
				FROM #Request.DB_Prefix#Affiliates A, #Request.DB_Prefix#Users U, #Request.DB_Prefix#Customers C
				WHERE A.AffCode = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Affiliate#">
				AND U.Affiliate_ID = A.Affiliate_ID
				AND C.Customer_ID = U.Customer_ID
			</cfquery>
		</cfif>
	
		<cfif get_Order_Settings.CCProcess IS "Shift4OTN">
			<cfset GetCardData=application.objCheckout.getPayments("",Order_No)>
			<cfif GetCardData.RecordCount EQ 0>
				<cfquery name="GetCardData" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
					SELECT * FROM #Request.DB_Prefix#CardData
					WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Card_ID#">
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="GetCardData" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
				SELECT * FROM #Request.DB_Prefix#CardData
				WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrder.Card_ID#">
			</cfquery>
		</cfif>
	
	
	</cfif>


</cfif>

