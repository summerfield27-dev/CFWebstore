
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to complete the payment processing on an order using PayPal Pro. The order must have been previously authorized. It looks up the authorization number and bills.  Called from shopping\admin\order\act_billing.cfm

	Required: Order_no
	
--->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT CCServer, Password, Setting1, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!--- Look up the Order Info --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, OrderTotal, Notes, TransactNum
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer"> 
	AND Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
	AND Void = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
</cfquery>

<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset PPServer = "https://api-3t.paypal.com/2.0/" >
<cfelse>
	<cfset PPServer = "https://api-3t.sandbox.paypal.com/2.0/" >
</cfif>	

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1>

	<CF_PayPalDirectCapture
		STRUCTNAME="Results"
		USERNAME="#GetSettings.Username#"
	    PASSWORD="#GetSettings.Password#"
		SERVER="#PPServer#"
		SIGNATURE="#GetSettings.Setting1#"
	    AMOUNT="#GetOrderTx.OrderTotal#"
	    TransactNum="#GetOrderTx.TransactNum#">

	<!--- Debug --->
	<!--- <cfdump var="#Results#"> --->
	<cfset thedate = dateformat(now(),"mm/dd/yy")>
	
	<!---If the message is approved, continue processing the order---->
	<cfif Results.Success IS 1>
  
  		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Paid = 1,
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="SETTLED #thedate#: #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
		
	<cfelse>
  		<cfset ErrorMessage = Results.errormessage>
  		
		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = 'PayPal billing failed on #theDate#: #ErrorMessage#  #GetOrderTx.Notes#',
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam value="#attributes.Order_no#" cfsqltype="cf_sql_integer">
		</cfquery>
			
	</cfif>
			
</cfif>
