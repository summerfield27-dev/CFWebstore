
<!--- CFWebstore, version 6.50 --->

<!--- Displays the current shipping table for custom shipping rates and allows add or edit the rates. Called by shopping.admin&shipping=custom --->

<!--- get proper ship settings --->
<cfif isdefined('session.ship_id')>
	<cfquery dbtype="query" name="ShipSettings">
    select *
    from ShipSettings
    where ID = #session.ship_id#
    </cfquery>
</cfif>

<cfif isdefined("attributes.edit")>
	
	<cfquery name="GetRate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Shipping
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edit#">
	</cfquery>

	<cfloop list="minorder,maxorder,amount,id" index="counter">
		<cfset attributes[counter] = getrate[counter][1]>
	</cfloop>
	
	<cfset formbutton = "Update">
	
<cfelse><!--- add --->

	<cfset attributes.MinOrder = 0>
	<cfset attributes.MaxOrder = 0>
	<cfset attributes.Amount = 0>
	<cfset attributes.ID = 0>
	<cfset formbutton = "Add Rate">
	
</cfif>


<cfquery name="GetShipping" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Shipping
	ORDER BY MinOrder
</cfquery>

<cfoutput>
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
	function CancelForm() {
	location.href = '#self#?fuseaction=shopping.admin&shipping=editsettings&redirect=yes#request.token2#';
	}
</script>
</cfprocessingdirective>
</cfoutput>

<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Shipping Rates"
	Width="550">
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"	>

	<cfinclude template="../../../includes/form/put_space.cfm">
	
<!--- Add form ---->	

	<form name="editform" action="#self#?fuseaction=shopping.admin&shipping=custom#request.token2#" method="post">
	<input type="hidden" name="ID" value="#attributes.ID#"/>
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "customRates">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
		
	
		<tr>
			<td align="RIGHT" width="35%">Minimum Amount:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td width="65%"><input type="text" name="MinOrder" size="5" maxlength="10"  class="formfield" value="#NumberFormat(attributes.MinOrder, '0.00')#" /> 
<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Price2">#Request.AppSettings.MoneyUnit#
<cfelseif ShipSettings.ShipType IS "Items">Items
<cfelse>#Request.AppSettings.WeightUnit#</cfif>
			</td>	
		</tr>
	
		<tr>
			<td align="RIGHT">Maximum Amount:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<input type="text" name="MaxOrder" size="5" maxlength="10"value="#NumberFormat(attributes.MaxOrder, '0.00')#" class="formfield"/> 
<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Price2">#Request.AppSettings.MoneyUnit#
<cfelseif ShipSettings.ShipType IS "Items">Items
<cfelse>#Request.AppSettings.WeightUnit#</cfif>
			</td>	
		</tr>
	
	<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Weight" 
	OR ShipSettings.ShipType IS "Items">	
		<tr>
			<td align="RIGHT">Shipping Amount:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" name="Amount" size="5" maxlength="10"  value="#NumberFormat(attributes.Amount, '0.00')#" class="formfield"/> #Request.AppSettings.MoneyUnit#
			</td>	
		</tr>
	
	<cfelse>
		<tr>
			<td align="RIGHT">Shipping Percentage:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" name="Amount" size="5" maxlength="10"  value="#DecimalFormat(attributes.Amount * 100)#" class="formfield"/> %
			</td>	
		</tr>
	</cfif>	
	
		<tr>
			<td colspan="2"></td>
			<td><input type="submit" name="Submit_rate" value="#formbutton#" class="formbutton"/> 			
			<input type="button" value="Back to Settings" class="formbutton" onclick="CancelForm();" />
			</td>	
		</tr>	
		</form>
		
		<cfprocessingdirective suppresswhitespace="no">
		<script type="text/javascript">
		objForm = new qForm("editform");
		objForm.required("MinOrder,MaxOrder,Amount");
		
		objForm.MinOrder.validateNumeric();
		objForm.MaxOrder.validateNumeric();
		objForm.Amount.validateNumeric();
		
		objForm.MinOrder.description = "minimum amount";
		objForm.MaxOrder.description = "maximum amount";
		
		<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Weight" OR ShipSettings.ShipType IS "Items">
			objForm.Amount.description = "shipping amount";
		<cfelse>
			objForm.Amount.description = "shipping percentage";
		</cfif>
		
		qFormAPI.errorColor = "###Request.GetColors.formreq#";
		</script>
		</cfprocessingdirective>
		</cfoutput>
		
		<cfinclude template="../../../includes/form/put_requiredfields.cfm">
		
	</table>
	
	<hr />
	
	
<cfif GetShipping.RecordCount>	

	<cfset formkey = CreateUUID()>
	<cfset session.formKeys.ShipRateList = formkey>

	<table border="0" cellpadding="0" cellspacing="4" class="formtext" align="center" >
		<tr>
			<th align="left"><cfif ShipSettings.ShipType IS "Items">Item<cfelse>Order</cfif> Total</th>
			<th><cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Weight" OR ShipSettings.ShipType IS "Items">Amount<cfelse>Percentage</cfif></th>
			<th>&nbsp;</th>
		</tr>
	
		<cfoutput query="GetShipping">
		<tr>
			<td>
			<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Price2">
#LSCurrencyFormat(MinOrder)# - #LSCurrencyFormat(MaxOrder)#
			<cfelseif ShipSettings.ShipType IS "Items">
			#MinOrder# - #MaxOrder# 
			<cfelse>#DecimalFormat(MinOrder)# - #DecimalFormat(MaxOrder)# #Request.AppSettings.WeightUnit#</cfif>
			</td>
			
			<td>
			<cfif ShipSettings.ShipType IS "Price" OR ShipSettings.ShipType IS "Weight" OR ShipSettings.ShipType IS "Items">#LSCurrencyFormat(Amount)#<cfelse>#(Amount * 100)# %</cfif>
			</td>
			
			<td width="20%">[<a href="#self#?fuseaction=shopping.admin&shipping=custom&edit=#ID##Request.Token2#">edit</a>] [<a href="#self#?fuseaction=shopping.admin&shipping=custom&delete=#ID#&formkey=#Hash(formkey,"SHA-256")##Request.Token2#">delete</a>]</td>
		</tr>
		</cfoutput>
	</table>
<cfelse>
	<p align="center">No Shipping Rates Entered</p>
</cfif>	

</cfmodule>
