<!--- CFWebstore, version 6.50 --->

<!--- Processes batch billing from Order Manager.
	Attributes.ACT = 	paid	- mark as paid only (for offline orders)
						charge  - bill credit card then mark as paid
---->

<!--- Called by shopping.admin&order=billing and index.cfm --->

<!--- CSRF Check --->
<cfif attributes.act IS "paid" OR attributes.act IS "charge">
	<cfset keyname = "orderBilling">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
</cfif>

<cfparam name="attributes.orderlist" default="">

<!--- If the charge button on the order detail is pressed, set the order list to be the order number --->
<cfparam name="attributes.order_no" default="">
<cfif not len(attributes.orderlist) and len(attributes.order_no)>
	<cfset attributes.orderlist = attributes.order_no>
	<cfset returnOrderNo = attributes.order_no>
<cfelse>
	<cfset returnOrderNo = ''>
</cfif>

<cfswitch expression="#attributes.act#">

	<cfcase value="paid">
	
		<cfloop index="attributes.order_no" list="#attributes.orderlist#">
		
			<cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				SET Paid = 1,
				Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
				Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
			</cfquery>
		
		</cfloop>
	</cfcase>

	<cfcase value="charge">
	
		<cfloop index="attributes.order_no" list="#attributes.orderlist#">
		
			<cfif get_Order_Settings.CCProcess IS "AuthorizeNet3">
				<cfinclude template="../../checkout/creditcards/authorizenet/act_authnet3_delayedcapture.cfm">
	
			<cfelseif get_Order_Settings.CCProcess IS "PayFlowPro">
				<cfinclude template="../../checkout/creditcards/payflowpro/act_payflowpro_delayedcapture.cfm">
				
			<cfelseif get_Order_Settings.CCProcess IS "PayFlowPro4">
				<cfinclude template="../../checkout/creditcards/payflowpro/act_payflowpro4_delayedcapture.cfm">

			<cfelseif get_Order_Settings.CCProcess IS "Shift4OTN">
				<cfinclude template="../../checkout/creditcards/shift4/act_shift4otn_delayedcapture.cfm">
			
			<cfelseif get_Order_Settings.CCProcess IS "BankofAmerica">
				<cfinclude template="../../checkout/creditcards/boa/act_bankofamerica_delayedcapture.cfm">
	
			<cfelseif get_Order_Settings.CCProcess IS "LinkPoint">
				<cfinclude template="../../checkout/creditcards/linkpoint/act_linkpoint_delayedcapture.cfm">
				
			<cfelseif get_Order_Settings.CCProcess IS "PayPalPro">
				<cfinclude template="../../checkout/paypal/act_paypal_delayedcapture.cfm">
	<!--- 	
			<cfelseif get_Order_Settings.CCProcess IS "EZIC">
				<cfinclude template="../../checkout/creditcards/ezic/act_ezic_delayedcapture.cfm">
				
			<cfelseif get_Order_Settings.CCProcess IS "Skipjack">
				<cfinclude template="../../checkout/creditcards/skipjack/act_skipjack_delayedcapture.cfm"> --->
	
			<cfelse>
				
				<!--- Do Nothing --->
				
			</cfif>

		</cfloop>
		
	</cfcase>
	
</cfswitch>

<cfset attributes.order_no = returnOrderNo>

