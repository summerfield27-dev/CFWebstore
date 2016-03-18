<!--- CFWebstore, version 6.50 --->

<!--- Settings for CRE Hosted Payments. Called from dsp_process.cfm --->

<cfquery name="GetCRESettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#CCProcess
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="CRESecure">
</cfquery>

<cfloop list="#GetCRESettings.ColumnList#" index="counter">
	<cfset attributes[counter] = GetCRESettings[counter][1]>
</cfloop>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
function CancelForm () {
	<cfoutput>location.href = "#self#?fuseaction=shopping.admin&payment=cresecure&redirect=yes#request.token2#";</cfoutput>
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
	<form name="editform" action="#self#?fuseaction=shopping.admin&payment=cresecure#request.token2#" method="post">
	<cfset keyname = "creSettings">
	<cfinclude template="../../../../includes/act_add_csrf_key.cfm">
	
		<tr><td colspan="3" align="center" class="formtitle">CRE Secure API Settings<br/><br/></td></tr>
		
		<tr><td colspan="3" class="formtextsmall"><div style="margin: 10px;">These settings are used to configure the CRE Secure API to use their hosted payment page for your credit card payments.</div>
		</td></tr>

		<tr>
			<td align="RIGHT">CRE Secure ID </td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td>
			<input type="text" name="Username" value="#attributes.Username#" size="40" maxlength="50" class="formfield"/>
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT">API Token Key  </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="Password" name="Password" value="#attributes.Password#" size="40" maxlength="75" class="formfield"/>
			</td>	
		</tr>
		
		<!--- <tr>
			<td align="RIGHT">Hosted Payment Method </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="Transtype" size="1" class="formfield">
				<option value="page" #doSelected(attributes.Transtype,'page')#>Payment Page</option>
	   			<option value="form" #doSelected(attributes.Transtype,'form')#>Payment Form</option></select>
			</td>	
		</tr> --->
		
		<tr>
			<td align="RIGHT">Server </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="CCServer" size="1" class="formfield">
			<option value="LIVE" #doSelected(attributes.CCServer,'LIVE')#>Live</option>
	   		<option value="TEST" #doSelected(attributes.CCServer,'TEST')#>Sandbox</option>
			</select>
			</td>	
		</tr>



		<cfinclude template="../../../../includes/form/put_space.cfm">
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="submit_cresecure" value="Save" class="formbutton"/> 			
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
			</td>	
		</tr>	
		
		<cfinclude template="../../../../includes/form/put_requiredfields.cfm">
	</form>
	
	</table>
	</cfoutput>

</cfmodule>




