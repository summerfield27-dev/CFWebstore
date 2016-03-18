<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to process a refund on the order. Change the order status, payment status, shipping status, add notes to the order, etc. Called from dsp_order.cfm --->
	
<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Order Refund"
	width="500"
	required_Fields="0"
	>
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&order=display&order_no=#attributes.order_no##request.token2#" method="post" name="refundform">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "orderRefund">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<tr><td colspan="3">A refund can only be sent for a transaction that has been captured AND settled. If you have recently captured the transaction you may have to wait a day until it settles before issuing a refund.<br/><br/></td></tr>
	
	<tr>
				<td align="RIGHT" nowrap="nowrap">Refund Amount:</td>
				<td style="background-color: <cfoutput>###Request.GetColors.formreq#</cfoutput>;" width="3">&nbsp;</td>
				<td>
				<input type="text" name="RefundAmount" value="" size="10" class="formfield" /> #Request.AppSettings.MoneyUnit#
				</td>
			</tr>
	
	<tr><td colspan="2"></td><td class="formtextsmall"><br/>
You can send an automated email to this customer to notify<br/> them that this order has been refunded. Be sure to edit the order <br/><em>first</em> to reflect the credits you will be applying. 
			</td></tr>
	
			<tr>
				<td align="RIGHT">Send Email:</td>
				<td style="background-color: <cfoutput>###Request.GetColors.formreq#</cfoutput>;" width="3">&nbsp;</td>
				<td>
				<input type="radio" name="EmailCustomer" value="1" checked="checked" />Yes &nbsp;
				<input type="radio" name="EmailCustomer" value="0"/>No 
				</td>
			</tr>

			
			<tr>
				<td align="RIGHT" valign="top">Additional Notes<br/>to Customer:</td>
				<td></td>
				<td>
				<textarea name="CustNotes" wrap="soft" cols="40" rows="5" class="formfield"></textarea>
				</td>
			</tr>

	<tr>
		<td colspan="5" align="center">
			<input type="submit" name="refund_submit" value="Submit Refund" class="formbutton"/>
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
		</td>
	</tr>
	</form>
</cfoutput>

</cfmodule>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("refundform");

objForm.required("RefundAmount,EmailCustomer");

objForm.RefundAmount.description = "refund amount";
objForm.RefundAmount.validateNumeric();

qFormAPI.errorColor = "###Request.GetColors.formreq#";
</script>
</cfprocessingdirective>


