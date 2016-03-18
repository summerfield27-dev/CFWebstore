<!--- CFWebstore, version 6.50 --->

<!--- Settings for CyberSource processing. Called from dsp_process.cfm --->

<tr><td colspan="3" align="center" class="formtitle">CyberSource Payment Processing<br/><br/></td></tr>
<cfoutput>
	<tr>
		<td align="RIGHT">User Account </td>
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
		<td align="RIGHT">Host Address </td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td>
			<input type="text" name="CCServer" value="#attributes.CCServer#" size="50" maxlength="150" class="formfield"/>
		</td>	
	</tr>
</cfoutput>
