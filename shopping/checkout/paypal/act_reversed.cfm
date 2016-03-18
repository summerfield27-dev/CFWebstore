
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to set the message for reversed or refunded orders. Called from act_ipn_process.cfm --->

<cfparam name="RefundReason" default="">

<cfswitch expression="#RefundReason#">

	<cfcase value="chargeback">
		<cfset Reason = "a reversal has occurred on this transaction due to a chargeback by your customer.">
	</cfcase>
	
	<cfcase value="guarantee">
		<cfset Reason = "a reversal has occurred on this transaction due to your customer triggering a money-back guarantee.">
	</cfcase>

	<cfcase value="buyer-complaint">
		<cfset Reason = "a reversal has occurred on this transaction due to a complaint about the transaction from your customer.">
	</cfcase>
	
	<cfcase value="refund">
		<cfset Reason = "a reversal has occurred on this transaction because you have given the customer a refund.">
	</cfcase>
	
	<cfcase value="other">
		<cfset Reason = "a reversal has occurred on this transaction due to a reason not listed.">
	</cfcase>
	
	<cfdefaultcase>
		<cfset Reason = "">
	</cfdefaultcase>


</cfswitch>
