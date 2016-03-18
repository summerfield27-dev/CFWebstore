
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to void an order using PayFlowPro. The order must have been previously authorized and provide a transaction number, but not captured yet. Called from shopping\admin\dsp_order.cfm

	Required: Order_no
			  TransactionID
	
--->

<!--- Retrive Authorize.Net settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer, Setting1
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!--- Look up the Order Info and credit card number --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, LastTransactNum
	FROM #Request.DB_Prefix#Order_No O
	WHERE O.Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer"> 
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
	     TransactNum="#GetOrderTx.LastTransactNum#"
	     ACTION="V">

	<!--- Debug --->
	<!--- <cfdump var="#Result#"> --->
	
	<cfset thedate = dateformat(now(),"mm/dd/yy")>

	<!---If the message is approved, continue processing the order---->
		<cfif Results.Result IS 0>
			
			<cfset TransactNum = Results.PNREF>
  
	  		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				SET Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">,		
				Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="Charge voided on #thedate#<br/> #GetOrderTx.Notes#">,
				Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
				Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
			</cfquery>
		
	<cfelse>
  		<cfset ErrorMessage = Results.Respmsg>
  		
		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="Void failed on #thedate#: #ErrorMessage#<br/>  #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
			
	</CFIF>
	
<cfelse>

	<cfset ErrorMessage = "This order cannot be voided.">
			
</cfif>

