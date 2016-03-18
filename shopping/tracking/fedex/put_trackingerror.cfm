<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the shopping.tracking fuseaction and used to display the tracking error for FedEx Tracking. --->

<!--- <cfdump var="#Result#"> --->

<!-- start shopping/tracking/fedex/put_trackingerror.cfm -->
<div id="puttrackingerror" class="shopping">

<cfmodule template="../../../customtags/format_output_box.cfm"
box_title="FedEx Tracking - Shipment ###ShipNumber#"
width="500"
align="left"
>

	
<cfoutput>	
<table>
	<tr>
		<td colspan="3" align="center" class="formerror"><br/>#attributes.Message#<br/><br/></td></tr>
	</table>
</cfoutput>

</cfmodule><br/>

</div>
<!-- end shopping/tracking/fedex/put_trackingerror.cfm -->
