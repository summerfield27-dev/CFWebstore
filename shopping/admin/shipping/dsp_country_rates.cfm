
<!--- CFWebstore, version 6.50 --->

<!--- Displays the list of country shipping rates and allows the admin to set individual rates or reset all country rates at one time. Called by shopping.admin&shipping=country --->

<cfif isdefined("attributes.edit")>
	
	<cfquery name="GetRate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Abbrev, Name, AddShipAmount, ID 
		FROM #Request.DB_Prefix#Countries
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edit#">
	</cfquery>

	<cfloop list="abbrev,name,addshipamount,id" index="counter">
		<cfset attributes[counter] = getrate[counter][1]>
	</cfloop>
	
	<cfset formbutton = "Update">
	
<cfelse><!--- add --->

	<cfset attributes.Name = "">
	<cfset attributes.abbrev = "">
	<cfset attributes.AddShipAmount = 0>
	<cfset attributes.ID = 0>
	<cfset formbutton = "Add Rate">
	
</cfif>


<cfquery name="GetCountryRates" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Countries
	WHERE Shipping = 1
	ORDER BY Name
</cfquery>

<cfset Count_rates = valuelist(GetCountryRates.ID)>

<cfinclude template="../../../queries/qry_getcountries.cfm">

<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<script language=""JavaScript"">
		function CancelForm() {
		location.href = '#self#?fuseaction=shopping.admin&shipping=editsettings&redirect=yes#Request.Token2#';
		}
		
		function ConfirmAll() {
			if (confirm('Are you sure you want to do this? This will turn on custom\nshipping for all countries and set the rate for all countries,\nincluding those already added, to this percentage.')) {
		editform.AddAll.value = 'yes';
		editform.submit();
			}
		}
	</script>
">
</cfprocessingdirective>

<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Country Shipping Rates"
	Width="550">
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"	style="color:###Request.GetColors.InputTText#">

	<cfinclude template="../../../includes/form/put_space.cfm">
	
<!--- Add form ---->	

	<form name="editform" action="#self#?fuseaction=shopping.admin&shipping=country#request.token2#" method="post">
	<input type="hidden" name="ID" value="#attributes.ID#"/>
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "countryRates">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<cfif GetCountries.RecordCOunt IS NOT ListLen(Count_rates) OR isdefined("attributes.edit")>
		<tr>
			<td align="RIGHT" width="30%">Country:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="70%">
			<cfif isdefined("attributes.edit")>
				#attributes.Name#
			<cfelse>
				<select name="Country" size="1" class="formfield">
				<cfloop query="GetCountries">
					<cfif NOT ListFind(Count_rates,GetCountries.ID)>
  					<option value="#Abbrev#^#Name#">#Name#</option>
					</cfif>
				</cfloop>
				</select>
			</cfif>			
			</td>	
		</tr>
	
		<tr>
			<td align="RIGHT">Percent Added:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="text" name="AddShipAmount" size="5" maxlength="10" value="#DecimalFormat(attributes.AddShipAmount*100)#" class="formfield"/>%
			</td>	
		</tr>
	
		<cfinclude template="../../../includes/form/put_space.cfm">
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="Submit_rate" value="#formbutton#" class="formbutton"/> 
			</td>	
		</tr>	
		
		<tr>
			<td colspan="3"><cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#"/></td>
		</tr>			
		<cfinclude template="../../../includes/form/put_space.cfm">
		
	<cfelse>
		<input type="hidden" name="AddShipAmount" value="0"/>	
	</cfif>	
		<tr>
			<td align="RIGHT">Or set all countries <br/>to this rate:</td>
			<td></td><input type="hidden" name="AddAll" value="no"/>
			<td><input type="text" name="AllRate" size="5" maxlength="10" value="#DecimalFormat(attributes.AddShipAmount*100)#" class="formfield"/>% <input type="button" name="AddAllConfirm" value="Go" class="formbutton" onclick="ConfirmAll();" />

			</td>	
		</tr>	
		<cfinclude template="../../../includes/form/put_space.cfm">

	
		<tr>
			<td colspan="2"></td>
			<td><input type="button" value="Back to Settings" onclick="javascript:CancelForm();" class="formbutton"/>
			</td>	
		</tr>	
		</form>
		
		<cfprocessingdirective suppresswhitespace="no">
		<script type="text/javascript">
		objForm = new qForm("editform");
		
		objForm.required("AddShipAmount");
		
		objForm.AddShipAmount.validateNumeric();
		objForm.AddShipAmount.description = "percentage added";
		objForm.AllRate.validateNumeric();
		objForm.AllRate.description = "percentage added for all countries";
		
		qFormAPI.errorColor = "###Request.GetColors.formreq#";
		</script>
		</cfprocessingdirective>

		</cfoutput>
	</table>
	
	<cfmodule template="../../../customtags/putline.cfm" linetype="thin" linecolor="#Request.GetColors.InputHBgcolor#" width="98%"/>
	
	
<cfif GetCountryRates.RecordCount>	
	<cfset formkey = CreateUUID()>
	<cfset session.formKeys.CountryRateList = formkey>

	<table border="0" cellpadding="0" cellspacing="4" width="95%" class="formtext" align="center"
	style="color:#<cfoutput>#Request.GetColors.InputTText#</cfoutput>">
		<tr>
			<th align="left">Country</th>
			<th>Percent Added</th>
			<th>&nbsp;</th>
		</tr>
	
		<cfoutput query="GetCountryRates">
		<tr>
			<td>#Name#</td>
			
			<td align="center">#DecimalFormat(AddShipAmount*100)#%</td>
			
			<td width="20%">[<a href="#self#?fuseaction=shopping.admin&shipping=country&edit=#ID##Request.Token2#">edit</a>] 
<cfif request.appsettings.homecountry is not "#abbrev#^#name#">
[<a href="#self#?fuseaction=shopping.admin&shipping=country&delete=#ID#&formkey=#Hash(formkey,"SHA-256")##Request.Token2#">delete</a>]</cfif></td>
		</tr>
		</cfoutput>
	</table>
<cfelse>
	<p align="center">No Country Rates Entered<p>
</cfif>	

</cfmodule>
