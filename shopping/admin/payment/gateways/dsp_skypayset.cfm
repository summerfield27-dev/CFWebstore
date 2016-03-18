<!--- CFWebstore, version 6.50 --->

<!--- Settings for SkyPay gateway. Called from dsp_process.cfm --->

<!--- SkyPay settings:
		MerchantNo (Skypay Merchant ID) =  Username
		Dispatch (NOW or LATER) = Transtype 
		AVSCV2Check (YES or NO) = Setting1. CV2 is passed if provided
 --->
 
<!--- Radio button defaults --->
<cfset attributes.Setting1 = iif(attributes.Setting1 IS 'YES',Evaluate(DE('attributes.Setting1')),DE('NO'))>
<cfset attributes.Transtype = iif(attributes.Transtype IS 'NOW',Evaluate(DE('attributes.Transtype')),DE('LATER'))>

		<tr><td colspan="3" align="center" class="formtitle">SkyPay Payment Processing<br/><br/></td></tr>

<cfoutput>
		<tr>
			<td align="RIGHT" width="35%">SkyPay Merchant ID </td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="65%">
			<input type="text" name="Username" value="#attributes.Username#" class="formfield" size="50" maxlength="75"/>
			</td>	
		</tr>
		
		<tr>
			<td align="RIGHT" width="35%">Dispatch </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<input type="radio" name="Transtype" value="NOW" #doChecked(attributes.Transtype,'NOW')# /> Now &nbsp;
			<input type="radio" name="Transtype" value="LATER" #doChecked(attributes.Transtype,'LATER')# /> Later (delayed processing)</td>	
		</tr>

		<tr>
			<td align="RIGHT" width="35%">AVS CV2 Check </td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<input type="radio" name="Setting1" value="YES" #doChecked(attributes.Setting1,'YES')# /> Yes &nbsp;
			<input type="radio" name="Setting1" value="NO" #doChecked(attributes.Setting1,'NO')# /> No</td>	
		</tr>
		
</cfoutput>



