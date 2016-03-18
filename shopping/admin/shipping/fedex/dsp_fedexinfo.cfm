<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for entering Fedex registration info. Called by shopping.admin&shipping=fedexinfo --->

<cfinclude template="qry_fedex_settings.cfm">
<cfinclude template="../../../../queries/qry_getstates.cfm">
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
	box_title="Fedex&reg; Web Services Registration"
	width="500"
	required_Fields="0"
	>	
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&shipping=fedexinfo#request.token2#" method="post" name="fedex">

	<cfinclude template="../../../../includes/form/put_space.cfm">
	<cfset keyname = "fedexInfo">
	<cfinclude template="../../../../includes/act_add_csrf_key.cfm">
		<tr>
			<td align="center" valign="top" width="100"><img src="#Request.ImagePath#icons/fedex_sm.gif" alt="" border="0" /></td>

		<td>
		<table class="formtext" width="100%" cellspacing="3">
		<tr><td colspan="3">To use the integrated Fedex rates and tracking, you will need to register for Fedex Web Services, and then enter your account information:<br/><br/></td></tr>
		
		<tr align="left">
			<td colspan="2" class="formtitle" nowrap="nowrap">
			Account Registration 
			</td>
			<td align="right" class="formtextsmall">
		</tr>
		<tr><td align="right">FedEx Account Number:</td>
			<td  style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" size="20" name="AccountNo" value="#GetFedEx.AccountNo#" class="formfield" maxlength="20"/></td></tr>
			<tr><td colspan="2"></td><td class="formtextsmall">
			(No spaces or dashes)
		</td></tr>	
		<tr><td align="right">User ID:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td><input type="text" size="30" name="userid" value="#GetFedEx.UserKey#" class="formfield" maxlength="30"/></td>
		</tr>
		<tr><td align="right">Password:</td>
			<td width="3" style="background-color: ###Request.GetColors.formreq#;">&nbsp;</td>
			<td><input type="password" size="30" name="password" value="#GetFedEx.Password#" class="formfield" maxlength="30"/></td>
		</tr>
		<tr><td align="right">Meter Number:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" size="30" name="meternum" value="#GetFedEx.MeterNum#" class="formfield" maxlength="20"/></td>
		</tr>
		
		<cfinclude template="../../../../includes/form/put_space.cfm">
		
		<tr align="left">
			<td colspan="2" class="formtitle" nowrap="nowrap">
			Account Shipping Address
			</td>
			<td align="right" class="formtextsmall">
		</tr>
		<tr><td align="right">State/Province:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
	    <td><select name="Shipping_State" size="1" class="formfield">
		<cfloop query="GetStates">
   			<option value="#Abb#" <cfif GetFedEx.OrigState IS Abb>selected</cfif> >#Name# (#Abb#)</option>
		</cfloop></select>
		</td></tr>
		
		<tr><td align="right">Postal Code:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><input type="text" size="10" name="Shipping_Zip" class="formfield" value="#GetFedex.OrigZip#" maxlength="11"/></td></tr>
		
		<tr><td align="right">Country:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><select name="Shipping_Country" size="1" class="formfield">
			<option value="#ListGetAt(Request.AppSettings.HomeCountry, 1, "^")#">
			#ListGetAt(Request.AppSettings.HomeCountry, 2, "^")#</option>
 			<option value="#ListGetAt(Request.AppSettings.HomeCountry, 1, "^")#">___________________</option>
		<cfloop query="GetCountries">
   			<option value="#Abbrev#" <cfif GetFedEx.OrigCountry IS Abbrev>selected</cfif>>
			#Left(Name,28)#</option>
		</cfloop>
		</select></td></tr>

		<cfinclude template="../../../../includes/form/put_space.cfm">
		<cfinclude template="../../../../includes/form/put_requiredfields.cfm">
		</table>
		</td>

</tr>

<tr><td colspan="2" align="center"> <br/>

<div align="center"><input type="submit" name="submit_fedex" value="Next" class="formbutton"> 
<input type="button" value="Cancel" onclick="javascript:CancelForm();" class="formbutton"></div>
			
</td></tr>


</form>
</cfoutput>	
</cfmodule>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("fedex");

objForm.required("AccountNo,userid,password,meternum,Shipping_State,Shipping_Zip,Shipping_Country");

objForm.AccountNo.description = "Account Number";
objForm.userid.description = "User ID";
objForm.meternum.description = "Meter Number";
objForm.Shipping_State.description = "State/Province";
objForm.Shipping_Zip.description = "Zip/Postal Code";
objForm.Shipping_Country.description = "Country";

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
</script>
</cfprocessingdirective>
