<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the shopping.tracking fuseaction and used to display the tracking information for the order for USPS Tracking. --->

<!--- <cfdump var="#Result#"> --->

<!-- start shopping/tracking/uspostal/put_tracking.cfm -->
<div id="puttracking" class="shopping">

<cfmodule template="../../../customtags/format_output_box.cfm"
box_title="U.S. Postal Service Tracking - Shipment ###ShipNumber#"
width="550"
align="left"
>

<!--- Determine status of shipment --->
<cfoutput>
<table width="100%">
<tr align="left"> 
<td class="trackbold" width="10%" nowrap="nowrap">U.S.P.S. Tracking Number:</td>
<td class="track" nowrap="nowrap">#Result.TrackNumber#</td>
</tr>
<tr align="left"> 
<td class="trackbold" nowrap="nowrap">Tracking Information:</td>
<td class="track" nowrap="nowrap">#Result.Summary#</td>
</tr>
<td colspan="2">&nbsp;</td>
</tr>
</table>

<cfif ArrayLen(Result.Activity)>

	<table width="100%" cellpadding="5" cellspacing="0">
	<tr>
	<th class="track">Package Activity</th>
	</tr>
	<cfscript>
	NumActivity = ArrayLen(Result.Activity);
	currclass = 1;
	</cfscript>
	<cfloop index="i" from="1" to="#NumActivity#">
	<cfscript>
		currInfo = Result.Activity[i];
		if (currInfo.XMLName IS "TrackDetail") 
			Info = currInfo.XMLText;
		else
			Info = "No Information Found";
		tagclass = currclass MOD 2;
	</cfscript>

	<tr>
	<td class="track#tagclass#">#Info#</td>
	</tr>
	</cfloop>
	</table>

</cfif>

</cfoutput>


</cfmodule>

</div>
<!-- end shopping/tracking/uspostal/put_tracking.cfm -->
