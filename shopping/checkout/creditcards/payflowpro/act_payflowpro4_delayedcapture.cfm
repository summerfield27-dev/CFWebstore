
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to complete the payment processing on an order using PayFlow Pro HTTP version 4. The order must have been previously authorized. It looks up the authorization number and bills.  Called from shopping\admin\act_billing.cfm

	Required: Order_no
	
--->

<!--- Retrive PayFlowPro settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer, Setting1
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!--- Look up the Order Info --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, TransactNum
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer"> 
	AND AuthNumber <> <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
	AND Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
	AND Void = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
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
	 	ACTION="D"
	    AMOUNT="#GetOrderTx.OrderTotal#"
	    TransactNum="#GetOrderTx.TransactNum#">

	<!--- Debug --->
	<!--- <cfdump var="#Result#"> --->
	
	<cfset thedate = dateformat(now(),"mm/dd/yy")>

	<!---If the message is approved, continue processing the order---->
	<cfif Results.Result IS 0>
		
		<cfset TransactNum = Results.PNREF>
  
  		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Paid = 1,		
			LastTransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TransactNum#">,	
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="SETTLED #thedate#: #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
		
	<cfelse>
		<cfset ErrorMessage = Results.Respmsg>
  		
		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="CC billing failed on #thedate#: #ErrorMessage#  #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
			
	</cfif>
			
</cfif>
