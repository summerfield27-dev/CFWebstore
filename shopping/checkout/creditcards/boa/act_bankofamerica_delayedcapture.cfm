<!--- CFWebstore, version 6.50 --->

<!--- This template is used to complete the payment processing on an order using Bank of America's eStores payment processing. The order must have been previously authorized. It looks up the authorization number and submits the charges for Settlement.  Called from shopping\admin\act_billing.cfm

	Required: Order_no
	
--->

<!--- Get Settings: ioc_merchant_id, ioc_auto_settle_flag, ioc_cvv_indicator --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Transtype, Setting1, CCServer, Password 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfinclude template="../act_decrypt_settings.cfm">

<!--- Look up the Order Info --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, TransactNum
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#"> 
	AND AuthNumber <> <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
	AND Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
	AND Void = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
</cfquery>

<cfif GetOrderTx.recordcount is 1>

<!--- Field Values passed
IOC_Handshake_ID 					text 32 (unique)			cfuuid
ioc_merchant_id 					R eStores Store ID 			GetSettings.Username
IOC_User_Name 						R							GetSettings.CCServer
IOC_Password						R							GetSettings.Password

IOC_order_number 					R							GetOrderTx.TransactNum
IOC_indicator 						R							s=settlement, R=return
IOC_settlement_amount 				R							GetOrderTx.OrderTotal
IOC_authorization_code				R							GetOrderTx.AuthNumber
--->
	
<CF_bankofamerica
	TransactionType="Settlement"
	Referer="#Request.StoreURL#"
	FieldNames="IOC_Handshake_ID~ioc_merchant_id~IOC_User_Name~IOC_Password~IOC_order_number~IOC_indicator~IOC_settlement_amount~IOC_authorization_code"
	FieldValues="#createuuid()#~#GetSettings.Username#~#GetSettings.CCServer#~#GetSettings.Password#~#GetOrderTx.TransactNum#~s~#NumberFormat(GetOrderTx.OrderTotal, "________.00")#~#GetOrderTx.AuthNumber#"
>

<!--- DEBUG - View response by uncommenting lines below: 
<hr/>
<cfoutput>#BAReturned#</cfoutput>
<hr/>
<cfabort>
 --->


	<!--- Results placed into structure called eStoresResults with the following variables (return field names):
	IOC_Handshake_ID
	IOC_Processes_Flag					Yes or No
	IOC_Settlement_amount
	IOC_Response_code
	IOC_Response_Desc
	---->

	<cfset thedate = dateformat(now(),"mm/dd/yy")>
	
	<!---If the message is approved, continue processing the order---->
	<cfif eStoresResults.Processes_Flag IS "Yes">
  
  		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Paid = 1,
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="SETTLED #thedate#: #eStoresResults.Response_Desc#   #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
		
	<cfelse>
  				
		<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="CC billing failed on #thedate#: #eStoresResults.Response_Desc#  #GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
		</cfquery>
			
	</CFIF>
			
</cfif>


