
<!--- CFWebstore, version 6.50 --->

<!--- Displays the error message if no option choices were entered. Called from act_option.cfm --->


<cfmodule template="../../../../customtags/format_admin_form.cfm"
	box_title="Product Options"
	width="400"
	required_fields="0"
	>
			
	<tr><td align="center" class="formtitle">
	<br/>
			
	An option must have at least one selection!
	<br/><br/>	
		
	<table>
		<cfoutput>
		<tr>
			<td>
			<form action="#self#?fuseaction=Product.admin&do=options&product_id=#attributes.product_id#<cfif attributes.cid is not "">&cid=#attributes.cid#</cfif>#request.token2#" method="post">
			<input class="formbutton" type="submit" value="Back to Options"/>
			</form>		
			</td>
		</tr>
		</cfoutput>
	</table>	
</cfmodule>
