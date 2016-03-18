<!--- CFWebstore, version 6.50 --->

<!--- Used when there is a problem with the credit card information, displays the error and prompts for the information to be entered again. Called by shopping.checkout (step=payment) --->

<cfquery name="GetCustomer" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT FirstName, LastName 
	FROM #Request.DB_Prefix#TempCustomer 
	WHERE TempCust_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<cfparam name="errormessage" default="">
<cfparam name="attributes.CardType" default="">
<cfparam name="attributes.NameonCard" default="#GetCustomer.FirstName# #GetCustomer.LastName#">
<cfparam name="attributes.CardNumber" default="">
<cfparam name="attributes.Month" default="">
<cfparam name="attributes.Year" default="">
<cfset variables.offsitePost=0>

<cfquery name="GetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT CardName FROM #Request.DB_Prefix#CreditCards
	WHERE USED = 1
</cfquery>

<!-- start shopping/checkout/dsp_pay_form.cfm -->
<div id="dsppayform" class="shopping">
	
<cfif get_Order_Settings.CCProcess IS "Shift4OTN">
	<cfinclude template="creditcards/shift4/qry_get_shift4otn_settings.cfm">
	<cfif get_Shift4OTN_Settings.i4GoURL NEQ "">
		<cfset variables.offsitePost=1>
		<cfset variables.offsitePostParams.URL="https://#get_Shift4OTN_Settings.i4GoURL#">
		<cfset variables.offsitePostParams.fuseAction="account.directPostCardEntry">
		<cfset variables.offsitePostParams.accountID=Val(get_Shift4OTN_Settings.i4GoAccountID)>
		<cfset variables.offsitePostParams.siteID=Val(get_Shift4OTN_Settings.i4GoSiteID)>
		<cfset variables.offsitePostParams.i4go_URL=XHTMLFormat("#request.Secureself#?fuseaction=shopping.checkout&step=shift4_i4go#request.token2#")>
		<cfset request.fieldMap=StructNew()>
		<cfset request.fieldMap.month="expirationMonth">
		<cfset request.fieldMap.year="expirationYear">
	</cfif>
</cfif>

<cfoutput>
	<cfset variables.postURL=XHTMLFormat("#self#?fuseaction=shopping.checkout&step=payment#request.token2#")>
	<cfif variables.offsitePost>
		<cfset variables.postURL=variables.offsitePostParams.URL>
	</cfif>
	<form action="#variables.postURL#" method="post" name="editform" id="editform">
		<cfif variables.offsitePost>
			<cfloop index="variables.fieldName" list="#StructKeyList(variables.offsitePostParams)#">
				<cfif variables.fieldName IS NOT "URL">
					<input name="#variables.fieldName#" type="hidden" value="#variables.offsitePostParams[variables.fieldName]#" />
				</cfif>
			</cfloop>
		<cfelse>
			<input type="hidden" name="step" value="shipto"/>
		</cfif>
</cfoutput>

<cfmodule template="../../customtags/format_input_form.cfm"
box_title="Payment by Credit Card"
width="380"
>
	<cfif len(ErrorMessage)>
	<tr>
		<td colspan="3" align="center" class="formerror"><br/><cfoutput>#ErrorMessage#</cfoutput><br/><br/></td></tr>
	</cfif>		

	<cfinclude template="../../users/formfields/put_ccard.cfm">		

<cfoutput>
	<tr><td colspan="3">
	<img src="#Request.ImagePath#spacer.gif" alt="" height="3" width="1" /></td></tr></cfoutput>

	<tr>
	<td colspan="2"></td>
	<td><input type="submit" name="SubmitPayment" value="Complete Order" class="formbutton"/>
		<input type="submit" name="CancelForm" value="Cancel" class="formbutton" onclick="noValidation();"/>
		</td></tr>

</cfmodule>

</form>

<cfprocessingdirective suppresswhitespace="no">
	<cfoutput>
		<script type="text/javascript">
			<!--//
				// initialize the qForm object
				objForm = new qForm("editform");
				
				// make these fields required
				objForm.required("#application.objGlobal.fieldName('nameoncard')#,#application.objGlobal.fieldName('CardNumber')#<cfif get_Order_Settings.usecvv2>,#application.objGlobal.fieldName('CVV2')#</cfif>");
				
				objForm.#application.objGlobal.fieldName('nameoncard')#.description = "name on card";
				objForm.#application.objGlobal.fieldName('CardNumber')#.description = "card number";
				<cfif get_Order_Settings.usecvv2>objForm.#application.objGlobal.fieldName('CVV2')#.description = "cvv2";</cfif>
				
				objForm.#application.objGlobal.fieldName('CardNumber')#.validateCreditCard();
				<cfif get_Order_Settings.usecvv2>objForm.#application.objGlobal.fieldName('CVV2')#.validateNumeric();</cfif>
				
				qFormAPI.errorColor = "###Request.GetColors.formreq#";
				
				function noValidation() {
					objForm._skipValidation = true;
				}
			//-->
		</script>
	</cfoutput>
</cfprocessingdirective>

</div>
<!-- end shopping/checkout/dsp_pay_form.cfm -->
