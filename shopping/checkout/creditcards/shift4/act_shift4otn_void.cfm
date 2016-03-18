
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to run Shift4 $$$ ON THE NET credit card validation. Called from checkout/act_pay_form.cfm --->

<cfset Vendor="CFWebstore6">

<!--- Retrieve $$$ ON THE NET settings --->
<cfinclude template="qry_get_Shift4OTN_Settings.cfm">

<!--- Look up the Order Info --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, AuthNumber, OrderTotal, Notes, TransactNum
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#"> 
</cfquery>

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1>
<!--- see if split tender was used --->
	<cfset variables.splitTender=false>
	<cfset qGetCards=application.objCheckout.getPayments("",attributes.Order_No)>
	<cfset variables.splitTender=qGetCards.RecordCount NEQ 0>

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

	<cfif variables.splitTender>
		<cfloop query="qGetCards">
			<cfmodule template="../../../../customtags/crypt.cfm" action="de" string="#EncryptedCard#" key="#Request.encrypt_key#">
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
				FunctionRequestCode="08"
				MerchantID="#get_Shift4OTN_Settings.MID#"
				Invoice="#InvoiceNum#"
				UniqueID="#Mid(crypt.value,2,20)#"
				APIOptions="ALLDATA"
				Vendor="#Vendor#">
			<cfif OTN.ErrorIndicator NEQ "N">
				<cfbreak>
			</cfif>
			<cfset application.objCheckout.capturePayment(PaymentID,false)>
		</cfloop>
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
			FunctionRequestCode="08"
			MerchantID="#get_Shift4OTN_Settings.MID#"
			Invoice="#InvoiceNum#"
			UniqueID="#UniqueID#"
			APIOptions="ALLDATA"
			Vendor="#Vendor#">
	</cfif>

</cfif>
