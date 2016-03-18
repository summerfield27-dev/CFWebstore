
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to refund an amount on an order using PayFlowPro. The order must have been previously captured and provide a transaction number. Called from shopping\admin\act_billing.cfm

	Required: Order_no
			  TransactionID
			  RefundAmount
	
--->

<!--- Retrive PayFlowPro settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer, Setting1
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfinclude template="../act_decrypt_settings.cfm">

<!--- Look up the Order Info and credit card number --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, LastTransactNum
	FROM #Request.DB_Prefix#Order_No O
	WHERE O.Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer"> 
	AND O.Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="1">
</cfquery>

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1>

	<CF_PayFlowPro4Action
		QUERYNAME="Results"
		USER="#GetSettings.Username#"
		VENDOR="#GetSettings.Username#"
     	PASSWORD="#GetSettings.Password#"
	 	PARTNER="#GetSettings.Setting1#"
	 	SERVER="#GetSettings.CCServer#"	 
	     AMOUNT="#RefundAmount#"
	     TransactNum="#GetOrderTx.LastTransactNum#"
	     ACTION="C">

	<!--- Debug --->
	<!--- <cfdump var="#Result#"> --->
	
	<cfset thedate = dateformat(now(),"mm/dd/yy")>

	<!---If the message is approved, continue processing the order---->
	<cfif Results.Result IS 0>
			
		<cfset TransactNum = Results.PNREF>
  
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
  		<cfset ErrorMessage = Results.Respmsg>
  		
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

	<cfset ErrorMessage = "This order cannot be refunded.">
			
</cfif>
