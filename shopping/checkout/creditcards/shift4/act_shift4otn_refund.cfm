
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run refunds through Shift4 $$$ ON THE NET. Called from shopping/admin/order/checkout/act_order_refund.cfm --->

<cfset Vendor="CFWebstore6">

<!--- Retrieve $$$ ON THE NET settings --->
<cfinclude template="qry_get_Shift4OTN_Settings.cfm">

<!--- Look up the Order Info and credit card number --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, TransactNum
	FROM #Request.DB_Prefix#Order_No O
	WHERE O.Order_No = <cfqueryparam value="#attributes.Order_No#" cfsqltype="cf_sql_integer"> 
	AND O.Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="1">
	AND O.Void = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">
</cfquery>

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1>
	<!--- see if split tender was used --->
	<cfset variables.splitTender=false />
	<cfset qGetCards=application.objCheckout.getPayments("",attributes.Order_No) />
	<cfset variables.splitTender=qGetCards.RecordCount GT 0 />

	<cfset parms=Replace(GetOrderTx.TransactNum,",,",", ,","ALL")>
	<cfif ListLen(parms) GTE 5>
		<cfset InvoiceNum=Trim(ListGetAt(parms,1))>
		<cfset CardNumLast4=Trim(ListGetAt(parms,2))>
		<cfset TranID=Trim(ListGetAt(parms,3))>
		<cfset PrimaryAmount=Val(ListGetAt(parms,4))>
		<cfset oldSplitTenderFlag=ListGetAt(parms,5) is not "NO">
		<cfif Len(TranID) EQ 16>
			<cfset UniqueID=TranID>
			<cfset TranID=0>
		<cfelse>
			<cfset UniqueID="">
			<cfset TranID=Val(TranID)>
		</cfif>
	<cfelse>
		<cfset InvoiceNum=Trim(ListGetAt(parms,1))>
		<cfset UniqueID=Trim(ListGetAt(parms,2))>
		<cfset PrimaryAmount=Val(ListGetAt(parms,3))>
		<cfset oldSplitTenderFlag=ListLen(parms) EQ 4 and ListGetAt(parms,4) is "YES">
		<cfset Vendor=Vendor & "_TOK">
		<cfset TranID=0>
	</cfif>
	<cfif PrimaryAmount EQ 0>
		<cfset PrimaryAmount=Val(GetOrderTx.OrderTotal)>
	</cfif>

	<cfsavecontent variable="HTMLText">
		<cfmodule template="../../../order/put_order.cfm" Order_No="#attributes.Order_no#" Type="Admin">
	</cfsavecontent>

	<cfset variables.notes = "" />
	<cfset variables.theDate = dateformat(now(),"mm/dd/yy")>
	<cfset variables.refundedAmount = 0 />
	<cfif variables.splitTender>
		<cftry>
			<!--- attempt to flip query over to refund last payment first --->
			<cfquery name="qGetCardsFlipped" dbtype="query">
				select * from qGetCards
				order by paymentID DESC
			</cfquery>
			<cfset qGetCards = qGetCardsFlipped />
			<cfcatch type="database">
				<!--- ignore the error --->
			</cfcatch>
		</cftry>
		<cfloop query="qGetCards">
			<cfif captured and amount GT 0>
				<cfset variables.thisAmount = min(amount,round((attributes.refundAmount-variables.refundedAmount)*100)/100) />
				<cfmodule template="../../../../customtags/crypt.cfm" action="de" string="#EncryptedCard#" key="#Request.encrypt_key#">
				<cfset uniqueID=mid(crypt.value,2,20) />
				<cf_Shift4OTN
					Result="OTN"
					URL="#get_Shift4OTN_Settings.URL#"
					ProxyServer="#get_Shift4OTN_Settings.ProxyServer#"
					ProxyPort="#get_Shift4OTN_Settings.ProxyPort#"
					ProxyUsername="#get_Shift4OTN_Settings.ProxyUsername#"
					ProxyPassword="#get_Shift4OTN_Settings.ProxyPassword#"
					SerialNumber="#get_Shift4OTN_Settings.SerialNumber#"
					Username="#get_Shift4OTN_Settings.Username#"
					Password="#get_Shift4OTN_Settings.Password#"
					FunctionRequestCode="06"
					MerchantID="#get_Shift4OTN_Settings.MID#"
					UniqueID="#UniqueID#"
					SaleFlag = "C"
					CustomerName="#NameOnCard#"
					PrimaryAmount="#variables.thisAmount#"
					SecondaryAmount="0.00"
					APIOptions="ALLDATA"
					Vendor="#Vendor#">
					<!--- This is commented out to avoid credit on top of sale collision. Should probably figure out some cleaner logic sometime.
					Invoice="#InvoiceNum#"
					--->
				<cfif OTN.ErrorIndicator NEQ "N">
					<cfbreak />
				</cfif>
				<cfset variables.refundedAmount = round((variables.refundedAmount+variables.thisAmount)*100) / 100 />
				<cfset variables.notes = variables.notes & "Refunded #LSCurrencyFormat(variables.thisAmount)# on #variables.theDate# to xxxxxxxxxxxx#mid(uniqueID,1,4)#.<br/>">
				<cfset application.objCheckout.capturePayment(paymentID=PaymentID,refundAmount=variables.thisAmount) />
			</cfif>
		</cfloop>
		<cfset attributes.refundAmount = variables.refundedAmount />
	<cfelse>
		<cf_Shift4OTN
			Result="OTN"
			URL="#get_Shift4OTN_Settings.URL#"
			ProxyServer="#get_Shift4OTN_Settings.ProxyServer#"
			ProxyPort="#get_Shift4OTN_Settings.ProxyPort#"
			ProxyUsername="#get_Shift4OTN_Settings.ProxyUsername#"
			ProxyPassword="#get_Shift4OTN_Settings.ProxyPassword#"
			SerialNumber="#get_Shift4OTN_Settings.SerialNumber#"
			Username="#get_Shift4OTN_Settings.Username#"
			Password="#get_Shift4OTN_Settings.Password#"
			FunctionRequestCode="06"
			MerchantID="#get_Shift4OTN_Settings.MID#"
			UniqueID="#UniqueID#"
			SaleFlag = "C"
			PrimaryAmount="#attributes.refundAmount#"
			SecondaryAmount="0.00"
			Notes="#HTMLText#"
			APIOptions="ALLDATA"
			Vendor="#Vendor#">
			<!--- This is commented out to avoid credit on top of sale collision. Should probably figure out some cleaner logic sometime.
			Invoice="#InvoiceNum#"
			--->
		<cfif otn.ErrorIndicator is "N">
			<cfset variables.refundedAmount = attributes.refundAmount />
			<cfset variables.notes = variables.notes & "Refunded #LSCurrencyFormat(attributes.refundAmount)# on #variables.theDate# to xxxxxxxxxxxx#mid(uniqueID,1,4)#.<br/>">
		</cfif>
	</cfif>

	<cfif OTN.ErrorText is not "">
		<cfabort showerror="#OTN.ErrorText#">
	</cfif>

	<!---- Check for error response ---->
	<CFIF OTN.ErrorIndicator is "Y">

		<cfset ErrorMessage="#OTN.LongError# (#OTN.PrimaryErrorCode#,#OTN.SecondaryErrorCode#)">
		<cfset variables.notes = variables.notes & "ERROR refunding #LSCurrencyFormat(variables.thisAmount)# on #variables.theDate# to xxxxxxxxxxxx#mid(uniqueID,1,4)# - #ErrorMessage#<br/>">

	</CFIF>

	<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
		UPDATE #Request.DB_Prefix#Order_No
		SET
			OrderTotal = OrderTotal - <cfqueryparam cfsqltype="cf_sql_double" value="#variables.refundedAmount#">,	
			Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#variables.notes##GetOrderTx.Notes#">,
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE
			Order_No = <cfqueryparam value="#attributes.Order_No#" cfsqltype="cf_sql_integer"> 
	</cfquery>
			
</cfif>
