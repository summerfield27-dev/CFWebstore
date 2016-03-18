<!--- CFWebstore, version 6.50 --->

<!--- Settings for Authorize.Net gateway. Called from dsp_process.cfm --->

		<tr><td colspan="3" align="center" class="formtitle">Authorize.Net v.3 Payment Processing<br/><br/></td></tr>

<cfoutput>
		<tr>
			<td align="RIGHT" width="35%">Username </td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="65%">
			<input type="text" name="Username" value="#attributes.Username#" size="50" maxlength="50" class="formfield"/>
			</td>	
		</tr>		
		
		<tr>
			<td align="RIGHT">Transaction Type </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<select name="Transtype" size="1" class="formfield">
				<option value="sale" #doSelected(attributes.Transtype,'sale')#>Sale (Immediate capture)</option>
	   			<option value="auth" #doSelected(attributes.Transtype,'auth')#>Auth (Authorization Only)</option></select>
			</td>	
		</tr>
</cfoutput>


