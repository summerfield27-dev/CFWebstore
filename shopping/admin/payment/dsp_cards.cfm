<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for editing the payment settings for the store. Called by shopping.admin&payment=cards --->

<!--- Get list of credit cards --->
<cfquery name="GetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#CreditCards
</cfquery>


<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
<cfoutput>
 function CancelForm () {
	location.href = '#self#?fuseaction=home.admin&inframes=yes&redirect=yes#request.token2#';
	}
</cfoutput>		
 function offlinealert() {
 
 alert('Please note that this setting is for merchants that do not wish to accept normal credit card orders. Any credit card settings in the Payment Manager will be ignored when this is selected.');
}
</script>
</cfprocessingdirective>


<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Payment Manager"
	Width="580"
	menutabs="yes">

	
	<cfinclude template="dsp_menu.cfm">
	
<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext" style="color:###Request.GetColors.InputTText#">

	<!--- Add form ---->
	<form name="editform" action="#self#?fuseaction=shopping.admin&payment=cards#request.token2#" method="post">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "paymentSettings">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
		<tr>	
			<td width="150" align="RIGHT" class="formtitle"><br/>Offline Orders&nbsp;</td>
			<td colspan="2"><br/><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/></td>
		</tr>
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">Offline Orders allow your customers to complete the check-out process without requiring a payment. Their receipt will include a message instructing them how to send payment and complete their order. If using purchase orders, they will also have the option to enter a purchase order number to complete their order. </div>
		</td></tr>
		
		<tr>
			<td align="RIGHT">Offline Orders:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="AllowOffline" value="1" #doChecked(get_Order_Settings.AllowOffline)# />Yes 
			&nbsp; <input type="radio" name="AllowOffline" value="0" #doChecked(get_Order_Settings.AllowOffline,0)# />No 
			</td>	
		</tr>
			
		<tr>
			<td align="RIGHT" valign="top">Offline Receipt Message: </td>
			<td></td>
			<td>
			<textarea cols="40" rows="5" name="OfflineMessage" class="formfield">#get_Order_Settings.OfflineMessage#</textarea>
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">Use Purchase Orders:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="AllowPO" value="1" #doChecked(get_Order_Settings.AllowPO)# />Yes 
			&nbsp; <input type="radio" name="AllowPO" value="0" #doChecked(get_Order_Settings.AllowPO,0)# />No 
			</td>	
		</tr>
			
		
		<tr>	
			<td align="RIGHT" class="formtitle"><br/>PayPal Orders&nbsp;</td>
			<td colspan="2"><br/><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/></td>
		</tr>
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">These settings allow your customer to checkout through PayPal using either Website Payments Standard or Express Checkout. You must have a PayPal account and PDT and/or IPN enabled in your PayPal merchant area. See the CFWebstore documentation for more information on setting  up your merchant account at PayPal.<br/><br/> NOTE: If using PayPal Pro, fill these settings in so your IPN transactions will work, but leave the 'Use PayPal' turned off and configure PayPal as a gateway below to use DirectPay. </div>
		</td></tr>
		
		<tr>
			<td align="RIGHT">Use PayPal: </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="UsePayPal" value="1" #doChecked(get_Order_Settings.UsePayPal)# />Yes 
			&nbsp; <input type="radio" name="UsePayPal" value="0" #doChecked(get_Order_Settings.UsePayPal,0)# />No 
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">PayPal Method: </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="PayPalMethod" value="Standard" #doChecked(get_Order_Settings.PayPalMethod,'Standard')# />Standard 
			&nbsp; <input type="radio" name="PayPalMethod" value="Express" #doChecked(get_Order_Settings.PayPalMethod,'Express')# />Express 
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">PayPal Server: </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="PayPalServer" value="sandbox" #doChecked(get_Order_Settings.PayPalServer,'sandbox')# />Sandbox 
			&nbsp; <input type="radio" name="PayPalServer" value="live" #doChecked(get_Order_Settings.PayPalServer,'live')# />Live 
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT" valign="baseline">PayPal Account:</td>
			<td></td>
			<td>
			<input type="text" name="PayPalEmail" class="formfield" value="#get_Order_Settings.PayPalEmail#" size="30" maxlength="100"/>
			</td>	
		</tr>		
			<tr><td colspan="2"></td><td class="formtextsmall">
			The email account listed here must be the primary email on the account used for IPN.
			</td></tr>
		
		<tr>
			<td align="RIGHT" valign="baseline">PDT Token:</td>
			<td></td>
			<td>
			<input type="text" name="PDT_Token" class="formfield" value="#get_Order_Settings.PDT_Token#" size="50" maxlength="100"/>
			</td>	
		</tr>		
			<tr><td colspan="2"></td><td class="formtextsmall">
			If you enable PDT, enter your authentication token assigned by PayPal here. Be sure to also enable automatic returns.
			</td></tr>

		
		<tr>
			<td align="RIGHT">Log Messages:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="radio" name="PayPalLog" value="1" #doChecked(get_Order_Settings.PayPalLog)# />Yes 
			&nbsp; <input type="radio" name="PayPalLog" value="0" #doChecked(get_Order_Settings.PayPalLog,0)# />No 
			</td>	
		</tr> 
		<tr>	
			<td align="RIGHT" class="formtitle"><br/>CC Orders&nbsp;</td>
			<td colspan="2"><br/><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/></td>
		</tr>
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">These settings allow your customer to checkout using a credit card. This requires the use of a payment gateway to process the credit card data, as per PCI Compliance regulations (see docs for more info). After selecting the gateway, be sure to configure your settings on the Card Processing tab as well.</div>
		</td></tr>
		
		<tr>
			<td align="RIGHT">Use Credit Cards: </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="OnlyOffline" value="0" #doChecked(get_Order_Settings.OnlyOffline,0)# />Yes 
			&nbsp; <input type="radio" name="OnlyOffline" value="1" #doChecked(get_Order_Settings.OnlyOffline)# />No 
			</td>	
		</tr>
				
		<tr>
			<td align="RIGHT">Use CRESecure: </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="UseCRESecure" value="1" #doChecked(get_Order_Settings.UseCRESecure)# />Yes 
			&nbsp; <input type="radio" name="UseCRESecure" value="0" #doChecked(get_Order_Settings.UseCRESecure,0)# />No 
			</td>	
		</tr>
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">CRE Secure is a service that works with your payment gateway and hosts the credit card payment page, while still using your store layout design. This allows you to fulfill all PCI and PA-DSS compliance requirements.</div>
		</td></tr>
		
		<tr>
			<td align="RIGHT">Online Processer </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="CCProcess" size="1" class="formfield">
			<option value="None" #doSelected(get_Order_Settings.CCProcess,'None')#>None (demo mode)</option>
			<option value="AuthorizeNet3" #doSelected(get_Order_Settings.CCProcess,'AuthorizeNet3')#>Authorize.Net</option>
			<!--- <option value="BankofAmerica" #doSelected(get_Order_Settings.CCProcess,'BankofAmerica')#>Bank of America eStore</option> --->
			<!---<option value="CyberSource" #doSelected(get_Order_Settings.CCProcess,'CyberSource')#>CyberSource</option>
	  	 	<option value="LinkPoint" #doSelected(get_Order_Settings.CCProcess,'LinkPoint')#>LinkPoint</option>--->
	  	 	<!---<option value="PayFlowPro" #doSelected(get_Order_Settings.CCProcess,'PayFlowPro')#>PayFlow Pro (CFX)</option>--->
			<option value="PayFlowPro4" #doSelected(get_Order_Settings.CCProcess,'PayFlowPro4')#>PayFlow Pro</option>
			<option value="PayPalPro" #doSelected(get_Order_Settings.CCProcess,'PayPalPro')#>PayPal Payments Pro</option>
			<option value="Shift4OTN" #doSelected(get_Order_Settings.CCProcess,'Shift4OTN')#>Shift4</option>
			<option value="Skipjack" #doSelected(get_Order_Settings.CCProcess,'Skipjack')#>Skipjack</option>
			<option value="SkyPay" #doSelected(get_Order_Settings.CCProcess,'SkyPay')#>SkyPay</option>
			<option value="USAepay" #doSelected(get_Order_Settings.CCProcess,'USAepay')#>USAepay</option>
			
			</select>
			</td>	
		</tr>				
			<cfif Request.DemoMode>
			<tr><td colspan="2"></td><td class="formtextsmall">
			Store is in demo mode, this selection cannot be modified.
		</td></tr>
			</cfif>
			
		<tr>
			<td align="RIGHT" valign="top">Cards Accepted</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="CreditCards" size="5" multiple="multiple" class="formfield">
			<cfloop query="GetCards">
			<option value="#ID#" #doSelected(GetCards.Used)#>#CardName#</option>
			</cfloop></select>
			</td>	
		</tr>

<!--- Use CVV2? ---->
		<tr>
			<td align="RIGHT">Use CVV2:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="usecvv2" value="1" #doChecked(get_Order_Settings.usecvv2)# />Yes 
			&nbsp; <input type="radio" name="usecvv2" value="0" #doChecked(get_Order_Settings.usecvv2,0)# />No 
			</td>	
		</tr>
			
<!--- save cc info in database? ---->
		<tr>
			<td align="RIGHT">Store Tokens?</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="storecardinfo" value="1" #doChecked(get_Order_Settings.storecardinfo)# />Yes 
			&nbsp; <input type="radio" name="storecardinfo" value="0" #doChecked(get_Order_Settings.storecardinfo,0)# />No 
			</td>	
		</tr>
		<tr><td colspan="3" class="formtextsmall">
<font color="FF0000"><div style="margin: 10px;">This setting is only available for processors that return tokens (currently Shift4 only) for use with recurring billing features.</div>
</td></tr>
		
<!--- Use billing tab feature --->
		<tr>
			<td align="RIGHT">Use Billing Tab:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="radio" name="UseBilling" value="1" #doChecked(get_Order_Settings.UseBilling)# />Yes 
			&nbsp; <input type="radio" name="UseBilling" value="0" #doChecked(get_Order_Settings.UseBilling,0)# />No 
			</td>	
		</tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
			The Billing Tab is used if you authorize when the order is placed and capture funds later, orders will be marked as not paid until captured.
		</td></tr>
		 
	
	<cfinclude template="../../../includes/form/put_space.cfm">
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="Submit_cards" value="Save" class="formbutton"/> 	
			 <input type="button" name="Cancel" value="Cancel" onclick="CancelForm();" class="formbutton"/>
			</td>	
		</tr>	
		
		<cfinclude template="../../../includes/form/put_requiredfields.cfm">
	</form>
	</table>
</cfoutput>
</cfmodule>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("editform");

objForm.required("CreditCards");

<cfif Request.DemoMode>
objForm.CCProcess.locked = true;
</cfif>

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
</script>
</cfprocessingdirective>
