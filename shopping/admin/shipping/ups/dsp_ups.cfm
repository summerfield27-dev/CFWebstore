<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to update the UPS Settings for the store. Called by shopping.admin&shipping=ups --->

<cfinclude template="qry_ups_settings.cfm">
<cfset attributes.GetUPS = 1>
<cfinclude template="../../../../queries/qry_getcountries.cfm">

<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<script language=""JavaScript"">
		function CancelForm () {
		location.href = ""#self#?fuseaction=shopping.admin&shipping=editsettings&redirect=yes#request.token2#"";
		}
	</script>
">
</cfprocessingdirective>

<cfmodule template="../../../../customtags/format_admin_form.cfm"
	box_title="UPS Shipping Settings"
	width="450"
	>
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&shipping=ups#request.token2#"  method="post" name="ups">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "upsSettings">
	<cfinclude template="../../../../includes/act_add_csrf_key.cfm">

	<cfinclude template="../../../../includes/form/put_space.cfm">

		<tr>
			<td align="right" valign="top" width="35%">Maximum Package Weight:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="65%">
			<input type="text" name="MaxWeight" size="7" maxlength="15" value="#GetUPS.MaxWeight#" class="formfield"/>
			</td>	
		</tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
		Maximum weight for a package. Shipments will be split into equal-sized packages if over this amount.
		</td></tr>
		
		<tr>
			<td align="right" valign="top" width="35%">Units of Measurement:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<select name="UnitsofMeasure" size="1" class="formfield">
			<option value="LBS/IN" #doSelected(GetUPS.UnitsofMeasure,'LBS/IN')#>Pounds/Inches</option>
			<option value="KGS/CM" #doSelected(GetUPS.UnitsofMeasure,'KGS/CM')#>Kilograms/Centimeters</option>
			</select>
			</td>	
		</tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
		Should match the units in the Main Settings. See UPS manuals for the correct setting for your country.
		</td></tr>
		
		<tr>
			<td align="right" valign="top" width="35%">UPS Account Type:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<select name="Pickup" size="1" class="formfield">
			<cfloop query="GetUPSPickup">
			<option value="#UPS_Code#" #doSelected(GetUPS.PickUp,UPS_Code)#>#Description#</option>
			</cfloop>
			</select>
			</td>	
		</tr>
			
		<tr>
			<td align="right" valign="top" width="35%">Package Type:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<select name="Packaging" size="1" class="formfield">
			<cfloop query="GetUPSPackages">
			<option value="#UPS_Code#" #doSelected(GetUPS.Packaging,UPS_Code)#>#Description#</option>
			</cfloop>
			</select>
			</td>	
		</tr>
				
		<tr>
			<td align="right" valign="top" width="35%">Origin for Rates:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td width="65%">
			<select name="Origin" size="1" class="formfield">
			<cfloop query="GetUPSOrigins">
			<option value="#UPS_Code#" #doSelected(GetUPS.Origin,UPS_Code)#>#Description#</option>
			</cfloop>
			</select>
			</td>	
		</tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
		Should match the UPS shipping country.
		</td></tr>
		
		<tr>
			<td align="right" valign="top">Use Address Verification:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="radio" name="UseAV" value="1" #doChecked(GetUPS.UseAV)# />Yes 
			&nbsp;<input type="radio" name="UseAV" value="0" #doChecked(GetUPS.UseAV,0)# />No</td>	
		</tr>	
			<tr><td colspan="2"></td><td class="formtextsmall">
		Available for US merchants only.
		</td></tr>
		
		<tr>
			<td align="right" valign="top">Log Transactions:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="radio" name="Logging" value="1" #doChecked(GetUPS.Logging)# />On 
			&nbsp;<input type="radio" name="Logging" value="0" #doChecked(GetUPS.Logging,0)# />Off</td>	
		</tr>	
		
		<tr>
			<td align="right" valign="top">Debug:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="radio" name="Debug" value="1" #doChecked(GetUPS.Debug)# />On 
			&nbsp;<input type="radio" name="Debug" value="0" #doChecked(GetUPS.Debug,0)# />Off</td>	
		</tr>	

		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="submit_ups" value="Save" class="formbutton"/> 
			<input type="button" value="Cancel" onclick="javascript:CancelForm();" class="formbutton"/>
			</td>	
		</tr>	
	</form>
	
</cfoutput>	
</cfmodule>


<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("ups");

objForm.required("MaxWeight,Pickup,Packaging,UseAV,Logging,Debug");

objForm.MaxWeight.validateNumeric();
objForm.MaxWeight.validateExp("parseInt(this.value) < 1");

objForm.MaxWeight.description = "maximum weight";
objForm.UseAV.description = "address verification";

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
</script>
</cfprocessingdirective>