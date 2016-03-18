<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the shopping.tracking fuseaction and used to display the tracking information for the order for UPS Tracking. --->

<!--- <cfdump var="#Result#"> --->

<!-- start shopping/tracking/ups/put_trackingerror.cfm -->
<div id="puttrackingerror" class="shopping">

<cfmodule template="../../../customtags/format_output_box.cfm"
box_title="UPS OnLine<sup>&reg;</sup> Tools Tracking - Shipment ###ShipNumber#"
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
<!-- end shopping/tracking/ups/put_trackingerror.cfm -->

