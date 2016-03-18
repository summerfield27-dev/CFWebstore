<!--- CFWebstore, version 6.50 --->

<!--- Inserts credit card form fields. Called during checkout from either the shopping\checkout\dsp_payment_options.cfm or shopping\checkout\dsp_pay_form.cfm template. Also used during user registration on the users\dsp_account_form.cfm, users\dsp_member_form.cfm and the users\manager\dsp_ccard_update.cfm form. ---->

<cfparam name="attributes.ccform" default="checkout">

<cfinclude template="../../shopping/checkout/creditcards/qry_get_cards.cfm">

<!--- <cfinclude template="../../includes/imagepreview.js"> --->

<!--- see if "Gift Cards" are a valid payment method, for Shift4 --->
<cfquery name="qGetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT CardName FROM #Request.DB_Prefix#CreditCards
	WHERE Used = 1 AND CardName LIKE 'Gift%'
</cfquery>
<cfset GCEnabled=qGetCards.RecordCount GT 0>

<!-- start users/formfields/put_ccard.cfm -->
<cfoutput>
	<cfif GCEnabled and attributes.ccform IS "checkout">
		<tr align="left">
			<td colspan="3">
				<strong>IMPORTANT NOTE:</strong> If you are using one or more gift cards or gift certificates as a form of payment, you must enter them first.<br/><br/>
			</td>
		</tr>
	</cfif>
	<tr align="left">
		<td align="right" nowrap="nowrap">Name on Card:</td>
		<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
		<td><input type="text" name="#application.objGlobal.fieldName('nameoncard')#" value="#HTMLEditFormat(attributes.nameoncard)#" size="30" maxlength="150"  class="formfield"/></td></tr>
	<tr align="left">
		<td align="right" nowrap="nowrap">Card Type: </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><select name="#application.objGlobal.fieldName('CardType')#" size="1" 
			class="formfield">
		<cfloop query="GetCards">
   			<option value="#GetCards.CardName#" #doSelected(attributes.CardType,GetCards.CardName)#>#GetCards.CardName#</option>
 			</cfloop>   
   			</select></td></tr>
	<tr align="left">  
		<td align="right" nowrap="nowrap">Card Number: </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><input type="text" name="#application.objGlobal.fieldName('CardNumber')#" size="25" maxlength="16" value="#HTMLEditFormat(attributes.CardNumber)#" class="formfield"/><br/>
		<span class="formtextsmall">(no spaces or dashes)</span>
		</td></tr>
		
	<cfif get_Order_Settings.usecvv2 AND attributes.ccform IS "checkout">
	<tr align="left">  
		<td align="right" nowrap="nowrap">Card Check Code: </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td ><input type="text" name="#application.objGlobal.fieldName('CVV2')#" size="4" maxlength="8" value="" class="formfield"/> 
		<!----
		<a href="#self#?fuseaction=page.cvv2help" target="_new"><img src="#Request.ImagePath#icons/cvv.jpg" border="0" width="51" height="31" alt="" /></a> --->
		(<a href="#self#?fuseaction=page.cvv2help" target="_new">what is this?</a>)
		</td></tr>
	<cfelseif attributes.ccform IS NOT "checkout">
		<tr>  
		<td align="right" nowrap="nowrap">Billing Zip Code: </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><input type="text" name="#application.objGlobal.fieldName('CardZip')#" size="10" maxlength="20" value="#HTMLEditFormat(attributes.CardZip)#" class="formfield"/>
		</td></tr>
	
	</cfif>
		
	<tr align="left">
		<td align="right">Expires: </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td>
		<select name="#application.objGlobal.fieldName('Month')#" size="1" class="formfield">
		<cfloop index="i" from="1" to="12">
		<option value="#iif(i GTE 10, i,NumberFormat(i, '09'))#" #doSelected(attributes.Month,i)#>#MonthAsString(i)#</option>
		</cfloop>
		</select>
		<select name="#application.objGlobal.fieldName('Year')#" size="1" class="formfield">
		<cfloop index="i" from="#Year(Now())#" to="#(Year(Now()) + 12)#">
		<option value="#i#" #doSelected(attributes.Year,i)#>#i#</option>
		</cfloop></select></td></tr>
</cfoutput>
<!-- end users/formfields/put_ccard.cfm -->

