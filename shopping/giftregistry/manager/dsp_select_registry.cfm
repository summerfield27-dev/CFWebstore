
<!--- CFWebstore, version 6.50 --->

<!--- Displays the list of registries for user to select when adding product(s). Called from act_add_item.cfm and act_add_items.cfm --->

<cfparam name="manage" default="additem">

<!-- start shopping/giftregistry/manager/dsp_select_registry.cfm -->
<div id="dspselectregistry" class="shopping">

<cfoutput>
	<form action="#XHTMLFormat('#request.self#?fuseaction=shopping.giftregistry&manage=#manage##request.token2#')#" method="post">
	<!--- pass product information fields --->
	<cfif isDefined("form.fieldnames")>
 		<cfloop index="form_vars" list="#form.fieldnames#">
   			<input type="hidden" name="#form_vars#" value="#HTMLEditFormat(form[form_vars])#"/>
  		</cfloop>
  	<cfelseif isDefined("attributes.Product_ID")>
  		<input type="hidden" name="Product_ID" value="#Val(attributes.Product_ID)#"/>
	</cfif>

	<cfmodule template="../../../customtags/format_input_form.cfm"
		box_title="Add Products to Registry"
		width="370"
		required_fields = "0"
		>

		<tr align="left">
			<td align="right"><br/><b>Select Gift Registry:</b></td>
			<td>&nbsp;</td>
			<td><br/><select name="GiftRegistry_ID" class="formfield">
				<cfloop query="qry_Get_registries">
					<option value="#GiftRegistry_ID#">#Event_Name#</option>
				</cfloop>
				</select>
			</td>
		</tr>	
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type="submit" name="selectRegistry" value="continue" class="formbutton"/></td>
		</tr>
	</cfmodule>
	</form>
	</cfoutput>

</div>
<!-- end shopping/giftregistry/manager/dsp_select_registry.cfm -->

