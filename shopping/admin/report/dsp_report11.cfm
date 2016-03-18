<!--- CFWebstore, version 6.50 --->

<!--- Displays the Payment Summary Report. Called by dsp_reports.cfm --->


<cfoutput>
	<tr>
		<td colspan="2" align="CENTER">
			<strong>PAYMENT SUMMARY - #LSDateFormat(StartDate, "mmm d, yyyy")# - #LSDateFormat(ToDate, "mmm d, yyyy")#</strong><br/>&nbsp;
		</td>
	</tr>

	<cfif qPaymentTotals.RecordCount EQ 0>
		<tr><td align="center">No orders found for this date range.</td></tr>
	<cfelse>
		<tr>
			<td align="center">
				<table width="300" border="0" cellspacing="0" cellpadding="5" bgcolor="###Request.GetColors.OutputTbgcolor#" align="center" class="formtext" style="color:###Request.GetColors.OutputTText#"> 
					<tr>
						<td><strong>Payment Type</strong></td>
						<td align="right"><strong>Count</strong></td>
						<td align="right"><strong>Total Sales</strong></td>
					</tr>
					<cfset did=0>
					<cfset variables.count=0>
					<cfset variables.amount=0>
					<cfloop query="qPaymentTotals">
						<cfset did=did+1>
						<tr<cfif did MOD 2 EQ 1> bgcolor="###Request.GetColors.outputtaltcolor#"</cfif>>
							<td>#CardType#</td>
							<td align="right">#Count#</td>
							<td align="right">#LSCurrencyFormat(Amount)#</td>
						</tr>
						<cfset variables.count=variables.count+Count>
						<cfset variables.amount=variables.amount+Amount>
					</cfloop>
					<cfset did=did+1>
					<tr<cfif did MOD 2 EQ 1> bgcolor="###Request.GetColors.outputtaltcolor#"</cfif>>
						<td style="border-top: ###Request.GetColors.OutputTText# thin solid;">Totals</td>
						<td align="right" style="border-top: black thin solid;">#variables.count#</td>
						<td align="right" style="border-top: black thin solid;">#LSCurrencyFormat(variables.amount)#</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
</cfoutput>
