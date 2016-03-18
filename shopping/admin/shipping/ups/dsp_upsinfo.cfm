<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for entering UPS registration info. Called by shopping.admin&shipping=upsinfo --->

<cfinclude template="qry_ups_settings.cfm">
<cfset attributes.GetUPS = 1>
<cfinclude template="../../../../queries/qry_getstates.cfm">
<cfinclude template="../../../../queries/qry_getcountries.cfm">
<cfset objUPS = CreateObject("component", "#Request.CFCMapping#.shipping.upstools").init()>

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
	box_title="UPS Developer API Settings"
	width="500"
	required_Fields="0"
	>	
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&shipping=upsinfo#request.token2#" method="post" name="ups">

	<cfinclude template="../../../../includes/form/put_space.cfm">
	<cfset keyname = "upsInfo">
	<cfinclude template="../../../../includes/act_add_csrf_key.cfm">
	
		<tr>
			<td align="center" valign="top" width="100"><img src="#Request.ImagePath#icons/ups_colorlogo.jpg" alt="" width="68" height="68" border="0" /></td>

		<tr align="left">
			<td colspan="2" class="formtitle" nowrap="nowrap">
			Account Registration 
			</td>
			<td align="right" class="formtextsmall">
		</tr>
		
		<tr><td align="right">UPS Account Number:</td>
			<td  style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" size="20" name="accountno" value="#GetUPS.AccountNo#" class="formfield" maxlength="20"/></td></tr>
		</tr>	
		
		<tr><td align="right">Username:</td>
		<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
		<td><input type="text" size="30" name="username" value="<cfif len(GetUPS.Username)>#objUPS.UPSDecrypt(GetUPS.Username)#<cfelse>#GetUPS.Username#</cfif>" class="formfield" maxlength="30"/></td></tr>
		<tr><td align="right">Password:</td>
		<td width="3" style="background-color: ###Request.GetColors.formreq#;">&nbsp;</td>
		<td><input type="password" size="30" name="password" value="<cfif len(GetUPS.Password)>#objUPS.UPSDecrypt(GetUPS.Password)#<cfelse>#GetUPS.Password#</cfif>" class="formfield" maxlength="20"/></td></tr>
		<tr><td align="right">Access Key:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><input type="text" size="30" name="accesskey" class="formfield" value="<cfif len(GetUPS.Accesskey)>#objUPS.UPSDecrypt(GetUPS.Accesskey)#<cfelse>#GetUPS.Accesskey#</cfif>" maxlength="20"/></td></tr>

		
		<cfinclude template="../../../../includes/form/put_space.cfm">		

		<tr align="left">
			<td colspan="2" class="formtitle" nowrap="nowrap">
			Account Shipping Address
			</td>
			<td align="right" class="formtextsmall">
		</tr>
		<tr><td align="right">City:</td>
		<td></td>
		<td><input type="text" size="10" name="OrigCity" value="#GetUPS.OrigCity#" class="formfield"  maxlength="75"/></td></tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
		Required for countries that do not use postal codes.
		</td></tr>
		
		<tr><td align="right">Postal Code:</td>
		<td></td>
		<td><input type="text" size="10" name="OrigZip" class="formfield" value="#GetUPS.OrigZip#" maxlength="20"/></td></tr>
		<tr><td colspan="2"></td><td class="formtextsmall">
		Required for countries that use postal codes<br/> (e.g. US and CA).
		</td></tr>
		
		<tr><td align="right">Country:</td>
		<td style="background-color: ###Request.GetColors.formreq#;"></td>
		<td><select name="OrigCountry" size="1" class="formfield">
			<option value="#ListGetAt(Request.AppSettings.HomeCountry, 1, "^")#">
			#ListGetAt(Request.AppSettings.HomeCountry, 2, "^")#</option>
 			<option value="#ListGetAt(Request.AppSettings.HomeCountry, 1, "^")#">___________________</option>
		<cfloop query="GetCountries">
   			<option value="#Abbrev#" #doSelected(GetUPS.OrigCountry,Abbrev)#>#Left(Name,28)#</option>
		</cfloop>
		</select></td></tr>

<cfinclude template="../../../../includes/form/put_space.cfm">
<cfinclude template="../../../../includes/form/put_requiredfields.cfm">

<tr><td colspan="3" align="center"> <br/>

<div align="center"><input type="submit" name="submit_ups" value="Next" class="formbutton"> 
<input type="button" value="Cancel" onclick="javascript:CancelForm();" class="formbutton"></div>
			
</td></tr>

<tr><td colspan="3" align="center"><br/>
<i>UPS, UPS brandmark, and the Color Brown are trademarks of<br/>
United Parcel Service of America, Inc. All Rights Reserved.</i></td></tr>
</td></tr>

</form>
</cfoutput>	
</cfmodule>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("ups");

objForm.required("accountno,username,password,accesskey,OrigCountry");

objForm.username.description = "Username";
objForm.accesskey.description = "Access Key";
objForm.accountno.description = "Account Number";
objForm.OrigCity.description = "City";
objForm.OrigZip.description = "Zip/Postal Code";
objForm.OrigCountry.description = "Country";

objForm.OrigZip.createDependencyTo("OrigCountry", "US"); 
objForm.OrigZip.createDependencyTo("OrigCountry", "AU");
objForm.OrigZip.createDependencyTo("OrigCountry", "CA");
objForm.OrigZip.createDependencyTo("OrigCountry", "FR");
objForm.OrigZip.createDependencyTo("OrigCountry", "DE");
objForm.OrigZip.createDependencyTo("OrigCountry", "MX");
objForm.OrigZip.createDependencyTo("OrigCountry", "NZ");
objForm.OrigZip.createDependencyTo("OrigCountry", "PR");
objForm.OrigZip.createDependencyTo("OrigCountry", "GB");

objForm.OrigCountry.enforceDependency();

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
</script>
</cfprocessingdirective>
