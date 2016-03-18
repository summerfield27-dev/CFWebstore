<!--- CFWebstore�, version 6.31 --->

<!--- Called from users.ccard circuit, displays form to allow the user to update their credit card information stored in their user record. Note that this credit card information is for informational purposes only and not used during checkout. --->

<cfparam name="attributes.message" default="">
<cfparam name="attributes.xfa_submit_ccard" default="fuseaction=users.ccard">

<cfinclude template="../qry_get_user.cfm">
	<cfloop list="CardType,NameOnCard,CardNumber,CardExpire,Cardzip" index="counter">
		<cfset attributes[counter] = qry_get_user[counter][1]>
	</cfloop>
	
<cfif Not isDate(attributes.cardexpire)>
	<cfset attributes.cardexpire = now()>
</cfif>

<cfparam name="attributes.month" default="#Month(attributes.cardexpire)#">
<cfparam name="attributes.year" default="#Year(attributes.cardexpire)#">
	
<cfinclude template="../../shopping/qry_get_order_settings.cfm">	
<cfinclude template="../qry_get_user_extended_settings.cfm">

<cfhtmlhead text="
 <script type=""text/javascript"">
 <!--
 function CancelForm() {
 location.href='#self#?fuseaction=users.manager&redirect=yes#request.token2#';
 }
 function DeleteForm() {
 location.href='#self#?fuseaction=users.deleteccard&redirect=yes#request.token2#';
 }
 // --> 
 </script>
">

<cfset variables.offsitePost=0>
<cfif get_Order_Settings.CCProcess IS "Shift4OTN">
	<cfinclude template="../../shopping/checkout/creditcards/shift4/qry_get_shift4otn_settings.cfm">
	<cfif get_Shift4OTN_Settings.i4GoURL NEQ "">
		<cfset variables.offsitePost=1>
		<cfset variables.offsitePostParams.URL="https://#get_Shift4OTN_Settings.i4GoURL#">
		<cfset variables.offsitePostParams.fuseAction="account.directPostCardEntry">
		<cfset variables.offsitePostParams.accountID=Val(get_Shift4OTN_Settings.i4GoAccountID)>
		<cfset variables.offsitePostParams.siteID=Val(get_Shift4OTN_Settings.i4GoSiteID)>
		<cfset variables.offsitePostParams.i4go_URL=XHTMLFormat("#request.Secureself#?#attributes.xfa_submit_ccard##Request.Token2#")&"&step=shift4_i4go">
		<cfset request.fieldMap=StructNew()>
		<cfset request.fieldMap.month="expirationMonth">
		<cfset request.fieldMap.year="expirationYear">
		<cfset request.fieldMap.cardZip="postalCode">
	</cfif>
</cfif>

<cfset variables.postURL=XHTMLFormat("#request.self#?#attributes.xfa_submit_ccard##Request.Token2#")>
<cfif variables.offsitePost>
	<cfset variables.postURL=variables.offsitePostParams.URL>
</cfif>

<!-- start users/manager/dsp_ccard_update.cfm -->
<div id="dspccardupdate" class="users">
<cfoutput>
	<form action="#variables.postURL#" method="post" name="editform" id="editform">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "ccardUpdate">
	<cfinclude template="../../includes/act_add_csrf_key.cfm">
	<cfif variables.offsitePost>
		<cfloop index="variables.fieldName" list="#StructKeyList(variables.offsitePostParams)#">
			<cfif variables.fieldName IS NOT "URL">
				<input name="#variables.fieldName#" type="hidden" value="#variables.offsitePostParams[variables.fieldName]#" />
			</cfif>
		</cfloop>
	</cfif>
</cfoutput>
	
<cfmodule template="../../customtags/format_input_form.cfm"
		box_title="Update Credit Card Information"
		width="400"
		>

	<cfinclude template="../../includes/form/put_message.cfm">

	<!--- Set type of cc form to use --->
	<cfset attributes.ccform="users">
	
	<cfinclude template="../../includes/form/put_space.cfm">
	<cfinclude template="../formfields/put_ccard.cfm">
	<cfinclude template="../../includes/form/put_space.cfm">
	
	<tr align="left">
    	<td></td><td></td>
		<td>
		<cfif get_User_Extended_Settings.UserCCardEdit><input type="submit" name="submit_ccard" value="Update" class="formbutton"/></cfif>
		<cfif get_User_Extended_Settings.UserCCardDelete><input type="button" name="Delete" value="Delete" onclick="DeleteForm();" class="formbutton"/></cfif>
		<input type="button" name="Cancel" value="Cancel" onclick="CancelForm();" class="formbutton"/></td>
	</tr>
</cfmodule>
</form>

<cfprocessingdirective suppresswhitespace="no">
<cfoutput>
	<script type="text/javascript">
		<!--
			objForm = new qForm("editform");
			
			objForm.required("#application.objGlobal.fieldName('nameoncard')#,#application.objGlobal.fieldName('CardType')#,#application.objGlobal.fieldName('CardNumber')#,#application.objGlobal.fieldName('CardZip')#");
			
			objForm.#application.objGlobal.fieldName("nameoncard")#.description = "name on card";
			objForm.#application.objGlobal.fieldName("CardType")#.description = "card type";
			objForm.#application.objGlobal.fieldName("CardNumber")#.description = "card number";
			objForm.#application.objGlobal.fieldName("CardZip")#.description = "billing address zip code";
			
			objForm.#application.objGlobal.fieldName("CardNumber")#.validateCreditCard();
			
			qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
		//-->
	</script>
</cfoutput>
</cfprocessingdirective>

</div>
<!-- end users/manager/dsp_ccard_update.cfm -->
