
<!--- CFWebstore, version 6.50 --->

<!--- Displays the error message if no option choices were entered. Called from act_stdoption.cfm --->


<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Standard Option"
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
			<form action="#self#?fuseaction=product.admin&StdOption=list#request.token2#" method="post">
			<input class="formbutton" type="submit" value="Back to List"/>
			</form>		
			</td>
			
		<cfif isdefined("attributes.product_id")>			
			<td>
			<form action="#self#?fuseaction=product.admin&do=options&product_id=#attributes.product_id#<cfif isdefined("attributes.cid") and attributes.cid is not "">&cid=#attributes.cid#</cfif>#request.token2#" method="post">	
			<input class="formbutton" type="submit" value="Back to Product"/>
			</form>
			</td>
		</cfif>	
		</tr>
		</cfoutput>
	</table>	
</cfmodule>
