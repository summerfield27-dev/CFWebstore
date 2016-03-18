<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to edit the free shipping promotion. Displays any currently used shipping methods and allows the admin to select the ones to apply the promotion to, and set the order amount required. Called by shopping.admin&shipping=free --->

<cfinclude template="qry_settings.cfm">

<cfset GetMethods = Application.objShipping.getShipMethods( qry_get_ship_settings.shiptype )>


<cfprocessingdirective suppresswhitespace="no">
<cfhtmlhead text="
<script language=""JavaScript"">
	function CancelForm () {
	location.href = ""#self#?fuseaction=shopping.admin&shipping=editsettings&ship_id=#session.ship_ID#&redirect=yes#request.token2#"";
	}
</script>
">
</cfprocessingdirective>


<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Free Shipping Settings"
	width="600"
	required_fields="false"
	>
	
	<cfoutput>
	<form action="#self#?fuseaction=shopping.admin&shipping=free#request.token2#"  method="post" name="free">
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "shipFreeMethods">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">

	<cfinclude template="../../../includes/form/put_space.cfm">

		<tr>
			<td align="right" valign="top" width="35%">For Basket Total Over:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="65%">
			<input type="text" name="freeship_min" class="formfield" value="#iif(shipsettings.freeship_min IS NOT 0, NumberFormat(shipsettings.freeship_min, '0.00'), DE('0'))#" size="7" maxlength="15"/> #Request.AppSettings.MoneyUnit#
			</td>	
		</tr>

		<tr>
			<td align="right" valign="top">These Methods are FREE:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<cfif getmethods.recordcount gt 0>
			<cfloop query="getmethods">
				<input type="checkbox" name="freeship_shipids" value="#ID#" #doChecked(listfind(shipsettings.freeship_shipids,ID))# />#shipper# #name#<br/>
			</cfloop>
	
			<cfelse>
				<span class="formerror">No Shipping Methods currently available.</span>
			</cfif>
			</td>	
		</tr>			

		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="submit_free" value="Save" class="formbutton"/> 
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
			</td>	
		</tr>	
		<cfinclude template="../../../includes/form/put_requiredfields.cfm">
		
		<tr align="left"><td colspan=3>
	<table>
		<tr>
		<td width="175" align="center"><br/><cfoutput><img src="#Request.ImagePath#icons/fedex_sm.gif" alt="" width="130" height="50" border="0" align="left" /></cfoutput></td>
	<td class="formtext"><br/>
The FedEx service marks are owned by Federal Express Corporation and are used by permission.</i></td></tr>
	</table>
	</tr>
	
	</form>
</cfoutput>	
</cfmodule>


<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
objForm = new qForm("free");

objForm.required("freeship_min");

objForm.freeship_min.validateNumeric();
objForm.freeship_min.description = "minimum basket total";

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
</script>
</cfprocessingdirective>