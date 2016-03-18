
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run Shift4 $$$ ON THE NET credit card validation. Called from checkout/act_pay_form.cfm --->

<cfset strCustAddress = Application.objCheckout.doCustomerAddress(GetCustomer,GetShipTo) />

<cfset ProductDescriptor1 = "" />
<cfset ProductDescriptor2 = "" />
<cfset ProductDescriptor3 = "" />
<cfset ProductDescriptor4 = "" />
<cfoutput query="qry_Get_Basket">
	<cfset ProductDescriptor[qry_Get_Basket.CurrentRow] = Left(qry_Get_Basket.Name,40) />
</cfoutput>

<cfset variables.vendor="CFWebstore6">
<cfset AdminNotes = "">
<cfset BatchAbort = "NO">
<cfset variables.debugLog=""> <!--- "debugCFWebstore.log"> --->

<!--- Retrieve $$$ ON THE NET settings --->
<cfinclude template="qry_get_Shift4OTN_Settings.cfm">	
<cfinclude template="../../../qry_get_order_settings.cfm">	

<cfparam name="attributes.CVV2" default="">
<cfset s4CVV2Indicator="">
<cfif get_Order_Settings.usecvv2>
	<cfset s4CVV2Indicator="0">
</cfif>
<cfif attributes.CVV2 is not "">
	<cfset s4CVV2Indicator="1">
</cfif>
<cfset s4UniqueID="">
<cfset s4CardNumber=attributes.CardNumber>
<cfif Len(s4CardNumber) EQ 17 and Left(s4CardNumber,1) is "@">
	<cfset s4UniqueID=Mid(s4CardNumber,2,16)>
	<cfset s4CardNumber="">
	<cfset s4CVV2Indicator="">
	<cfset attributes.CVV2="">
	<cfset attributes.CardNumber="xxxxxxxxxxxx#Left(s4UniqueID,4)#">
</cfif>

<cfif FindNoCase("Gift",attributes.cardType) NEQ 0>
	<cfset ZipCode="">
<cfelse>
	<cfset ZipCode=GetCustomer.Zip>
</cfif>

<cfquery name="qTempOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#TempOrder
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>
<cfif Val(qTempOrder.RecordCount) NEQ 1>
	<cfabort showerror="DATABASE LOGIC FAULT: Unexpected number of order header records returned (expected 1, returned #Val(qTempOrder.RecordCount)#).">
</cfif>

<cfset variables.isSplitTender=false>
<cfset qPayments=application.objCheckout.GetPayments(Session.BasketNum)>
<cfset variables.isSplitTender=qPayments.RecordCount NEQ 0>

<cfset invoiceNum="">
<cfif variables.isSplitTender>
	<cfset invoiceNum=qPayments.invoiceNum>
</cfif>
<cfif invoiceNum EQ "">
	<cfset variables.orderCount=0>
	<cflock scope="application" timeout="15" throwontimeout="no">
		<cfparam name="application.orderCount" default="0">
	    <cfset application.orderCount=application.orderCount+1>
		<cfset variables.orderCount=application.orderCount>
	</cflock>
	<cfset invoiceNum="#Right('000000#variables.orderCount#',6)##DateFormat(Now(),'dd')##TimeFormat(Now(),'mm')#">
	<cfif IsDefined("qTempOrder.ID") and Val(qTempOrder.ID) GT 0>
		<cfset invoiceNum="#Right('0000000000#Val(qTempOrder.ID)#',10)#">
	<cfelseif IsDefined("qTempOrder.DateAdded") and qTempOrder.DateAdded is not "">
		<cfset doyhash=DayOfYear(qTempOrder.DateAdded) mod 100>
		<cfset invoiceNum="#Right('0000#variables.orderCount##doyhash#',4)##TimeFormat(qTempOrder.DateAdded,'HHmmss')#">
	</cfif>
</cfif>

<cfset ErrorMessage="">
<cfset RemainingBalance=GetTotals.OrderTotal>
<cfset ExpirationMonth=Val(ListFirst(cardexp,"/"))>
<cfset ExpirationYear=Val(ListLast(cardexp,"/"))>

<cfif IsDefined("variables.debugLog") and variables.debugLog NEQ "">
	<cflog text="GetTotals.OrderTotal=#RemainingBalance#" type="Information" file="#variables.debugLog#" thread="yes" date="yes" time="yes">
</cfif>

<cfset variables.apiOptions="ALLDATA">
<cfset variables.apiOptions="ALLDATA,ALLOWPARTIALAUTH">
<cfif variables.isSplitTender>
	<cfloop query="qPayments">
		<cfset RemainingBalance=RemainingBalance-amount>
	</cfloop>
</cfif>

<cfif IsDefined("variables.debugLog") and variables.debugLog NEQ "">
	<cflog text="RemainingBalance=#RemainingBalance# / CardNumber='#s4CardNumber#' / UniqueID='#s4UniqueID#'" type="Information" file="#variables.debugLog#" thread="yes" date="yes" time="yes">
</cfif>

<cfset TaxIndicator = "N" />
<cfset TaxAmount = 0 />
<cfloop from="1" to="#ArrayLen(Session.CheckoutVars.TaxTotals)#" index="i">
	<cfif val(Session.CheckoutVars.TaxTotals[i].TotalTax)>
        <cfset TaxIndicator = "Y" />
        <cfset TaxAmount = TaxAmount + Val(Session.CheckoutVars.TaxTotals[i].TotalTax) />
    </cfif>
</cfloop>

<cfset variables.doVoid=false>
<!---CardNumber = "#s4CardNumber#"--->
<cf_Shift4OTN
	Result = "OTN"
	URL = "#get_Shift4OTN_Settings.URL#"
	ProxyServer="#get_Shift4OTN_Settings.ProxyServer#"
	ProxyPort="#get_Shift4OTN_Settings.ProxyPort#"
	ProxyUsername="#get_Shift4OTN_Settings.ProxyUsername#"
	ProxyPassword="#get_Shift4OTN_Settings.ProxyPassword#"
	SerialNumber = "#get_Shift4OTN_Settings.SerialNumber#"
	Username = "#get_Shift4OTN_Settings.Username#"
	Password = "#get_Shift4OTN_Settings.Password#"
	FunctionRequestCode = "#get_Shift4OTN_Settings.FunctionRequestCode#"
	MerchantID = "#get_Shift4OTN_Settings.MID#"
	Invoice = "#InvoiceNum#"
	CardEntryMode = "M"
	CardNumber = "#s4CardNumber#"
	UniqueID = "#s4UniqueID#"
	CardPresent = "N"
	CustomerName = "#attributes.NameOnCard#"
	ExpirationMonth = "#ExpirationMonth#"
	ExpirationYear = "#ExpirationYear#"
	SaleFlag = "S"
	PrimaryAmount = "#RemainingBalance#"
	SecondaryAmount = "0.00"
    ProductDescriptor1 = "#ProductDescriptor1#"
    ProductDescriptor2 = "#ProductDescriptor2#"
    ProductDescriptor3 = "#ProductDescriptor3#"
    ProductDescriptor4 = "#ProductDescriptor4#"
    TaxIndicator = "#TaxIndicator#"
	TaxAmount = "#TaxAmount#"
	CVV2Indicator = "#s4CVV2Indicator#"
	CVV2Code = "#attributes.CVV2#"
	ZipCode = "#ZipCode#"
    DestinationZipCode = "#strCustAddress.Shipping.Zip#"
	Notes = "Would be nice to have HTML Invoice here"
	APIOptions="#variables.apiOptions#"
	Vendor="#variables.vendor#">
    <!--- <cfdump var="#OTN#"> --->
<cfif OTN.ErrorText is not "">
	<cfabort showerror="#OTN.ErrorText#">
</cfif>

<cfif IsDefined("variables.debugLog") and variables.debugLog NEQ "">
	<cflog text="OTN.errorIndicator='#OTN.errorIndicator#' / OTN.responseCode='#OTN.responseCode#' / OTN.uniqueID='#OTN.uniqueID#' / OTN.primaryAmount=#OTN.primaryAmount#" type="Information" file="#variables.debugLog#" thread="yes" date="yes" time="yes">
</cfif>

<cfif OTN.ErrorIndicator is "Y">

	<!--- error response - handle the best we can --->
	<cfparam name="OTN.CardNumber" default="">
	<cfparam name="OTN.TranID" default="">
	<cfset variables.doVoid=true>
	<cfif OTN.PrimaryErrorCode EQ 9842>
		<cfset ErrorMessage="Invalid Card Number... The card number you entered is not valid. Please enter the information again.">
		<cfset AdminNotes="Invalid Card Number">
	<cfelse>
		<cfset ErrorMessage="DOTN Interface Error... Sorry, there was a problem processing your order. Please try your request again or contact the web master if the problem persists. (#OTN.LongError# (#OTN.PrimaryErrorCode#,#OTN.SecondaryErrorCode#))">
		<cfset AdminNotes="DOTN Interface Error - #OTN.LongError# (#OTN.PrimaryErrorCode#,#OTN.SecondaryErrorCode#)">
		<cfset BatchAbort="YES">
	</cfif>
	<cfset Display="Yes">

<cfelse>

	<!--- non-error response --->
	<cfif IsDefined("OTN.UniqueID")>
		<cfif OTN.UniqueID is not "">
			<cfset attributes.SaveCardNumber="@#OTN.UniqueID#">
	
			<!--- Users token update - token in CardData will be updated via normal processing in act_save_order.cfm --->
			<cfset tokenUserID=session.User_ID>
			<cfif IsDefined("User_ID")>
				<cfset tokenUserID=User_ID>
			<cfelseif IsDefined("attributes.User_ID")>
				<cfset tokenUserID=attributes.User_ID>
			</cfif>
			<cfmodule template="../../../../customtags/crypt.cfm" string="#attributes.SaveCardNumber#" key="#Request.encrypt_key#" return="newtoken">
			<cfquery name="SetCardNoOnFile" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Users 
				SET		EncryptedCard = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newtoken.value#">
				WHERE	User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tokenUserID#">
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif OTN.ResponseCode is "A">

		<cfset RemainingBalance=Round((RemainingBalance-OTN.primaryAmount)*100) / 100.0>
		<cfset application.objCheckout.addPayment(session.basketNum,invoiceNum,attributes.cardType,"@"&OTN.uniqueID,OTN.primaryAmount,attributes.nameOnCard)>
			<!---
			<cfif RemainingBalance GT 0 or variables.isSplitTender>
				<!--- Only use the multi-tender layer on invoices where multiple-tenders are used --->
				<cfif IsDefined("variables.debugLog") and variables.debugLog NEQ "">
					<cflog text="application.objCheckout.addPayment('#session.basketNum#','#invoiceNum#','#attributes.cardType#','@#OTN.uniqueID#',#OTN.primaryAmount#,'#attributes.nameOnCard#')" type="Information" file="#variables.debugLog#" thread="yes" date="yes" time="yes">
				</cfif>
				<cfset application.objCheckout.addPayment(session.basketNum,invoiceNum,attributes.cardType,"@"&OTN.uniqueID,OTN.primaryAmount,attributes.nameOnCard)>
			</cfif>
			--->
		<cfif RemainingBalance LTE 0>
			<!--- Invoice has been completely paid, proceed to next step --->
			<cfset AuthNumber=OTN.Authorization>
			<cfset TransactNum="#invoiceNum#,#OTN.uniqueID#,#Trim(NumberFormat(OTN.primaryAmount,'9999999.00'))#,#variables.isSplitTender#">
			<cfset attributes.step = "receipt">
		<cfelse>
			<!--- Invoice has only been partially paid, go back and allow user to enter another payment method --->
			<cfset ErrorMessage = "<h2>PARTIAL PAYMENT APPLIED</h2>A payment of #DollarFormat(OTN.primaryAmount)# was applied which represents the total remaining balance on the card/certificate. Please enter another form of payment for the remaining balance of #DollarFormat(RemainingBalance)#.">
			<cfset Display="Yes">
		</cfif>

	<cfelse>

		<!--- Payment failed to be approved, display the reason and allow user to enter another payment method --->
		<cfset doVoid=true>
		<cfif IsDefined("OTN.ValidAVS") and OTN.ValidAVS is "N">
			<cfset ErrorMessage = "Sorry, invalid billing information... The billing address you provided did not match the billing address of the credit card used. Please correct the address or use another form of payment.">
			<cfset AdminNotes = "Invalid Billing Information (AVS failure)">
		<cfelseif IsDefined("OTN.CVV2Valid") and OTN.CVV2Valid is "N">
			<cfset AdminNotes = "Invalid CVV2 Information">
			<cfset ErrorMessage = "Sorry, invalid CVV2 information... The CVV2 code on the back of the card did not match with what your bank has on file. Please correct the code or use another form of payment.">
		<cfelseif OTN.ResponseCode is "D">
			<cfset AdminNotes = "Declined">
			<cfset ErrorMessage = "Sorry... Your bank declined the transaction. Please resolve the issue with your bank or use another form of payment.">
		<cfelseif OTN.ResponseCode is "R">
			<cfset AdminNotes = "Voice Referral">
			<cfset ErrorMessage = "Sorry... Your bank did not approve the transaction. Please resolve the issue with your bank or use another form of payment.">
		<cfelse>
			<cfabort showerror="Unexpected response (#OTN.ResponseCode#) on #FunctionRequestCode# authorization request.">
		</cfif>
		<cfset Display="Yes">

	</cfif>
</cfif>

<cfif variables.doVoid>
		<!---CardNumber = "#Right(OTN.CardNumber,4)#"
		TranID = "#OTN.TranID#"--->
        <!--- If token is not available, send last 4 of card number --->
	<cf_Shift4OTN
		Result = "OTNVoid"
		URL = "#get_Shift4OTN_Settings.URL#"
		ProxyServer="#get_Shift4OTN_Settings.ProxyServer#"
		ProxyPort="#get_Shift4OTN_Settings.ProxyPort#"
		ProxyUsername="#get_Shift4OTN_Settings.ProxyUsername#"
		ProxyPassword="#get_Shift4OTN_Settings.ProxyPassword#"
		SerialNumber = "#get_Shift4OTN_Settings.SerialNumber#"
		Username = "#get_Shift4OTN_Settings.Username#"
		Password = "#get_Shift4OTN_Settings.Password#"
		FunctionRequestCode = "08"
		Timeout = "5"
		MerchantID = "#get_Shift4OTN_Settings.MID#"
		Invoice = "#InvoiceNum#"
        UniqueID = "#OTN.UniqueID#"
		Vendor="#variables.vendor#"
        APIOptions = "ALLDATA">
</cfif>
