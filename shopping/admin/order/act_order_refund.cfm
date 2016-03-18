<!--- CFWebstore, version 6.50 --->

<!--- Processes the Order Refund Screen. Updates the order information and sends emails. Called by index.cfm --->

<!--- CSRF Check --->
<cfset keyname = "orderRefund">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif NOT isNumeric(attributes.RefundAmount)>
	<cfset attributes.RefundAmount = 0>
</cfif>

<cfset ErrorMessage = "">

<cfquery name="GetCustPreRefund" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT O.OriginalTotal, O.OrderTotal
	FROM #Request.DB_Prefix#Order_No O
	WHERE O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

<cfif get_Order_Settings.CCProcess IS "AuthorizeNet3">
	<cfinclude template="../../checkout/creditcards/authorizenet/act_authnet3_refund.cfm">
<cfelseif get_Order_Settings.CCProcess IS "PayFlowPro4">
	<cfinclude template="../../checkout/creditcards/payflowpro/act_payflowpro4_refund.cfm">
<cfelseif get_Order_Settings.CCProcess IS "Shift4OTN">
	<cfinclude template="../../checkout/creditcards/shift4/act_shift4otn_refund.cfm">
</cfif>

<cfif isDefined("attributes.EmailCustomer") AND attributes.EmailCustomer IS 1 AND NOT len(ErrorMessage)>

	
	<cfquery name="GetCust" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT C.Email, O.DateOrdered, O.OriginalTotal, O.OrderTotal, C.Firstname, C.LastName, O.User_ID, O.Customer_ID
		FROM #Request.DB_Prefix#Order_No O, #Request.DB_Prefix#Customers C
		WHERE O.Customer_ID = C.Customer_ID
		AND O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>

	<cfset LineBreak = Chr(13) & Chr(10)>

	<!--- Initialize the content of the message --->
	<cfset Message = "The following order has been refunded:" & LineBreak & "-----------------" & LineBreak & LineBreak>

	<cfset Message = Message & "Order Number: " & attributes.Order_No + get_order_settings.BaseOrderNum & LineBreak>
	
	<cfset Message = Message & "Placed: " & LSDateFormat(GetCust.DateOrdered, "mmmm d, yyyy") & LineBreak & LineBreak>
	
	<cfset Message = Message & "Original Order Total: " & LSCurrencyFormat(GetCust.OriginalTotal) & LineBreak & LineBreak>

	<cfif GetCustPreRefund.OriginalTotal NEQ GetCustPreRefund.OrderTotal>
		<cfset Message = Message & "Previously Adjusted Order Total: " & LSCurrencyFormat(GetCustPreRefund.OrderTotal) & LineBreak & LineBreak>
	</cfif>
	
	<cfset Message = Message & "Refund Amount: " & LSCurrencyFormat(attributes.RefundAmount) & LineBreak & LineBreak>
	
	<cfset Message = Message & "Current Charges: " & LSCurrencyFormat(GetCust.OrderTotal) & LineBreak & LineBreak>

	<!--- If notes added, add to the email message --->
	<cfif len(Trim(attributes.CustNotes))>
		<cfset Message = Message & attributes.CustNotes & LineBreak & LineBreak>
	</cfif>
	
	
	<cfinvoke component="#Request.CFCMapping#.global" 
		method="sendAutoEmail" UID="#GetCust.User_ID#" 
		Email="#GetCust.Email#" MergeName="#GetCust.Firstname# #GetCust.Lastname#"
		MailAction="OrderRefund" MergeContent="#Message#">
				
</cfif>