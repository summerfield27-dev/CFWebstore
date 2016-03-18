<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for editing the payment processor settings. Includes the dsp_ page for the specific processor currently selected. Called by shopping.admin&payment=process --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfloop list="#GetSettings.ColumnList#" index="counter">
	<cfset attributes[counter] = GetSettings[counter][1]>
</cfloop>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
function CancelForm () {
	<cfoutput>location.href = "#self#?fuseaction=shopping.admin&payment=cards&redirect=yes#request.token2#";</cfoutput>
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
	<form name="editform" action="#self#?fuseaction=shopping.admin&payment=process#request.token2#" method="post">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "gatewaySettings">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	</cfoutput>
	

	<cfif get_Order_Settings.CCProcess IS "None" OR get_Order_Settings.onlyoffline is "1">
		<tr>
			<td colspan="3"align="center" class="formtitle"><p><br/>
			Credit card processing is turned off.</p>
		</td></tr>
		
		<tr><td colspan="3" align="center">
			<br/><input type="button" name="Cancel" value="Back to Payment Settings" onclick=CancelForm(); class="formbutton"/><br/><br/>
		</td></tr>
		
	<cfelseif get_Order_Settings.CCProcess IS "PayFlowPro4">
		<input type="hidden" name="Action" value="PayFlowPro4"/>
		<cfinclude template="gateways/dsp_payflowpro4.cfm">

	<cfelseif get_Order_Settings.CCProcess IS "AuthorizeNet3">
		<input type="hidden" name="Action" value="AuthorizeNet"/>
		<cfinclude template="gateways/dsp_authnetset.cfm">

	<cfelseif get_Order_Settings.CCProcess IS "LinkPoint">
		<input type="hidden" name="Action" value="LinkPoint"/>
		<cfinclude template="gateways/dsp_linkpointset.cfm">
		
	<!--- mjs 06-26-2008 Add new payment processor --->
	<cfelseif get_Order_Settings.CCProcess IS "NetworkMerch">
		<input type="hidden" name="Action" value="NetworkMerch"/>
		<cfinclude template="gateways/dsp_networkmerchset.cfm">

	<cfelseif get_Order_Settings.CCProcess IS "EZIC">
		<input type="hidden" name="Action" value="EZIC"/>
		<cfinclude template="gateways/dsp_ezicset.cfm">
		
	<cfelseif get_Order_Settings.CCProcess IS "Skipjack">
		<input type="hidden" name="Action" value="Skipjack"/>
		<cfinclude template="gateways/dsp_skipset.cfm">

	<cfelseif get_Order_Settings.CCProcess IS "PayPalPro">
		<input type="hidden" name="Action" value="PayPalPro"/>
		<cfinclude template="gateways/dsp_paypalproset.cfm">
		
	<cfelseif get_Order_Settings.CCProcess IS "Shift4OTN">
		<input type="hidden" name="Action" value="Shift4OTN"/>
		<cfinclude template="gateways/dsp_shift4otn.cfm">	

	<cfelseif get_Order_Settings.CCProcess IS "SkyPay">
		<input type="hidden" name="Action" value="SkyPay"/>
		<cfinclude template="gateways/dsp_skypayset.cfm">	
		
<!--- 	<cfelseif get_Order_Settings.CCProcess IS "BankofAmerica">
		<input type="hidden" name="Action" value="BankofAmerica"/>
		<cfinclude template="dsp_bankofamericaset.cfm">		 --->
			
	<cfelseif get_Order_Settings.CCProcess IS "USAepay">
		<input type="hidden" name="Action" value="USAepay"/>
		<cfinclude template="gateways/dsp_usaepayset.cfm">
		
	<cfelseif get_Order_Settings.CCProcess IS "CyberSource">
		<input type="hidden" name="Action" value="CyberSource"/>
		<cfinclude template="gateways/dsp_cybersourceset.cfm">			
					
	</cfif>

	
	<cfif get_Order_Settings.CCProcess IS NOT "None" and get_Order_Settings.onlyoffline is not "1">
		<cfinclude template="../../../includes/form/put_space.cfm">
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="Submit_process" value="Save" class="formbutton"/> 			
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
			</td>	
		</tr>	
		
		<cfinclude template="../../../includes/form/put_requiredfields.cfm">
	</form>
	</cfif>
	
	</table>

</cfmodule>





