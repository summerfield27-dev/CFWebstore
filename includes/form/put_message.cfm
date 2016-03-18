<!--- CFWebstore, version 6.50 --->

<!--- Used to output error messages on various admin pages --->

<!-- start includes\form\put_message.cfm -->
	<cfif len(attributes.Message)>
	<tr>
		<td colspan="3" align="center"><br/><span class="formerror"><cfoutput>#HTMLEditFormat(attributes.Message)#</cfoutput><br/><br/></td></tr>
	</cfif>
<!-- end includes\form\put_message.cfm -->

	