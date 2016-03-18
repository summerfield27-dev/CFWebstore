<!--- CFWebstore, version 6.50 --->

<!--- Displays the Payment Summary Report. Called by dsp_reports.cfm --->


<cfoutput>
	<tr>
		<td colspan="2" align="CENTER">
			<strong>PAYMENT DETAIL (by Invoice) - #LSDateFormat(StartDate, "mmm d, yyyy")# - #LSDateFormat(ToDate, "mmm d, yyyy")#</strong><br/>&nbsp;
		</td>
	</tr>

	<cfif qPayments.RecordCount EQ 0>
		<tr><td align="center">No payments found for this date range.</td></tr>
	<cfelse>
		<tr>
			<td align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="5" bgcolor="###Request.GetColors.OutputTbgcolor#" align="center" class="formtext" style="color:###Request.GetColors.OutputTText#"> 
					<tr>
						<td><strong>Invoice</strong></td>
						<td><strong>Order</strong></td>
						<td><strong>Payment Type</strong></td>
						<td><strong>Card Number</strong></td>
						<td><strong>Name on Card</strong></td>
						<td align="right"><strong>Amount</strong></td>
					</tr>
					<cfset did=0>
					<cfset variables.count=0>
					<cfset variables.amount=0>
					<cfloop query="qPayments">
						<cfset did=did+1>
						<tr<cfif did MOD 2 EQ 1> bgcolor="###Request.GetColors.outputtaltcolor#"</cfif>>
							<td>#InvoiceNum#</td>
							<td>#(Order_No + Get_Order_Settings.BaseOrderNum)#</td>
							<td>#CardType#</td>
							<td>#CardNumber#</td>
							<td>#NameOnCard#</td>
							<td align="right">#LSCurrencyFormat(Amount)#</td>
						</tr>
					</cfloop>
				</table>
				<br />
				<br />
			</td>
		</tr>
	</cfif>
</cfoutput>

<cfinclude template="qry_report11.cfm">
<cfinclude template="dsp_report11.cfm">
