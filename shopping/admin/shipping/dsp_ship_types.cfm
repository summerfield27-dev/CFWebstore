<!--- CFWebstore, version 6.50 --->

<!--- Displays the form to list and update the tax codes. Called by shopping.admin&shipping=settings --->

<!--- shipping settings query automatically includes in all files in the shopping directory --->

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
    function edittype(shipid) {
	document.editform.Ship_ID.value = shipid;
	document.editform.submit();	
	}
	
	function confirmdelete(shipid) {
		var doDelete = confirm("Are you sure you want to delete this shipping type?")
		if (doDelete){
			document.editform.Ship_ID.value = shipid;
			document.editform.action.value = 'delete';	
			document.editform.submit();	
		}
	}

</script>
</cfprocessingdirective>

<cfset customList = "Price,Price2,Weight,Weight2,Items">
<cfset customNameList = "Amount by Price,Percent by Price,Amount by Weight,Percent by Weight,Amount per Item">

<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Shipping Types"
	Width="640">
	
	<cfoutput>
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext"	style="color:###Request.GetColors.InputTText#">
	
	<form name="editform" action="#self#?fuseaction=shopping.admin&shipping=editsettings#request.token2#" method="post">
	</cfoutput>
	<input type="hidden" name="Ship_ID" value=""/>
	<input type="hidden" name="action" value="edit"/>
	<cfset keyname = "shipSettings">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<cfinclude template="../../../includes/form/put_space.cfm">
	
	<tr>
		<th align="left">Shipping Type</th>
		<th align="center" nowrap="nowrap">Base Rate</th>
		<th align="center" nowrap="nowrap">Handling</th>
		<th align="center" nowrap="nowrap">Pickup?</th>
		<th align="center" nowrap="nowrap">Estimator?</th>
		<th align="center" nowrap="nowrap">Drop Shippers?</th>
		<th>&nbsp;</th>
	</tr>	
	
<cfoutput query="ShipSettings">
	<cfset theShipType = ShipSettings.ShipType>
	<cfif ListFind( customList, theShipType )>
		<cfset theShipType = ListGetAt( customNameList, ListFind( customList, theShipType ) )>
	</cfif>
	<tr>
		<td align="left">#theShipType#</td> 
		<td align="center">#LSCurrencyFormat(ShipBase)#</td>
		<td align="center">#(ShipHand * 100)#%</td>		
		<td align="center">#YesNoFormat(InStorePickup)#</td>
		<td align="center">#YesNoFormat(ShowEstimator)#</td>
		<td align="center">#YesNoFormat(UseDropShippers)#</td>
		<td align="center" nowrap="nowrap">
		<input type="button" name="edit" value="Edit" onclick="javascript:edittype(#ID#);" class="formbutton"/>
		<input type="button" name="delete" value="Delete" onclick="javascript:confirmdelete(#ID#);" class="formbutton"/> 
		</td>
	</tr>
</cfoutput>

	<tr>
		<td colspan="7" align="center"><br/>
		<!--- <input type="submit" name="submit_all" value="Update Shipping" class="formbutton"/>  --->
		<input type="button" name="JS" value="Add Shipping Type" onclick="javascript:edittype(0, this.value);" class="formbutton"/> 
		<br/><br/>
		</td>
	</tr>
	
	</form>
	</table>
	
</cfmodule>