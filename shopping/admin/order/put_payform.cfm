<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to edit the status of the order. Change the order status, payment status, shipping status, add notes to the order, etc. Called from dsp_order.cfm --->

<cfinclude template="../../../queries/qry_getpicklists.cfm">

<cfquery name="GetAffiliates" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT A.AffCode, U.Username
	FROM #Request.DB_Prefix#Affiliates A, #Request.DB_Prefix#Users U
	WHERE U.Affiliate_ID = A.Affiliate_ID
</cfquery>

<cfinclude template="../../../customtags/ckeditor_config.cfm">
	
<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Edit Order Status"
	width="500"
	required_Fields="0"
	>
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&order=display&order_no=#attributes.order_no##request.token2#" method="post">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "orderBasketUpdate">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<!--- --->
	<tr>
		<td width="10%">Paid:</td>
		<td width="40%"><input type="radio" name="paid" value="1" #doChecked(GetOrder.paid)# /> Yes 
		&nbsp;&nbsp;<input type="radio" name="paid" value="0" #doChecked(GetOrder.paid,0)# /> No</td>
		<td width="4%"></td>
		<td width="16%">Move To:</td>
		<td width="32%">
		<!--- determine current status --->
		<cfif getorder.status is "fraud" OR getorder.status is "cancelled">
			<cfset curr_status = getorder.status>
		<cfelseif NOT getorder.process>
			<cfset curr_status = "pending">
		<cfelseif NOT getorder.filled>
			<cfset curr_status = "process">
		<cfelse>
			<cfset curr_status = "filled">
		</cfif>
		
		<select name="moveto" class="formfield" size="1">
			<option value="pending" #doSelected(curr_status,'pending')#>pending</option>
			<option value="process" #doSelected(curr_status,'process')#>in process</option>
			<option value="fill" #doSelected(curr_status,'filled')#>filled</option>
			<option value="cancelled" #doSelected(curr_status,'cancelled')#>cancelled</option>
			<option value="fraud" #doSelected(curr_status,'fraud')#>fraud</option>
	 	</select>
		</td>
	</tr>

	
	<!--- --->
	<tr>
		<td>Affiliate:</td>
		<td><select name="affiliate"  class="formfield">
			<option value="" #doSelected(GetOrder.affiliate,'')#></option>
			<cfloop query="GetAffiliates">
				<option value="#affcode#" #doSelected(GetOrder.affiliate,affcode)#>#affcode# - #username#</option>
			</cfloop>
			</select>
			</td>
		<td></td>
		<td nowrap="nowrap">Shipping Status:</td>
		<td><select name="status"  class="formfield">
			<option value="" #doSelected(GetOrder.status,'')#></option>
			<cfmodule template="../../../customtags/form/dropdown.cfm"
			mode="valuelist"
			valuelist="#qry_getpicklists.shipping_status#"
			selected="#GetOrder.status#"
			/>
		</select></td>
	</tr>
	
	<!--- --->
	<tr>
		<td>Printed:</td>
		<td><input type="checkbox" name="printed" value="1" #doChecked(BitAnd(GetOrder.printed,1))# />invoice 
		&nbsp;<input type="checkbox" name="printed" value="2" #doChecked(BitAnd(GetOrder.printed,2))# >packlist</td>
		<td></td>
		<cfif GetOrder.Card_ID IS NOT 0>
		<td>Void CC:</td>
		<td><input type="radio" name="CCvoid" value="1"  /> Yes 
		&nbsp;&nbsp;<input type="radio" name="CCvoid" value="0" checked="checked" /> No
		<!--- <br/>Only orders that have not settled yet can be voided. --->
		</td>
		<cfelse>
		<td></td>
		<td></td>
		</cfif>
	</tr>
	
	
	<tr>
		<td colspan="5" align="center">
				<textarea id="notes" name="notes">#getOrder.notes#</textarea>
				<script type="text/javascript">
					CKEDITOR.replace( 'notes', { #ck_default# #ck_image#
					 #basic_tool#,
					 height: 200 } );
				</script>
			</td>
	</tr>
	
	<tr>
		<td colspan="5" align="center">
			<input type="submit" name="payform_submit" value="Update Order" class="formbutton"/>
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
		</td>
	</tr>
	</form>
</cfoutput>

</cfmodule>



