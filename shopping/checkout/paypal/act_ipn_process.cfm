
<!--- CFWebstore, version 6.50 --->

<cfparam name="Session.BasketNum" default="">
<cfparam name="Session.User_ID" default="0">
<cfparam name="Reason" default="">
<cfparam name="Confirmed" default="0">
<cfparam name="Verified" default="0">
<cfparam name="dbUpdate" default="0">

<cfset theDirectory = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
<cfset theDirectory = theDirectory & "logs">

<!--- post back to PayPal system to validate --->
<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset paypalserver = "https://www.paypal.com/cgi-bin/webscr">
<cfelse>
	<cfset paypalserver = "https://www.sandbox.paypal.com/cgi-bin/webscr">
</cfif>	

<cfparam name="logmess" default="">

<!--- Check for a PDT response --->
<cfif structkeyExists(url,"tx")>
	<cfset authToken=get_Order_Settings.PDT_Token>
	<cfset txToken = url.tx>
	<cfset query="cmd=_notify-synch&tx=" & UCase(txToken) & "&at=" & authToken>
	
	<cfhttp url="#paypalserver#?#query#" method="GET"></CFHTTP>

	<cfif left(cfhttp.FileContent,7) is "SUCCESS">
		<cfset Verified = 1>
		<cfloop index="curLine" list="#cfhttp.FileContent#" delimiters="#chr(10)#">
			<cfset form[trim(listFirst(curLine,"="))]=listrest(curLine,"=")>
		</cfloop>
		
	<cfelse>
		<cfmail to="#request.appsettings.webmaster#" from="#request.appsettings.merchantemail#"
             subject="#request.appsettings.sitename# Alert - Paypal Error" 
                server="#request.appsettings.email_server#" port="#request.appsettings.email_port#" 
                type="html">
                <h2>PDT error</h2>
                
                <cfdump var="#cfhttp.FileContent#" label="cfhttp">
                <cfdump var="#url#" label="url">
            </cfmail>
	</cfif>
	
<!--- Process IPN transaction --->
<cfelseif structkeyExists(form,"fieldnames")>

	<cfset str="cmd=_notify-validate">
	
		<cfloop item="theField" collection="#form#">
			<cfset str = str & "&#LCase(theField)#=#(Form[theField])#">
		</cfloop>
		<!--- post back to PayPal system to validate --->
	 	<cfhttp url="#paypalserver#?#str#" method="get" resolveurl="false" />
	 	
	 	<cfif CFHTTP.FileContent is "Verified">
	 		<cfset Verified = 1>
	 	</cfif>
	 	
</cfif>


<cfparam name="Form.FieldNames" default="">
<cfparam name="Form.payment_status" default="">
<cfparam name="Form.pending_reason" default="">
<cfparam name="Form.reason_code" default="">
<cfparam name="Form.txn_id" default="0">
<cfparam name="Form.receiver_email" default="">
<cfparam name="Form.mc_gross" default="0">
<cfparam name="Form.test_ipn" default="0">


<!--- assign posted variables to local variables --->

<cfset PayPalStatus = Form.payment_status>
<cfset mc_gross=Form.mc_gross>
<cfset receiver_email=Form.receiver_email>

<cfset PayPal = "yes">

<cfif isDefined("form.parent_txn_id")>
	<cfset AuthNumber = Form.parent_txn_id>
<cfelse>
<cfset AuthNumber = Form.txn_id>
</cfif>
		
<cftry>

<!--- we need to lock the code for each transaction ID to prevent any possibility of duplicating the order from customer and IPN occuring at the same time --->
<cflock type="exclusive" timeout="30" name="#AuthNumber#"> 
<cfset DateStamp = "Transaction " & AuthNumber & " received " & DateFormat(Now(), "mm/dd/yyyy")>
<cfset DateStamp = DateStamp & " " & Timeformat(Now(), "HH:mm") & " -">

<!--- check notification validation --->
<!--- <cfif CFHTTP.FileContent is "Verified"> --->
	<!--- check that receiver_email is your email address --->
	<!--- <cfif Form.receiver_email IS get_Order_Settings.PayPalEmail> --->

		<!--- Only save new orders if completed or pending --->
   	 	 <cfif PayPalStatus IS "Completed" OR PayPalStatus IS "Pending">
	        <!--- process payment --->
			
			<cfif PayPalStatus eq "Completed" AND Verified>
				<cfif Form.receiver_email IS get_Order_Settings.PayPalEmail>
					<cfset Confirmed = 1>
				<cfelse>
					<cfset PendingReason = "invalid">
					<cfset Reason = "the PayPal merchant email is not the primary email for the account and needs to be manually validated.">
					<cfset logmess = "#DateStamp# #Reason#">
				</cfif>
			<cfelseif NOT Verified>
				<cfset PendingReason = "invalid">
				<cfset Reason = "the transaction did not pass a validation check and needs to be manually validated.">
				<cfset logmess = "#DateStamp# #Reason#">
			<cfelse>
				<cfset PendingReason = Form.pending_reason>
				<cfinclude template="act_pending.cfm">
				<cfset logmess = "#DateStamp# #Reason#">
			</cfif>
			
			<!--- Check if this order has already been saved --->
			<cfquery name="GetOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
				SELECT Order_No FROM #Request.DB_Prefix#Order_No
				WHERE (AuthNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#">
				OR TransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#"> )
			</cfquery>
			
			<cfif GetOrder.RecordCount>
			<!--- Update the existing order --->
			
				<!--- Check if this is a customer returning from PayPal --->
				<cfif isDefined("attributes.PayPalCust")>
				
					<cfset attributes.step = "paypal">
					
				<cfelse>
					
					<cfset logmess = "#DateStamp# The order was updated.">
					<cfset message = "The order has been updated."> 
					<cfset dbUpdate = 1>
					<cfset attributes.step = "empty">
				
				</cfif>
				
						
			<cfelse>
			
				<!--- Check if the amount sent was correct and basket exists --->
				<cfquery name="GetTotal" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
					SELECT OrderTotal FROM #Request.DB_Prefix#TempOrder
					WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
				</cfquery>
				
				<!--- begin new IPN code --->    
                <cfif NOT GetTotal.RecordCount AND isdefined('form.IPN_track_ID')>  
                
                	<cfquery name="GetTotalIPN" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
						SELECT OrderTotal FROM #Request.DB_Prefix#TempOrder
						WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custom#">
					</cfquery>
                 	
                    <cfif getTotalIPN.recordcount>
                    
                    	<!--- get user --->
                        <cfquery name="qry_get_user" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
                            SELECT User_ID
                            FROM Users
                            WHERE Basket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custom#">
                        </cfquery>

						<!--- Place the IPN Order --->			
                        <cfset logmess = "#DateStamp# Transaction has been placed.">
                        <cfset session.basketnum = form.custom>
                         <cfif qry_get_user.recordcount>
                         	<cfset session.user_id = qry_get_user.user_id>
                         </cfif>
                        <cfset attributes.step = "receipt">
                        
                        <cfinclude template="../qry_get_basket.cfm">
                        <cfinclude template="../customer/qry_get_tempcustomer.cfm">

                    <cfelse>
                    	<!--- no order found --->
                    	<cfset logmess = "#DateStamp# The order could not be found in the database.">
						<cfset message = "Sorry, your order could not be found in our system. Please contact customer support."> 
						<cfset attributes.step = "error">
                    </cfif>
                    
				<!--- Could not find the order --->
				<cfelseif NOT GetTotal.RecordCount>
                <!--- NWH :: end IPN code --->
					<cfset logmess = "#DateStamp# The order could not be found in the database.">
					<cfset message = "Sorry, your order could not be found in our system (Basket ###Session.BasketNum#). Please contact customer support."> 
					<cfset attributes.step = "error">
					
				<!--- Amount of order does not match --->	
				<cfelseif Round(GetTotal.OrderTotal*100)/100 IS NOT Round(mc_gross*100)/100>
					<cfset logmess = "#DateStamp# The amount of the transaction was invalid. PayPal returned an amount of #LSCurrencyFormat(Round(mc_gross*100)/100)#.">
					<cfset Confirmed = 0>
					<cfset PendingReason = "invalid">
					<cfset Reason = "The amount returned by PayPal did not match the order total and needs to be manually validated.">
					<cfset attributes.step = "receipt">
				<cfelse>
					
					<!--- Place the Order --->			
					<cfset logmess = "#DateStamp# Transaction has been placed.">
					<cfset attributes.step = "receipt">
				</cfif>			
			
			</cfif>
		
		<cfelseif PayPalStatus IS "Failed">
		    <!--- log for investigation --->
			<cfset logmess = "#DateStamp# Transaction failed.">
			<cfset message = "Your transaction was declined. Please use another method of payment."> 
			<cfset Reason = "a payment from your customer's bank account failed.">
			<cfset dbUpdate = 1>
			<cfset attributes.step = "error">
			
			
		<cfelseif PayPalStatus IS "Denied">
		    <!--- log for investigation --->
			<cfset logmess = "#DateStamp# Transaction denied by merchant.">
			<cfset message = "Your transaction was declined. Please use another method of payment."> 
			<cfset Reason = "the payment was denied by the merchant.">
			<cfset dbUpdate = 1>
			<cfset attributes.step = "error">
			
		<cfelseif PayPalStatus IS "Refunded" OR PayPalStatus IS "Reversed">
		    <!--- log for investigation --->
			<cfset RefundReason = Form.reason_code>
			<cfinclude template="act_reversed.cfm">
			<cfset logmess = "#DateStamp# The transaction has been #Lcase(PayPalStatus)#.">
			<cfset message = "The transaction was #Lcase(PayPalStatus)#."> 
			<cfset Reason = "the payment was refunded by the merchant.">
			<cfset dbUpdate = 1>
			<cfset attributes.step = "error">
			
			
		<cfelseif PayPalStatus IS "Canceled">
		    <!--- log for investigation --->
			<cfset logmess = "#DateStamp# Transaction reversal has been cancelled.">
			<cfset message = "The transaction reversal was cancelled."> 
			<cfset Reason = "the merchant won a dispute with the customer and the funds for the transaction that was reversed have been returned.">
			<cfset dbUpdate = 1>
			<cfset attributes.step = "error">
	
		</cfif>
		
	</cflock>
	
    
    <cfcatch type = "any">
	<cfmail to="#request.appsettings.webmaster#" from="#request.appsettings.merchantemail#"
     subject="#request.appsettings.sitename# Alert - Paypal Error" 
        server="#request.appsettings.email_server#" port="#request.appsettings.email_port#" 
        type="html">
        <!--- The message to display. --->
        <h3>IPN code</h3>
        <cfoutput>
            <!--- The diagnostic message from ColdFusion. --->
            <p>#cfcatch.message#</p>
            <p>Caught an exception, type = #CFCATCH.TYPE#</p>
            <p>The contents of the tag stack are:</p>
            <cfdump var="#cfcatch#">
        </cfoutput>
	</cfmail>
    </cfcatch>
</cftry>		
			
	<cfif dbUpdate>
	<!--- Update the Order in the Database --->		
		<cfquery name="GetOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
			UPDATE #Request.DB_Prefix#Order_No
			SET 
			<cfif Confirmed>Paid = 1,
			<cfelse>
				Paid = 0,
			</cfif>
			PayPalStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PayPalStatus#">,
			Reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Reason#">,
			TransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txn_id#">
			WHERE (AuthNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#">
				OR TransactNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#AuthNumber#"> )
		</cfquery>
	</cfif>	
			
<!--- 	<cfelse>
		<cfset logmess = "#DateStamp# Invalid email address returned.">
		<cfset message = "There was a problem processing your order. Please contact technical support."> 
		<cfset attributes.step = "error">
	</cfif> --->

<!--- <cfelse>
    <!--- log for investigation --->
	<cfset logmess = "#DateStamp# Invalid transaction returned.#CFHTTP.FileContent#">
	<cfset message = "There was a problem processing your order. Please contact technical support."> 
	<cfset attributes.step = "error">

</cfif> --->

<cfif len(logmess) AND get_Order_Settings.PayPalLog>
	<cftry>
	<cffile action="append" file="#theDirectory##Request.slash#paypal_log.txt" output="#logmess#">
	<cfcatch></cfcatch>
	</cftry>	
</cfif>

