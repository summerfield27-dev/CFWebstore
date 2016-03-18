
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to refund an amount on an order using Authorize.Net. The order must have been previously captured and provide a transaction number. Called from shopping\admin\act_billing.cfm

	Required: Order_no
			  TransactionID
			  RefundAmount
	
--->

<!--- Retrive Authorize.Net settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Password, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!--- Look up the Order Info and credit card number --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, TransactNum, CardNumber
	FROM #Request.DB_Prefix#Order_No O, #Request.DB_Prefix#CardData C
	WHERE O.Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer"> 
	AND O.Card_ID = C.ID
	AND O.Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="1">
</cfquery>

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1>

	<cfset CardLastFour = Right(GetOrderTx.CardNumber,4)>

	<CF_AuthNetAction
		QUERYNAME="Results"
		LOGIN="#GetSettings.Username#"
	     PASSWORD="#GetSettings.Password#"
	     AMOUNT="#RefundAmount#"
	     TransactNum="#GetOrderTx.TransactNum#"
	     CardNumber="#CardLastFour#"
	     ACTION="CREDIT"
	     TEST="No"
		 TESTGATEWAY="No">

	<!--- Debug --->
	<!--- <cfdump var="#Result#"> --->
	
	<cfset thedate = dateformat(now(),"mm/dd/yy")>

	<!---If the message is approved, continue processing the order---->
	<cfif Results.Response_Code IS 1>
			
		<cfset TransactNum = Results.Transaction_ID>
  
  		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Paid = 1,	
			OrderTotal = OrderTotal - <cfqueryparam cfsqltype="cf_sql_double" value="#RefundAmount#">,	
			LastTransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TransactNum#">,		
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="Refunded #LSCurrencyFormat(RefundAmount)# on #thedate#<br/> #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
		
	<cfelse>
  		<cfset ErrorMessage = Results.Reason_Text>
  		
		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="Refund failed on #thedate#: #ErrorMessage#<br/>  #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
			
	</CFIF>
	
<cfelse>

	<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="Refund failed on #thedate#: Valid order data not found.<br/>  #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
			
</cfif>
