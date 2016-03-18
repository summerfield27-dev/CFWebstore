<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for editing the payment processor settings. Includes the dsp_ page for the specific processor currently selected. Called by shopping.admin&payment=process --->

<cfquery name="GetExpressSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#CCProcess
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="PayPalExpress">
</cfquery>

<cfloop list="#GetExpressSettings.ColumnList#" index="counter">
	<cfset attributes[counter] = GetExpressSettings[counter][1]>
</cfloop>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
function CancelForm () {
	<cfoutput>location.href = "#self#?fuseaction=shopping.admin&payment=paypal&redirect=yes#request.token2#";</cfoutput>
	}
</script>
</cfprocessingdirective>

<cfmodule template="../../../../customtags/format_output_admin.cfm"
	box_title="Payment Manager"
	Width="580"
	menutabs="yes">
	
	<cfinclude template="../dsp_menu.cfm">
	
<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext" style="color:###Request.GetColors.InputTText#">

	<!--- Add form ---->
	<form name="editform" action="#self#?fuseaction=shopping.admin&payment=paypal#request.token2#" method="post">
	<cfset keyname = "paypalSettings">
	<cfinclude template="../../../../includes/act_add_csrf_key.cfm">
	
		<tr><td colspan="3" align="center" class="formtitle">PayPal Express Checkout Settings<br/><br/></td></tr>
		
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">These settings are used to configure PayPal Express if you want to use it as an additional checkout method. If you are using PayPalPro, your settings under the Gateway Settings are used to configure Express as well.</div>
		</td></tr>

		<tr>
			<td align="RIGHT">Username </td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td>
			<input type="text" name="Username" value="#attributes.Username#" size="50" maxlength="75" class="formfield"/>
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">Password </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="Password" name="Password" autocomplete="off" value="#attributes.Password#" size="50" maxlength="75" class="formfield"/>
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">Signature </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="text" name="Setting1" value="#attributes.Setting1#" size="50" maxlength="75" class="formfield"/>
			</td>	
		</tr>
	
		
		<tr>
			<td align="RIGHT">Transaction Type </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="Transtype" size="1" class="formfield">
			<option value="Sale" #doSelected(attributes.Transtype,'Sale')#>Sale</option>
	   		<option value="Authorization" #doSelected(attributes.Transtype,'Authorization')#>Authorization</option>
			</select>
			</td>	
		</tr>

		<cfinclude template="../../../../includes/form/put_space.cfm">
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="Submit_paypal" value="Save" class="formbutton"/> 			
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
			</td>	
		</tr>	
		
		<cfinclude template="../../../../includes/form/put_requiredfields.cfm">
	</form>
	
	</table>
	</cfoutput>

</cfmodule>





